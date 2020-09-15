#!/bin/bash

# ##################################################
# Created on: Thu, 10 Sep 2020
# Created by: Sergei Petrosian
# Run this script from the directory where the satellite-sync.sh script is stored to run satellite-sync.sh for each downstream branch.
# ##################################################

for BRANCH in master $(git branch --list 'SATELLITE-*')
do
  if [ $BRANCH == "master" ]
  then
    sh satellite-sync.sh $BRANCH $BRANCH
  else
    sh satellite-sync.sh $BRANCH ${BRANCH#SATELLITE-}
  fi
done
