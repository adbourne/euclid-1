#!/bin/bash

BUCKET_NAME=
LAMBDA_DIR="$(pwd)/functions/"

getBucketName()
{
    echo "Enter S3 bucket to deploy Lambdas to:"
    read BUCKET_NAME
    if [ -z ${BUCKET_NAME} ]; then
        echo "Bucket name not provided"
        exit 1
    fi
}

deployLambda()
{
    local lambda_name=$1
    local lambda_dir="${LAMBDA_DIR}${lambda_name}"
    if [ ! -d ${lambda_dir} ]; then
        echo "Lambda directory \"${lambda_dir}\" does not exist so cannot deploy"
        exit 1
    fi

    cd ${lambda_dir}
    make package

    local lambda_build_artifact="${lambda_dir}/build/main.zip"

    echo "Deploying Lambda \"${lambda_name}\" to S3 bucket \"${BUCKET_NAME}\"..."
    aws s3 cp ${lambda_build_artifact} s3://${BUCKET_NAME}/${lambda_name}.zip
}

getBucketName $@
deployLambda "collect-ea-river-levels"

