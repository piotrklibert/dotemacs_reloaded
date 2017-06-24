#! /usr/bin/env bash

ssh vps 'cd ~/git/forks/ && git clone --bare https://github.com/davidmiller/pony-mode.git'
git submodule add vps:git/forks/pony-mode
