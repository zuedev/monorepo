#!/bin/bash

# This script will push all git repos in the GIT_REPOS_DIR to their mirrors
# defined in the .zuedev/mirrors file on the default branch.

GIT_REPOS_DIR="/home/git"
GITHUB_TOKEN=$(cat ~/.github_token)

# get all git repo directories in git repos directory
for repo in $(find $GIT_REPOS_DIR -name *.git -type d); do
    # cd into the repo
    cd $repo

    # do we have any mirrors in the .zuedev/mirrors file on the default branch?
    mirrors=$(git show HEAD:.zuedev/mirrors 2>/dev/null)

    if [ -z "$mirrors" ]; then
        echo "No mirrors found in: $repo"
        continue
    fi

    # loop through the mirrors
    for mirror in $mirrors; do
        # handle github.com mirrors
        if [[ $mirror == https://github.com* ]]; then
            # get the github repo name
            github_repo_slug=$(echo $mirror | cut -d'/' -f4-)

            # push to the github repo
            git push --mirror "https://zuedev:$GITHUB_TOKEN@github.com/$github_repo_slug"
        fi
    done
done
