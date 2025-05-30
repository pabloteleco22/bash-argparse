#!/usr/bin/env bash

declare -A short_flags
declare -A long_flags
declare -A short_args
declare -A long_args
positional_args=()
required_parameters=()
declare -A param_description
declare description

do_if_bad_arg="do_if_bad_arg"
default_help_help="Show this help"
required_param_value_error='Error: value of %param% required'
required_param_error='Error: parameter %param% required'

print_help() {
    local flag_offset=20

    echo $description

    for k in ${positional_args[@]}; do
        printf "    %-${flag_offset}s    %s\n" "${k^^} " "${param_description[$k]}"
    done

    local keys=$(echo "${!short_flags[@]} ${!long_flags[@]}" | sed "s/ /\n/g" | sort -u)

    for k in $keys; do
        printf "    %-${flag_offset}s    %s\n" "$(echo ${short_flags[$k]} ${long_flags[$k]} | sed 's/ /, /g')" "${param_description[$k]}"
    done

    local keys=$(echo "${!short_args[@]} ${!long_args[@]}" | sed "s/ /\n/g" | sort -u)

    for k in $keys; do
        printf "    %-${flag_offset}s    %s\n" "$(echo ${short_args[$k]} ${long_args[$k]} | sed "s/ / ${k^^}, /g;s/$/ ${k^^}/g")" "${param_description[$k]}"
    done
}

_exit() {
    exit $1
}

help() {
    print_help
    _exit
}

process_args() {
    local keys="help $(echo ${!short_flags[@]} ${!long_flags[@]} ${!short_args[@]} ${!long_args[@]} | sed "s/ /\n/g" | sort -u)"

    if [[ -z "${short_flags[help]}" ]] && [[ -z "${long_flags[help]}" ]]; then
        short_flags[help]="-h"
        long_flags[help]="--help"
    fi

    test -z ${param_description[help]} && param_description[help]=$default_help_help

    local processed=1

    while [[ -n "$1" ]]; do
        processed=false
        local param="$1"

        for f in $keys; do
            if [[ "$1" = ${short_flags[$f]} ]] || [[ "$1" = ${long_flags[$f]} ]]; then
                shift;

                declare -F $f &> /dev/null && $f || declare -g "$f"=true

                processed=true
                break
            elif [[ "$1" = ${short_args[$f]} ]] || [[ "$1" = ${long_args[$f]} ]]; then
                shift;

                if [[ -z "$1" ]]; then
                    echo $required_param_value_error | sed "s/%param%/$param/g"
                    _exit;
                fi

                declare -F $f &> /dev/null && $f "$1" || declare -g "$f"="$1"

                shift
                processed=true
                break
            fi
        done
        if ! $processed ; then
            if [[ ${#positional_args[@]} -gt 0 ]]; then
                declare -g "${positional_args[0]}"="$1"
                positional_args=("${positional_args[@]:1}")
            else
                declare -F $do_if_bad_arg &> /dev/null && $do_if_bad_arg "$param"
            fi
            shift
        fi
    done

    for req in "${required_parameters[@]}"; do
        if [[ -z "${!req}" ]]; then
            echo $required_param_error | sed "s/%param%/$req/g"
            _exit 1
        fi
    done
}
