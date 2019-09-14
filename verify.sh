#!/bin/sh

# Semantic Versioning 2.0.0 guideline
# 
# Given a version number MAJOR.MINOR.PATCH, increment the:
# MAJOR version when you make incompatible API changes, (breaking|major|BREAKING CHANGE)
# MINOR version when you add functionality in a backwards-compatible manner, and (feature|minor|feat)
# PATCH version when you make backwards-compatible bug fixes. (fix|patch|docs|style|refactor|perf|test|chore)
#
# feat: A new feature
# fix: A bug fix
# docs: Documentation only changes
# style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
# refactor: A code change that neither fixes a bug nor adds a feature
# perf: A code change that improves performance
# test: Adding missing or correcting existing tests
# chore: Changes to the build process or auxiliary tools and libraries such as documentation generation
#
# Also a cool tool : https://github.com/fteem/git-semantic-commits
# to creat commit messages based on Semver.
#
printf "Starting the tagging process based on commit message Semantic Versioning 2.0.0 guideline\n\n"
printf 'feat: \t\tA new feature\nfix: \t\tA bug fix\ndocs: \t\tDocumentation only changes\nstyle: \t\tChanges that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)\nrefactor: \tA code change that neither fixes a bug nor adds a feature\nperf: \t\tA code change that improves performance\ntest: \t\tAdding missing or correcting existing tests\nchore: \t\tChanges to the build process or auxiliary tools and libraries such as documentation generation\n\n!'
GIT_REV_LIST=`git rev-list --tags --max-count=1`
VERSION='0.0.0'
if [[ -n $GIT_REV_LIST ]]; then
    VERSION=`git describe --tags $GIT_REV_LIST`
fi
# split into array
VERSION_BITS=(${VERSION//./ })
echo "Latest version tag: $VERSION"
#get number parts and increase last one by 1
VNUM1=${VERSION_BITS[0]}
VNUM2=${VERSION_BITS[1]}
VNUM3=${VERSION_BITS[2]}

MAJOR_COUNT_OF_COMMIT_MSG=`git log -1 --pretty=%B | egrep -c '^(breaking|major|BREAKING CHANGE)'`
MINOR_COUNT_OF_COMMIT_MSG=`git log -1 --pretty=%B | egrep -c '^(feature|minor|feat)'`
PATCH_COUNT_OF_COMMIT_MSG=`git log -1 --pretty=%B | egrep -c '^(fix|patch|docs|style|refactor|perf|test|chore)'`
if [ $MAJOR_COUNT_OF_COMMIT_MSG -gt 0 ]; then
    VNUM1=$((VNUM1+1))
    VNUM2=0
    VNUM3=0
fi
if [ $MINOR_COUNT_OF_COMMIT_MSG -gt 0 ]; then
    VNUM2=$((VNUM2+1))
    VNUM3=0
fi
if [ $PATCH_COUNT_OF_COMMIT_MSG -gt 0 ]; then
    VNUM3=$((VNUM3+1)) 
fi
# count all commits for a branch
GIT_COMMIT_COUNT=`git rev-list --count HEAD`
echo "Commit count: $GIT_COMMIT_COUNT" 
#create new tag
NEW_TAG="$VNUM1.$VNUM2.$VNUM3"
echo "Updating $VERSION to $NEW_TAG"
#only tag if commit message have version-bump-message as mentioned above
if [ $MAJOR_COUNT_OF_COMMIT_MSG -gt 0 ] ||  [ $MINOR_COUNT_OF_COMMIT_MSG -gt 0 ] || [ $PATCH_COUNT_OF_COMMIT_MSG -gt 0 ]; then
    echo "Tagged with $NEW_TAG"
else
    echo "Already a tag on this commit"
fi
echo $NEW_TAG > NEXT_VERSION
