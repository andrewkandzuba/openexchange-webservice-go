#!/usr/bin/env bash

res=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com | grep Bad)
if [[ -n $res ]]
then
    echo "Error login!"
    exit 1
fi

res=$(curl -s -I https://api.github.com/repos/${TRAVIS_REPO_SLUG}/releases/tags/${TRAVIS_TAG}  | grep HTTP/1.1 | awk \{'print $2'\})
if [ "$res" == 404 ]
then
    curl -sL https://git.io/goreleaser | bash
fi

echo "Skept as release has already existed"