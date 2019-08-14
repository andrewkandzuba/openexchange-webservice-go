#!/usr/bin/env bash

if [[ ! -d ".git" ]]; then
   echo "fix git!"

   ls -las
   echo "before git init"
   git init -q
   echo "before git config"
   git config user.email "andrey.kandzuba@gmail.com"
   git config user.name "Andrew Kandzuba"
   echo "after git init"
   git add .
   echo "after git add"
   git commit -m "Initial commit"
   echo "after git commit"
fi