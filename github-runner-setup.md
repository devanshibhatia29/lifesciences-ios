# GitHub Actions Self-Hosted Runner Setup

This guide explains how to set up and run GitHub Actions workflows on your local Mac.

## Setup Steps

1. **Create a runner directory and download the runner package**

```bash
# Create a directory for the runner
mkdir -p ~/github-runner

# Change to the runner directory
cd ~/github-runner

# Download the runner package
curl -o actions-runner-osx-arm64-2.314.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.314.1/actions-runner-osx-arm64-2.314.1.tar.gz

# Extract the installer
tar xzf ./actions-runner-osx-arm64-2.314.1.tar.gz
```

2. **Configure the runner with your GitHub repository token**

```bash
# Navigate to your GitHub repository
# Click on Settings > Actions > Runners
# Click "New self-hosted runner"
# Choose macOS as the operating system
# Copy the token provided

# Configure the runner with your token
cd ~/github-runner
./config.sh --url https://github.com/YOUR-USERNAME/NetflixClone --token YOUR_TOKEN
```

3. **Load environment variables and start the runner**

```bash
# Source the environment variables
source /path/to/NetflixClone/github-runner-env.sh

# Start the runner
cd ~/github-runner
./run.sh
```

Or use the provided script:

```bash
/path/to/NetflixClone/start-github-runner.sh
```

## Environment Variables

The environment variables for the Claude API are stored in `github-runner-env.sh`. These are automatically loaded when using the `start-github-runner.sh` script.

## Workflow Files

All workflow files have been updated to use the self-hosted runner:

1. `bedrock-claude-test.yml` - Test the Salesforce Claude Proxy
2. `claude.yml` - The @claude bot that responds to GitHub issues and comments
3. `test-claude-api.yml` - Simple API connection test

## Testing

1. After setting up and starting the runner, go to your GitHub repository
2. Click on the "Actions" tab
3. Select any of the workflows from the left sidebar
4. Click "Run workflow" button to execute it on your self-hosted runner

## Troubleshooting

1. **Runner not appearing in GitHub**
   - Verify that you used the correct token during configuration
   - Check network connectivity

2. **Workflow not running on self-hosted runner**
   - Verify that the workflow yaml files have `runs-on: self-hosted`
   - Ensure the runner is active and listening

3. **API key issues**
   - Check that the environment variables are properly set in `github-runner-env.sh`
   - Verify that the API key is correctly set in GitHub repository secrets

4. **Python errors**
   - Ensure Python 3 is installed on your system
   - Install required packages with `pip3 install requests`