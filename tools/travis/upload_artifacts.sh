#!/bin/bash

if [ "$BUILD_TESTING" = true ] && [ "$TRAVIS_PULL_REQUEST" = false ] && [ $AWS_SECRET_ACCESS_KEY ]; then
	echo "Creating archives..."
	echo "$TRAVIS_COMMIT" > COMMIT_HASH
	zip -r tgstation _maps strings sound html tgstation.dmb tgstation.rsc COMMIT_HASH > /dev/null
	echo "tgstation.zip completed"
	zip -r resources tgstation.rsc > /dev/null
	echo "resources.zip completed"

	echo "Verifying archives..."
	zip -T tgstation.zip
	zip -T resources.zip

	echo "Uploading to S3..."
	aws s3 cp tgstation.zip "s3://s3.us-east-1.oraclestation.com/$TRAVIS_BRANCH/latest/tgstation.zip"
	aws s3 cp resources.zip "s3://s3.us-east-1.oraclestation.com/resources/$TRAVIS_COMMIT.rsc.zip"
	aws s3 cp COMMIT_HASH   "s3://s3.us-east-1.oraclestation.com/$TRAVIS_BRANCH/latest/COMMIT_HASH"
fi
