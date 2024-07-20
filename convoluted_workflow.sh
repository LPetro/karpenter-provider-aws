#!/bin/bash

# Check if the commit message is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <commit_message>"
    exit 1
fi

# Set the commit message
commit_msg="$1"

# Navigate to the karpenter directory
cd /Users/loupetro/Documents/KarpenterGitRepos/karpenter

# Add all changes
git add .

# Commit the changes
git commit -m "$commit_msg"

# Push the changes to the orbpoc branch
git push origin orbpoc

# Get the hash of the latest commit and copy it to the clipboard
commit_hash=$(git rev-parse HEAD)
echo "$commit_hash" | pbcopy

# Navigate to the karpenter-provider-aws directory
cd /Users/loupetro/Documents/KarpenterGitRepos/karpenter-provider-aws

# Replace the karpenter dependency with the latest commit
go mod edit -replace sigs.k8s.io/karpenter=github.com/LPetro/karpenter@"$commit_hash"

# Tidy the go modules
go mod tidy

# Apply the changes
make apply