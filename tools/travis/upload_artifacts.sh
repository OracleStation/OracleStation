#!/bin/bash

if [ "$BUILD_TESTING" = true ] && [ "$TRAVIS_PULL_REQUEST" = false ]; then
	zip -r tgstation.zip _maps tgstation.dmb tgstation.rsc
	zip -r resources.zip tgstation.rsc
	aws s3 cp tgstation.dmb "s3://s3.oraclestation.com/$TRAVIS_BRANCH/$TRAVIS_JOB_NUMBER/tgstation.zip"
	aws s3 cp tgstation.rsc "s3://s3.oraclestation.com/$TRAVIS_BRANCH/$TRAVIS_JOB_NUMBER/resources.zip"
	aws s3 cp tgstation.dmb "s3://s3.oraclestation.com/$TRAVIS_BRANCH/latest/tgstation.zip"
	aws s3 cp tgstation.rsc "s3://s3.oraclestation.com/$TRAVIS_BRANCH/latest/resources.zip"
fi
