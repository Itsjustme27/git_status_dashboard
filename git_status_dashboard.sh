#!/bin/bash

# Set the directory containing my Git Repos
BASE_DIR=~/Documents/github

# Check if the directory exists
if [[ ! -d "$BASE_DIR" ]]; then
	echo "Directory $BASE_DIR does not exist. Please update the script"
	exit 1
fi


# Loop through all subdirectories in BASE_DIR

echo "Scanning for Git repositories in $BASE_DIR..."

for dir in "$BASE_DIR"/*; do
	# Check if it's a directory and contains a .git folder
	if [[ -d "$dir" && -d "$dir/.git" ]]; then
		echo "-----------------------------------"
		echo "Repository : $(basename "$dir")"
		echo "Path: $dir"


		# Navigate to the repo
		cd "$dir" || continue

		# Fetch updates
		git fetch > /dev/null 2>&1

		# Display the status
		echo "Branch : $(git branch --show-current)"
		echo "Status:"
		git status -s

		# Check for unpushed commits
		UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
		if [[ -n "$UPSTREAM" ]]; then
			COMMITS_AHEAD=$(git rev-list --count HEAD.."$UPSTREAM" 2>/dev/null)
			COMMITS_BEHIND=$(git rev-list --count "$UPSTREAM"..HEAD 2>/dev/null)
			echo "Commits ahead: $COMMITS_AHEAD | Commits behind: $COMMITS_BEHIND"
		else
			echo "No upstream branch set."
		fi

		echo ""
	fi
done

echo "-----------------------------------"
echo "Git Status Dashboard Complete!"
