#! /usr/bin/env bash
set +e
for x in $(find . -maxdepth 1 -type d | tail -n +2); do
    cd $x
    echo $x
    git pull
    cd ..
done

