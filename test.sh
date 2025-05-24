#!/usr/bin/env bash

source ./argparse.sh

short_flags+=( ["solo"]="-s" )
short_flags+=( ["yes"]="-y" )

long_flags+=( ["solo"]="--solo" )
long_flags+=( ["otro"]="--otro" )

short_args+=( ["flag"]="-f" )
short_args+=( ["con_cosas"]="-c" )

long_args+=( ["flag"]="--flag" )
long_args+=( ["nuevo"]="--nuevo" )


description="Descripción del programa."
param_description+=( ["flag"]="Ayuda de flag" )
param_description+=( ["solo"]="Ayuda de solo" )
param_description+=( ["yes"]="Ayuda de yes" )
param_description+=( ["nuevo"]="Ayuda de nuevo" )
param_description+=( ["con_cosas"]="Ayuda de con_cosas" )

flag() {
    echo flag $1
}

solo() {
    echo solo
}

yes() {
    echo yes
}

con_cosas() {
    echo con cosas $1
}

process_args $@
