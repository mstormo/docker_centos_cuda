#!/bin/sh

now() {
    [[ ! $1 ]] && echo $(date +%s) && return

    eval $1=$(date +%s)
}

elapsed() {
    [[ ! $1 ]] && echo "$FUNCNAME missing start time as first parameter." && return

    local secs_to=$(date +%s)
    [[ $2 ]] && secs_to=$2

    local secs_total=$(($secs_to-$1))
    local time_laps=$(date -u -d@"$secs_total" +'%0Hh%0Mm%0Ss')
    echo $time_laps
}

echo_elapsed() {
    local arg=$1 && shift
    local elapsed_time=$(elapsed $arg)
    echo $elapsed_time : $*
}

echo_total() {
    local from=$1 && shift
    local to=$1 && shift
    local elapsed_time=$(elapsed $from $to)
    echo $elapsed_time : $*
}
