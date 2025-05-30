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

## Positional arguments
positional_args+=("file1")
positional_args+=("file2")

## Descriptions
description="Script description."
param_description[flag]="Help of flag"
param_description[solo]="Help of solo"
param_description[yes]="Help of yes"
param_description[new]="Help of new"
param_description[with_param]="Help of with_param"
param_description[file1]="Help of file1"
param_description[file2]="Help of file2"
#param_description[help]="Show this alternate help"

required_parameters=("file1" "yes")

## Error messages
#required_param_error="Custom error message because param %param% is required"
#required_param_value_error="Custom error message because the value of param %param% is required"

## Functions of some arguments
flag() {
    echo flag
}

solo() {
    echo solo
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
process_args "$@"

## Show the value of arguments with no function declared
echo ------------------------
echo yes: $yes
echo new: $new

echo file1: $file1
echo file2: $file2
