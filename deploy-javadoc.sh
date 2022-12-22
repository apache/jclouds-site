#!/bin/bash

set -o errexit

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


JAVA_VERSION=`java -version 2>&1 | sed -n ';s/.* version "\(.*\)\.\(.*\)\..*".*/\1\2/p;'`
if [ "$JAVA_VERSION" -lt "17" ]; then
  echo "Use Java 1.7+ to generate the Javadoc."
  exit 1
fi

if [ -z "$1" ]; then
  echo "Usage: $0 <JCLOUDS_VERSION>"
  echo "Example: $0 1.8.0"
  exit 1
fi

JCLOUDS_VERSION=$1
JCLOUDS_VERSION_X=`echo $JCLOUDS_VERSION | cut -c 1-3 | awk '{print $1".x"}'`

cd $TMPDIR

for name in jclouds; do
  rm -rf ${name}
  git clone --branch rel/${name}-${JCLOUDS_VERSION} --depth 1 https://git-wip-us.apache.org/repos/asf/${name}.git
  cd ${name}
  git checkout rel/${name}-${JCLOUDS_VERSION}
  cd ..
done

cd jclouds
mvn -Pdoc clean javadoc:aggregate -Dnotimestamp=true -DadditionalJOption=-J-Xmx512m


if [ ! -d "site-content" ]; then
  svn co https://svn.apache.org/repos/asf/jclouds/site-content
else
  svn up site-content
fi
cd $DIR/site-content

mkdir -p reference/javadoc/$JCLOUDS_VERSION_X/
rsync -r --ignore-times $TMPDIR/jclouds/target/site/apidocs/ reference/javadoc/$JCLOUDS_VERSION_X/

svn status | awk '/^\?/{print $2}' | \
    while read filename; do svn --no-auto-props add $filename; done

if [ -z "$(svn status)" ]; then
    echo "No modified files in svn"
else
    echo "Modified files in svn:"

    svn status

    read -p "Are you sure you want to deploy the above changes? (y|n) "
    [[ ${REPLY} == "y" ]] || exit 0 ]]
    
    echo

    svn commit --message 'deploy jclouds javadoc site content'
fi
