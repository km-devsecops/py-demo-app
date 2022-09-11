#!/bin/bash

# Parameters Check updated
COMMIT_ID=$1
S3_BUCKET=$2
AMPLIFY_ID=$3
GIT_BRANCH=$4

if [[ "$COMMIT_ID" == "" ]]; then
  echo "ERR: Commit ID is not specified."
  echo "Usage: ./deploy.sh <Commit ID> <S3 Bucket Name> <Amplify ID> <Branch>"
  exit 1
fi

if [[ "$S3_BUCKET" == "" ]]; then
  echo "ERR: S3 Bucket is not specified."
  echo "Usage: ./deploy.sh <Commit ID> <S3 Bucket Name> <Amplify ID> <Branch>"
  exit 1
fi

if [[ "$AMPLIFY_ID" == "" ]]; then
  echo "ERR: Amplify App ID is not specified."
  echo "Usage: ./deploy.sh <Commit ID> <S3 Bucket Name> <Amplify ID> <Branch>"
  exit 1
fi

if [[ "$GIT_BRANCH" == "" ]]; then
  echo "ERR: Git branch is not specified."
  echo "Usage: ./deploy.sh <Commit ID> <S3 Bucket Name> <Amplify ID> <Branch>"
  exit 1
fi

artifact="build-${COMMIT_ID}.zip"

if [ -f "$artifact" ] ; then
    echo "Clean up previously created archive"
    rm "$artifact"
fi

# Create the artifact
echo "Creating the artifact bundle .. "
cd build && zip -q -r ../$artifact . && cd ..

# Check if there is a checksum difference in the current artifact to existing S3 artifacts
echo "Fetch current deploy checksum"
CURRENT_MD5=$(find build/ -type f -exec md5sum {} \; | sort -k 2 | md5sum)

echo "Verify latest deploy checksum"
LATEST_MD5=$(aws s3api head-object --bucket $S3_BUCKET --key $artifact \
  | jq -r '.Metadata.md5')

if [ "$CURRENT_MD5" = "$LATEST_MD5" ]; then
    echo "Latest version of the artifact is already deployed"
else
    aws s3 cp $artifact s3://$S3_BUCKET/ --metadata md5="$CURRENT_MD5"

    # Get the latest Amplify job
    echo "Get latest Amplify job"
    aws amplify list-jobs \
        --app-id $AMPLIFY_ID \
        --branch-name $GIT_BRANCH \
        --max-items 1 > amplify-last-job.json

    # Store latest Amplify job status and id
    AMPLIFY_LAST_JOB_STATUS=$(cat amplify-last-job.json \
        | jq -r '.jobSummaries[].status')
    AMPLIFY_LAST_JOB_ID=$(cat amplify-last-job.json \
        | jq -r '.jobSummaries[].jobId')

    # Kill the last job if it is still pending from a previous deploy
    if [ "$AMPLIFY_LAST_JOB_STATUS" = "PENDING" ]; then
        aws amplify stop-job \
            --app-id $AMPLIFY_ID \
            --branch-name $GIT_BRANCH \
            --job-id $AMPLIFY_LAST_JOB_ID
    fi

    # Create a Amplify deployment
    echo "Create Amplify deployment"
    aws amplify create-deployment \
        --app-id $AMPLIFY_ID \
        --branch-name $GIT_BRANCH > amplify-deploy.json

    # Retrieve the newly created deployment ID and zip upload URL
    AMPLIFY_ZIP_UPLOAD_URL=$(cat amplify-deploy.json | jq -r '.zipUploadUrl')
    AMPLIFY_JOB_ID=$(cat amplify-deploy.json | jq -r '.jobId')

    # Upload the archive to Amplify
    echo "Upload archive .. "
    curl -H "Content-Type: application/zip" \
        $AMPLIFY_ZIP_UPLOAD_URL \
        --upload-file $artifact

    # Start the deployment
    echo "Initiate Amplify deployment"
    aws amplify start-deployment \
        --app-id $AMPLIFY_ID \
        --branch-name $GIT_BRANCH \
        --job-id $AMPLIFY_JOB_ID

    while true;
    do
        sleep 10

        # Poll the deployment job status every 10 seconds until it's not pending
        # anymore
        STATUS=$(aws amplify get-job \
            --app-id $AMPLIFY_ID \
            --branch-name $GIT_BRANCH \
            --job-id $AMPLIFY_JOB_ID \
            | jq -r '.job.summary.status')

        if [ $STATUS != 'PENDING' ]; then
          break
       fi
    done

    echo "Deployment status: $STATUS"
fi
