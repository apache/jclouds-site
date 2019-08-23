#!/bin/bash

# Usage examples:
#
# Build the site using the default Jekyll version:
# $ ./deploy-site.sh [username] [password]

JEKYLL_VERSION=1.5.1

# Verify that the configured version of Jekyll is installed
jekyll _${JEKYLL_VERSION}_ --version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Jekyll ${JEKYLL_VERSION} is required"
    exit 1
fi

set -o errexit

jekyll _${JEKYLL_VERSION}_ build --safe

if [ ! -d "site-content" ]; then
  # Selectively checkout so we don't clone the entire javadocs that are not required here
  svn co https://svn.apache.org/repos/asf/jclouds/site-content --depth immediates
  cd site-content
  find . -maxdepth 1 -type d -not -name 'reference' -not -name '.' -not -name '.svn' | (while read D; do svn up "${D}" --set-depth infinity; done)
  svn up reference --set-depth immediates
  cd reference
  find . -maxdepth 1 -type d -not -name 'javadoc' -not -name '.' | (while read D; do svn up "${D}" --set-depth infinity; done)
  svn up javadoc --set-depth files
  cd ../..
else
  svn up site-content
fi

rsync -ar --delete \
    --exclude deploy-site.sh \
    --exclude deploy-javadoc.sh \
    --exclude site-content \
    --filter='protect .svn/' \
    --filter='protect reference/javadoc/**/*' \
    --filter='protect jclouds-site.iml' \
    _site/ site-content/

cd site-content

#delete removed files
for f in `svn status | grep '^!' | awk '{print $NF}'`; do svn rm $f; done

#add new files
svn status | awk '/^\?/{print $2}' | \
    while read filename; do svn --no-auto-props add $filename; done

if [ -z "$(svn status)" ]; then
    echo "No modified files in svn"
else
    echo "Modified files in svn:"

    svn status

    read -p "Are you sure you want to deploy the above changes? (y|n) "

    if [[ "$REPLY" == "y" ]]; then
        USERNAME_ARG=""
        if [ -n "$1" ]; then
            USERNAME_ARG="--username $1"
        fi

        svn commit --no-auth-cache $USERNAME_ARG --message 'deploy jclouds site content'
    fi
fi
