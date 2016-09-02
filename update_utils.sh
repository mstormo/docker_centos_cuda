#!/bin/bash

# source update_utils.sh
# ...then run which ever utility function

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
        git merge -Xtheirs master

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
