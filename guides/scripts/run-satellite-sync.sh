#!/bin/bash
for BRANCH in master $(git branch --list 'SATELLITE-*')
do
  if [ $BRANCH == "master" ]
  then
    sh satellite-sync.sh $BRANCH $BRANCH
  else
    sh satellite-sync.sh $BRANCH ${BRANCH#SATELLITE-}
  fi
done
