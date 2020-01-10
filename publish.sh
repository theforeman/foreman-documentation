#!/bin/bash
pushd guides
make clean html
rsync -vr build/ web02.theforeman.org:/var/www/vhosts/docs/htdocs/current/
popd
rsync -vr web/ web02.theforeman.org:/var/www/vhosts/docs/htdocs/
