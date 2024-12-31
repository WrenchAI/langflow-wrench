#!/bin/bash

# Configuration
UPSTREAM_REPO="upstream"
UPSTREAM_BRANCH="main"
UPSTREAM_DEV_BRANCH="upstream-dev"
LOCAL_MAIN="main"

# Fetch the latest changes from upstream
echo "Fetching latest changes from upstream..."
git fetch $UPSTREAM_REPO $UPSTREAM_BRANCH

# Check if upstream-dev exists, if not, create it
if ! git show-ref --quiet refs/heads/$UPSTREAM_DEV_BRANCH; then
    echo "Creating $UPSTREAM_DEV_BRANCH from upstream/main..."
    git checkout -b $UPSTREAM_DEV_BRANCH $UPSTREAM_REPO/$UPSTREAM_BRANCH
    git push origin $UPSTREAM_DEV_BRANCH
else
    echo "Updating $UPSTREAM_DEV_BRANCH with upstream changes..."
    git checkout $UPSTREAM_DEV_BRANCH
    git rebase $UPSTREAM_REPO/$UPSTREAM_BRANCH
    git push origin $UPSTREAM_DEV_BRANCH --force
fi

# Rebase local main from upstream-dev
echo "Rebasing $LOCAL_MAIN from $UPSTREAM_DEV_BRANCH..."
git checkout $LOCAL_MAIN
git rebase $UPSTREAM_DEV_BRANCH
git push origin $LOCAL_MAIN --force

# Delete the remote-tracking upstream/main branch
echo "Deleting remote-tracking upstream/main branch from your fork..."
git push origin --delete upstream/main || echo "No upstream/main to delete"

echo "Sync complete!"
