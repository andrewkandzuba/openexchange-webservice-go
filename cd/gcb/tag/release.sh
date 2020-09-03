#!/usr/bin/env bash

res=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com | grep Bad)
if [[ -n $res ]]
then
    echo "Error login!"
    exit 1
fi

res=$(curl -s -I https://api.github.com/repos/${REPO_NAME}/releases/tags/${TAG_NAME}  | grep HTTP/1.1 | awk \{'print $2'\})
echo ${res}
if [[ "$res" == "404" ]]
then
    curl -sL https://git.io/goreleaser | bash -s -- config=./cd/gcb/tag/.goreleaser.yml
fi

echo "Release ${TAG_NAME} is already existed"