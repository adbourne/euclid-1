#!/bin/bash

BUCKET_NAME=
UI_DIR=./ui/build

getBucketName()
{
    echo "Enter S3 bucket to deploy UI to:"
    read BUCKET_NAME
    if [ -z ${BUCKET_NAME} ]; then
        echo "Bucket name not provided"
        exit 1
    fi
}

deployUi()
{
    if [ ! -d ${UI_DIR} ]; then
        echo "UI directory \"${UI_DIR}\" does not exist so cannot deploy"
        exit 1
    fi
    echo "Deploying UI to S3 bucket \"${BUCKET_NAME}\"..."
    aws s3 sync ${UI_DIR} s3://${BUCKET_NAME}/
}

printWebsiteUrl()
{
    echo "Check website using URL: http://${BUCKET_NAME}.s3-website-eu-west-1.amazonaws.com"
}

getBucketName $@
deployUi
printWebsiteUrl

