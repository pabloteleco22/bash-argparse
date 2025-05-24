#!/usr/bin/env bash

declare -A short_flags
declare -A long_flags
declare -A short_args
declare -A long_args
declare -A param_description
declare description


help() {
    local flag_offset=20

    echo $description

    keys=$(echo "${!short_flags[@]} ${!long_flags[@]}" | sed "s/ /\n/g" | sort -u)

    for k in $keys; do
        printf "    %-${flag_offset}s    %s\n" "$(echo ${short_flags[$k]} ${long_flags[$k]} | sed 's/ /, /g')" "${param_description[$k]}"
    done

    keys=$(echo "${!short_args[@]} ${!long_args[@]}" | sed "s/ /\n/g" | sort -u)

    for k in $keys; do
        printf "    %-${flag_offset}s    %s\n" "$(echo ${short_args[$k]} ${long_args[$k]} | sed "s/ / ${k^^}, /g;s/$/ ${k^^}/g")" "${param_description[$k]}"
    done

    exit
}

process_args() {
    keys="help $(echo ${!short_flags[@]} ${!long_flags[@]} ${!short_args[@]} ${!long_args[@]} | sed "s/ /\n/g" | sort -u)"

    short_flags+=( [help]="-h" )
    long_flags+=( [help]="--help" )
    param_description+=( ["help"]="Muestra esta ayuda" )

    local processed=1

    while [[ -n "$1" ]]; do
        processed=1

        for f in $keys; do
            if [[ "$1" = ${short_flags[$f]} ]] || [[ "$1" = ${long_flags[$f]} ]]; then
                shift;

                $f

                processed=0
                break
            elif [[ "$1" = ${short_args[$f]} ]] || [[ "$1" = ${long_args[$f]} ]]; then
                shift;

                if [[ -z "$1" ]]; then
                    echo "Error: parameter of ${short_args[$f]} required"
                    exit;
                fi

                $f $1

                shift
                processed=0
                break
            fi
        done
        if [[ $processed -ne 0 ]]; then
            shift
        fi
    done
}
