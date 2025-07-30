# Salesforce Claude API Tests - Local Setup Guide

This document explains how to run the Claude API tests locally, either directly or via GitHub Actions.

## Quick Start

To quickly test the Claude API connection, run:

```bash
./run_bedrock_test.sh
```

This will:
1. Set up the required environment variables
2. Install necessary Python packages
3. Create and run a test script that connects to the Salesforce Claude proxy endpoint

## API Connection Details

The tests connect to Salesforce's internal Claude API endpoint:

- **Endpoint URL**: `https://eng-ai-model-gateway.sfproxy.devx-preprod.aws-esvc1-useast2.aws.sfdc.cl/chat/completions`
- **API Key**: Bearer token authentication (`sk-u16oSLDpP54rkAxvlqyEXg`)
- **Model**: `claude-sonnet-4-20250514`

## Available Test Scripts

1. **Direct Python Script**:
   ```bash
   python3 test_bedrock_claude.py
   ```
   
   This script directly calls the Claude API using the correct format for the Salesforce proxy.

2. **GitHub Actions Local Runner**:
   ```bash
   act -W .github/workflows/bedrock-claude-test.yml --secret-file .secrets --container-architecture linux/amd64
   ```
   
   This runs the GitHub Actions workflow locally using the `act` tool. You need Docker running for this to work.

## Configuration

The tests use the following environment variables:

- `ANTHROPIC_API_KEY`: The API key for authenticating with the Claude proxy
- `ANTHROPIC_AUTH_TOKEN`: Same as the API key (for compatibility)
- `API_KEY`: Same as the API key (for compatibility)

These are set in:
- The `.secrets` file (for `act`)
- Directly in the shell scripts (`run_bedrock_test.sh`)
- GitHub Actions workflow secrets (for CI/CD)

## Troubleshooting

1. **Python Not Found**:
   - The scripts automatically try `python3` or `python`
   - If neither works, install Python 3 using: `brew install python3`

2. **Missing Python Packages**:
   - The scripts try to install required packages
   - If it fails, manually install with: `pip3 install --user requests`

3. **Connection Issues**:
   - Verify you're on the correct network (VPN might be required)
   - Check if the API key is valid
   - Check if the endpoint URL is accessible

4. **Docker Issues with act**:
   - Ensure Docker Desktop is running
   - Use the `--container-architecture linux/amd64` flag with M-series Macs

## API Response Format

Successful responses should look like:

```json
{
  "choices": [
    {
      "message": {
        "content": "def reverse_string(s):\n    return s[::-1]\n\n# Example usage\nprint(reverse_string(\"hello\"))  # Outputs: olleh"
      }
    }
  ]
}
```