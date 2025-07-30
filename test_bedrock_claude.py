import json
import requests
import os
import sys

def test_claude_salesforce_proxy():
    # Get API key from environment
    api_key = os.environ.get("ANTHROPIC_API_KEY", "sk-u16oSLDpP54rkAxvlqyEXg")
    
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