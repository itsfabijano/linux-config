#!/bin/bash

# Update and pull for each submodule
git submodule foreach "
  git checkout main  # or your desired branch
  git pull origin \$(git rev-parse --abbrev-ref HEAD)
"

# Pull the latest changes for the main repository
git pull origin main


