#!/bin/bash

# source update_utils.sh
# ...then run which ever utility function

source install/utils.sh

showRemoteBranches() {
    branches=()
    eval "$(git for-each-ref --shell --format='branches+=(%(refname))' refs/remotes/origin/)"
    for branch in "${branches[@]}"; do
        case "$branch" in
            *master|*HEAD)
                continue
                ;;
        esac
        echo ${branch#refs/remotes/origin/}
    done
}

removeLocalBranches() {
    branches=()
    eval "$(git for-each-ref --shell --format='branches+=(%(refname))' refs/remotes/origin/)"
    for branch in "${branches[@]}"; do
        case "$branch" in
            *master|*HEAD)
                continue
                ;;
        esac
        git branch -D ${branch#refs/remotes/origin/}
    done
}

createMergeAndUpdateLocalBranches() {
    branches=()
    eval "$(git for-each-ref --shell --format='branches+=(%(refname))' refs/remotes/origin/)"
    for branch in "${branches[@]}"; do
        case "$branch" in
            *master|*HEAD)
                continue
                ;;
        esac
		local_branch=${branch#refs/remotes/origin/}
		local_os=$(echo $local_branch | cut -f1 -d_)
		local_cuda=$(echo $local_branch | cut -f2 -d_)

        echo Branch: $local_branch, OS: $local_os, CUDA: $local_cuda
        git checkout -b $local_branch $branch
        GIT_MERGE_AUTOEDIT=no git merge --no-edit -Xtheirs master

		sed -i -e "s/\(ARG os_ver\).*/\1=$local_os/m" -e "s/\(ARG cuda_ver\).*/\1=$local_cuda/m" Dockerfile
		case "$local_os" in
			5)
				sed -i -e 's/.*\(FROM centos:5\)/\1/m' -e 's/.*\(FROM centos:[67]\)/#\1/m' Dockerfile
				;;
			6)
				sed -i -e 's/.*\(FROM centos:6\)/\1/m' -e 's/.*\(FROM centos:[57]\)/#\1/m' Dockerfile
				;;
			7)
				sed -i -e 's/.*\(FROM centos:7\)/\1/m' -e 's/.*\(FROM centos:[56]\)/#\1/m' Dockerfile
				;;
		esac
		git commit -m "Update Dockerfile for CentOS $local_os, Cuda $local_cuda" Dockerfile
    done
}

buildAndPush() {
    remote_repo=$1
    echo Do you want to build and push all local branches to ${remote_repo}:\<branches\>?
    read -p "[Enter to continue, Ctrl+C to stop]"

    branches=()
    eval "$(git for-each-ref --shell --format='branches+=(%(refname))' refs/heads/)"
    echo Will build the following branches ------------ > build.log
    for branch in "${branches[@]}"; do
        local_branch=${branch#refs/heads/}
        echo $local_branch >> build.log
    done

    echo >> build.log
    echo Building  ------------------------------------------------------------ >> build.log

    echo remote repo: $remote_repo
    for branch in "${branches[@]}"; do
        local_branch=${branch#refs/heads/}

        echo Branch.. $local_branch -------------------------------------------
        echo $(date +"[%D %T]") Building $local_branch ----- >> build.log
        git checkout -f $local_branch

        [ "$local_branch" == "master" ] && local_branch=latest

        docker build -t local_build .
        rc=$?; if [[ $rc != 0 ]]; then continue; fi

        echo $(date +"[%D %T]") pushing build... >> build.log
        docker tag local_build ${remote_repo}:${local_branch}
        docker push ${remote_repo}:${local_branch}
        echo $(date +"[%D %T]") build done... >> build.log
    done
}
