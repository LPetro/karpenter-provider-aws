#!/bin/bash

# Check if the commit message is provided from clipboard
if [ -z "$1" ]; then
    echo "Usage: $0 <commit_message>"
    exit 1
fi

# Set the commit message
commit_msg="$1"

# Navigate to the karpenter directory
cd /Users/loupetro/Documents/KarpenterGitRepos/karpenter
git add .
git commit -m "$commit_msg"
git push origin orb
commit_hash=$(git rev-parse HEAD)
echo "$commit_hash" | pbcopy
cd /Users/loupetro/Documents/KarpenterGitRepos/karpenter-provider-aws

# Replace the karpenter dependency with the latest commit
go mod edit -replace sigs.k8s.io/karpenter=github.com/LPetro/karpenter@"$commit_hash"
go mod tidy

# Apply the changes
make apply