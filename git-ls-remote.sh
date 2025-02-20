#!/bin/bash

git ls-remote --heads --sort=-committerdate | head -n 10 | awk '{ print $2 }' | cut -d'/' -f3-
