#!/bin/bash

# Set environment variables for Salesforce Claude proxy
export ANTHROPIC_API_KEY="sk-u16oSLDpP54rkAxvlqyEXg"

# Check if python3 is available
if command -v python3 &>/dev/null; then
    PYTHON_CMD="python3"
    PIP_CMD="pip3"
elif command -v python &>/dev/null; then
    PYTHON_CMD="python"
    PIP_CMD="pip"
else
    echo "Error: Python is not installed or not in your PATH"
    echo "Please install Python 3 and try again"
    exit 1
fi

echo "Using Python command: $PYTHON_CMD"
echo "Using pip command: $PIP_CMD"

# Install required Python packages
$PIP_CMD install --user requests || echo "Warning: Could not install requests package. Continuing anyway..."

# Create the test script with the correct endpoint and format
cat > test_salesforce_claude.py << 'EOL'
import json
import requests
import os
import sys

def test_claude_salesforce_proxy():
    # Get API key from environment
    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        print("Error: ANTHROPIC_API_KEY environment variable not set")
        sys.exit(1)
        
    # Salesforce internal Claude gateway endpoint
    url = "https://eng-ai-model-gateway.sfproxy.devx-preprod.aws-esvc1-useast2.aws.sfdc.cl/chat/completions"

    print(f"Testing Salesforce Claude proxy API at {url}")
    print(f"Using API key: {api_key[:5]}...")

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }

    data = {
        "model": "claude-sonnet-4-20250514",
        "messages": [
            {
                "role": "system",
                "content": "You are a precise and helpful coding assistant for developers. Respond with clean, correct, and minimal code or concise technical guidance."
            },
            {
                "role": "user",
                "content": "Python function to reverse a string."
            }
        ],
        "max_tokens": 300,
        "temperature": 0.2
    }

    try:
        print("\nSending request to Salesforce Claude proxy...")
        response = requests.post(url, headers=headers, json=data, timeout=30)

        print(f"Status code: {response.status_code}")
        
        if response.ok:
            print("\n✓ SUCCESS!")
            result = response.json()
            print("\nClaude Response:")
            print(result.get("choices", [{}])[0].get("message", {}).get("content", "⚠️ No content in response"))
            return True
        else:
            print(f"\n✗ Error {response.status_code}: {response.text}")
            return False
    except Exception as e:
        print(f"\n✗ Exception occurred: {str(e)}")
        return False

if __name__ == "__main__":
    success = test_claude_salesforce_proxy()
    if not success:
        sys.exit(1)
EOL

# Run the test script
$PYTHON_CMD test_salesforce_claude.py