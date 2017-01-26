#!/bin/bash
# Gets (if available) git/hg branch name and changeset hash[:5] in current directory
# 2015 Jim Le <jim@height.io>
#
# Motivation: Learning bash scripting
#
# 1) runs a bash command everytime/only when you execute a command with the prompt
#       1a) if repo changes branch/changeset within another prompt, it won't update
#           in your current one. Run any command though to trigger the update.
# 2) Only works in the directory with .git or .hg folders
#       2a) Which means going into the repo subdirectories will clear the info
#           from the prompt. There is probably a #TODO to fix this but not priority
#           for my daily workflow.

function getCurrentBranch {
    if [ -d .git ];
    then
        _branch=$(git branch | grep -o "\* .*" | sed -ne 's/* //p');
        if [ "$_branch" != "" ];
        then
            if [[ "$_branch" != "("HEAD* ]]; # check for detached head
            then
                _changeset=$(git rev-parse "$_branch" | cut -c 1-5);
                echo "$_branch:$_changeset ";
            else
                echo "$_branch ";
            fi
        else
            echo "... ";
        fi
    elif [ -d .hg ];
    then
        _branch=$(hg branch)
        if [ "$_branch" != "" ];
        then
            _changeset=$(hg id | sed -ne 's/\([a-z0-9]*\)[ a-z]*/\1/p' | cut -c 1-5);
            echo "$_branch:$_changeset ";
        else
            echo "... ";
        fi
    fi
}

# append to your current prompt, if that works for you
export PS1="$PS1 $(getCurrentBranch)"

# This is my current prompt
# looks like this:
#   $ <color:yellow>$PWD</color> <color:lightblue>$Branch:$changeset</color> 
export PS1="\e[1;30m\$\e[m \e[1;33m\w \e[m\e[1;32m\$(getCurrentBranch)\e[m"

