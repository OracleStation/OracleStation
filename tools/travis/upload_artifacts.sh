#!/bin/bash

if [ "$BUILD_TESTING" = true ] && [ "$TRAVIS_PULL_REQUEST" = false ]; then
	zip -r tgstation _maps tgstation.dmb tgstation.rsc
	zip -r resources tgstation.rsc
	aws s3 cp tgstation.zip "s3://s3.oraclestation.com/$TRAVIS_BRANCH/$TRAVIS_JOB_NUMBER/tgstation.zip"
	aws s3 cp resources.zip "s3://s3.oraclestation.com/$TRAVIS_BRANCH/$TRAVIS_JOB_NUMBER/resources.zip"
	aws s3 cp tgstation.zip "s3://s3.oraclestation.com/$TRAVIS_BRANCH/latest/tgstation.zip"
	aws s3 cp resources.zip "s3://s3.oraclestation.com/$TRAVIS_BRANCH/latest/resources.zip"
fi
