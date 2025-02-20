#!/bin/bash

# reset to previous commit and keep changes
git reset --soft HEAD^

# unstage all changes
git reset HEAD .
