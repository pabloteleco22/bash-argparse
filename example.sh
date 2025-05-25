#!/usr/bin/env bash

source ./argparse.sh

## Flags
short_flags[flag]="-f"
short_flags[yes]="-y"

long_flags[solo]="--solo"
long_flags[flag]="--flag"

## Parameters with arguments
short_args[new]="-n"
short_args[with_param]="-c"

long_args[new]="--new"
long_args[other]="--other"

## Descriptions
description="Script description."
param_description[flag]="Help of flag"
param_description[solo]="Help of solo"
param_description[yes]="Help of yes"
param_description[new]="Help of new"
param_description[with_param]="Help of with_param"
#param_description[help]="Show this alternate help"

## Error messages
#required_param_error="Custom error message because param %param% is required"

## Functions of some arguments
flag() {
    echo flag $1
}

solo() {
    echo solo
}

yes() {
    echo yes
}

with_param() {
    echo with param $1
}

## Function to execute if we receive some bad argument
do_if_bad_arg() {
    echo "Argument $1 not supported"
    exit 1
}

## Help redefinition
help() {
    echo Things
    echo More things

    ## Print predefined help
    print_help

    echo Final things

    exit 1
}

## Processing arguments
process_args $@

## Show the value of arguments with no function declared
echo ------------------------
echo otro: $otro
echo nuevo: $nuevo
