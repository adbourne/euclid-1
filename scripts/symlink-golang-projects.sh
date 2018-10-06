#!/usr/bin/env bash

PROJECT_DOMAIN=

checkIfGoHomeIsSpecified()
{
    if [ -z ${GOPATH} ]; then
        echo "Environment variable \"GOPATH\" not set"
        exit 1
    else
        echo "Found \"GOPATH\" to be \"${GOPATH}\""
    fi
}

createProjectDomain()
{
    PROJECT_DOMAIN="${GOPATH}/src/github.com/seacitysoftware/"
    if [ ! -d ${PROJECT_DOMAIN} ]; then
        mkdir -p ${PROJECT_DOMAIN}
    else
        echo "Found project domain \"${PROJECT_DOMAIN}\""
    fi
}

symlinkProject()
{
    local project_name=$1
    local project_path="$(pwd)/functions/${project_name}"
    local symlink_path="${PROJECT_DOMAIN}${project_name}"
    if [ ! -d ${symlink_path} ]; then
        echo "Symlinking project \"${project_path}\" to be \"${symlink_path}\""
        ln -s ${project_path} ${symlink_path}
    else
        "Found symlink \"${symlink_path}\""
    fi
}

checkIfGoHomeIsSpecified
createProjectDomain
symlinkProject "collect-ea-river-levels"