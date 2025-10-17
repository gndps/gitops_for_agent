#!/bin/bash

# Script: lock_changes.sh
# Purpose: Lock changes in a git repository by staging, committing, and pushing to remote.
# Usage: ./lock_changes.sh <repo_folder> [commit_message]
# Assumes branch is 'main'; adjust if needed.
# Handles initial setup: skips commit if no commits and no remote.

set -e  # Exit on error

if [ $# -lt 1 ]; then
    echo "Usage: $0 <repo_folder> [commit_message]"
    echo "  <repo_folder>: Path to the git repository directory."
    echo "  [commit_message]: Optional custom commit message."
    exit 1
fi

REPO_DIR="$1"
COMMIT_MSG="$2"

# Change to repo directory
cd "$REPO_DIR" || {
    echo "Error: Cannot change to directory '$REPO_DIR'."
    exit 1
}

# Verify it's a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: '$REPO_DIR' is not a valid git repository."
    exit 1
fi

# Check if has remote
HAS_REMOTE=$(git remote | wc -l)
HAS_REMOTE=$((HAS_REMOTE > 0))

# Check if has commits (initial commit done?)
HAS_COMMITS=$(git rev-parse --verify HEAD > /dev/null 2>&1 && echo 1 || echo 0)
# Alternative: HAS_COMMITS=$(git log --oneline 2>/dev/null | wc -l); HAS_COMMITS=$((HAS_COMMITS > 0))

# Initial setup: no commits and no remote -> skip and inform
if [ "$HAS_COMMITS" -eq 0 ] && [ "$HAS_REMOTE" -eq 0 ]; then
    echo "Initial setup detected: Repository has no commits and no remote configured."
    echo "Skipping commit and push. Lock changes will be performed before the next change."
    echo "Consider setting up remote with: git remote add origin <your-repo-url>"
    exit 0
fi

# Check for changes to commit
if git diff --quiet && git diff --staged --quiet; then
    echo "No changes detected in '$REPO_DIR'. Nothing to lock."
    exit 0
fi

# Generate default message if not provided
if [ -z "$COMMIT_MSG" ]; then
    RANDOM_STRING=$(openssl rand -hex 8 2>/dev/null || echo $RANDOM | cut -c1-16)  # Fallback if openssl unavailable
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    COMMIT_MSG="Lock changes - ${RANDOM_STRING} - ${TIMESTAMP}"
fi

# Stage all changes
git add .

# Commit
git commit -m "$COMMIT_MSG"

# Push if remote exists
if [ "$HAS_REMOTE" -eq 1 ]; then
    git push origin main
    echo "Changes locked, committed, and pushed to remote with message: '$COMMIT_MSG'"
else
    echo "Warning: No remote configured. Changes committed locally but not pushed."
    echo "Changes locked locally with message: '$COMMIT_MSG'"
fi
