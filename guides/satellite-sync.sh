#!/bin/bash

# ##################################################
# Created on: Fri, 23 Oct 2019
# Created by: Andrew Dahms
# Hacked repeately by Melanie Corr to accomodate transitions towards Upstream-Downstream Satellite
# ##################################################

echo ========================================
echo Satellite Upstream-Downstream Synchronizer
echo ========================================
echo

# If the first script parameter (master) $1 is empty, print No upstream branch specified - exiting... and exit.
if [ -z "$1" ];
then
  printf 'No upstream branch specified - exiting...\n\n'
  exit 2
fi

# If the second script parameter $2 (downstream branch, eg, osp13-queens) is empty, print No downstream branch specified - exiting... and exit.
if [ -z "$2" ];
then
  printf 'No downstream branch specified - exiting...\n\n'
  exit 2
fi

# Declaration of variables. US_BRANCH now has the value of the first parameter passed through on the command line, for example, master.
US_BRANCH=$1
DS_BRANCH=$2

# Declaration of repo variables.
US_REPO=foreman-documentation
DS_REPO=docs-Red_Hat_Satellite_6

# Step 1 - Check for updates
# If US_REPO is an existing directory
if [ -d $US_REPO ]
then
  # Print message, change to the directory, checkout the branch, and update it.
  echo "Local copy of upstream repository found on server - fetching updates..."
  cd $US_REPO
  git checkout $US_BRANCH
  git pull
  cd ..
else
  # Print message, clone the repo, change to the directory, checkout the branch, and update it.
  echo "Local copy of upstream repository not found on server - cloning..."
  git clone git@github.com:theforeman/foreman-documentation.git
  cd $US_REPO
  git pull
  git checkout $US_BRANCH
  git pull
  cd ..
fi

if [ -d $DS_REPO ]
then
  echo "Local copy of downstream repository found on server - fetching updates..."
  cd $DS_REPO
  git pull
  git checkout $DS_BRANCH
  git pull
  cd ..
else
  echo "Local copy of downstream repository not found on server - cloning..."
  git clone git@gitlab.cee.redhat.com:satellite-6-documentation/docs-Red_Hat_Satellite_6.git
  cd $DS_REPO
  git pull
  git checkout $DS_BRANCH
  git pull
  cd ..
fi

# Step 2 - Copy common directory
cp -r $US_REPO/guides/common/* $DS_REPO/common/

# Step 3 - Copy docs-* directories, if any
if ls $US_REPO/guides/doc-* 1> /dev/null 2>&1; then
  cp -r $US_REPO/guides/doc-Provisioning_Guide/* $DS_REPO/doc-Provisioning_Guide/
  cp  $US_REPO/guides/doc-Installing_Server_on_Red_Hat/master.adoc $DS_REPO/doc-Installing_Satellite_Server_Connected/master.adoc
  cp  $US_REPO/guides/doc-Installing_Proxy_on_Red_Hat/master.adoc $DS_REPO/doc-Installing_Capsule_Server/master.adoc
  cp  $US_REPO/guides/doc-Installing_Satellite_Server_Disconnected/master.adoc $DS_REPO/doc-Installing_Satellite_Server_Disconnected/master.adoc
  cp  $US_REPO/guides/doc-Installing_Server_on_Red_Hat/docinfo.xml $DS_REPO/doc-Installing_Satellite_Server_Connected/docinfo.xml
  cp  $US_REPO/guides/doc-Installing_Proxy_on_Red_Hat/docinfo.xml $DS_REPO/doc-Installing_Capsule_Server/docinfo.xml
  cp  $US_REPO/guides/doc-Installing_Satellite_Server_Disconnected/docinfo.xml $DS_REPO/doc-Installing_Satellite_Server_Disconnected/docinfo.xml
  cp -r $US_REPO/guides/doc-Content_Management_Guide/* $DS_REPO/doc-Content_Management_Guide/

fi
# Add downstream build attributes and find and replace attributes with fixed terms

cd $DS_REPO
sed 's/:SatelliteAnsibleVersion: 2.8/:SatelliteAnsibleVersion: 2.8\n:build: satellite/g' common/attributes.adoc > common/attributes.tmp
mv common/attributes.tmp common/attributes.adoc
sed 's/:TargetVersion: 6.7-beta/:TargetVersion: 6.7/g' common/attributes.adoc > common/attributes.tmp
mv common/attributes.tmp common/attributes.adoc
sed 's/:ProductVersion: 6.7-beta/:ProductVersion: 6.7/g' common/attributes.adoc > common/attributes.tmp
mv common/attributes.tmp common/attributes.adoc
sed 's/:ProductVersionPrevious: 6.6/:ProductVersionPrevious: 6.6/g' common/attributes.adoc > common/attributes.tmp
mv common/attributes.tmp common/attributes.adoc
find common -name '*.adoc' -type f -exec sed -i -e 's/{project-context}/satellite/g' -- {} +
find common -name '*.adoc' -type f -exec sed -i -e 's/{smart-proxy-context}/capsule/g' -- {} +

# Step 4 - Commit and push changes, if any
if [ `git status | wc -l` == 2 ]
then

  cd ..
  echo No changes detected - exiting...

else

  if [ -z "$3" ] & [ "$3" == "--noop" ];
  then

    echo Changes found, but not committed.

  else


    # stream the synchronization

    # Commit changes
    COMMIT=`date +"%m-%d-%Y %H:%M:%S"`

    git add *
    git commit -m "Upstream updates to $DS_BRANCH-$US_BRANCH from ${COMMIT}." > /dev/null 2>&1

    ID=`git log -1 --pretty=oneline | cut -d ' ' -f1`

    git push origin $DS_BRANCH > /dev/null 2>&1

    cd ..

    echo Committed ${ID}.

  fi

fi
