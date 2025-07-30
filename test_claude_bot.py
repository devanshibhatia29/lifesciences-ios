import os
import json
import requests
import sys

def test_claude_bot():
    # Use the API key directly in the script (same as in other test scripts)
    api_key = "sk-u16oSLDpP54rkAxvlqyEXg"
    
    # Salesforce Claude proxy endpoint
    url = "https://eng-ai-model-gateway.sfproxy.devx-preprod.aws-esvc1-useast2.aws.sfdc.cl/chat/completions"
    
    # Get the question from command line arguments or use default
    if len(sys.argv) > 1:
        question = " ".join(sys.argv[1:])
    else:
        question = "Can you help me reverse a string in Swift?"
    
    print(f"Testing Claude bot with question: \"{question}\"")
    
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    
    data = {
        "model": "claude-sonnet-4-20250514",
        "messages": [
            {
                "role": "system",
                "content": "You are Claude, an AI assistant integrated with GitHub through claude-code-action. You are helping users with code-related questions on GitHub issues and comments. Keep your responses clear, helpful, and concise."
            },
            {
                "role": "user",
                "content": question
            }
        ],
        "max_tokens": 1000,
        "temperature": 0.7
    }
    
    try:
        print("\nSending request to Claude API...")
        response = requests.post(url, headers=headers, json=data, timeout=30)
        
        if response.ok:
            result = response.json()
            print("\nClaude response:")
            print("-" * 80)
            response_content = result.get("choices", [{}])[0].get("message", {}).get("content", "No response generated")
            print(response_content)
            print("-" * 80)
            return True
        else:
            print(f"\nError {response.status_code}: {response.text}")
            return False
    except Exception as e:
        print(f"\nException occurred: {str(e)}")
        return False

if __name__ == "__main__":
    success = test_claude_bot()
    if not success:
        sys.exit(1)