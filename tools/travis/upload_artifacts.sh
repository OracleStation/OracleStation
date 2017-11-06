#!/bin/bash

if [ "$BUILD_TESTING" = true ] && [ "$TRAVIS_PULL_REQUEST" = false ]; then
	aws s3 cp tgstation.dmb "s3://s3.oraclestation.com/$TRAVIS_BRANCH/$TRAVIS_JOB_NUMBER/tgstation.dmb"
	aws s3 cp tgstation.rsc "s3://s3.oraclestation.com/$TRAVIS_BRANCH/$TRAVIS_JOB_NUMBER/tgstation.rsc"
	aws s3 cp tgstation.dmb "s3://s3.oraclestation.com/$TRAVIS_BRANCH/latest/tgstation.dmb"
	aws s3 cp tgstation.rsc "s3://s3.oraclestation.com/$TRAVIS_BRANCH/latest/tgstation.rsc"
fi
