#!/bin/bash

# Load environment variables
source ./github-runner-env.sh

# Change to the runner directory
cd ~/github-runner

# Start the runner in the background
./run.sh &

echo "GitHub Actions runner started!"
echo "You can now trigger workflows from the GitHub Actions tab."
echo "The runner will execute workflows labeled with 'runs-on: self-hosted'"