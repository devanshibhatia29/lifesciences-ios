import os
import requests
import json
import sys

def test_claude_api_direct():
    """Test Claude API directly with requests library"""
    api_key = os.environ.get("ANTHROPIC_AUTH_TOKEN")
    
    if not api_key:
        print("Error: ANTHROPIC_AUTH_TOKEN environment variable not set")
        print("Please set it with: export ANTHROPIC_AUTH_TOKEN='your-key-here'")
        return False
    
    api_url = "https://eng-ai-model-gateway.sfproxy.devx-preprod.aws-esvc1-useast2.aws.sfdc.cl/chat/completions"
    
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    
    data = {
        "model": "claude-sonnet-4-20250514",
        "messages": [
            {
                "role": "system",
                "content": "You are a precise and helpful coding assistant for developers—respond with clean, correct, and minimal code or concise technical guidance."
            },
            {
                "role": "user",
                "content": "Python function to reverse a string."
            }
        ],
        "max_tokens": 300,
        "temperature": 0.2
    }
    
    print(f"Making request to {api_url}")
    print(f"Headers: {json.dumps(headers, indent=2)}")
    print(f"Request body: {json.dumps(data, indent=2)}")
    
    try:
        response = requests.post(api_url, headers=headers, json=data)
        
        print(f"\nResponse status code: {response.status_code}")
        
        if response.status_code == 200:
            print("\n✓ API connection successful!")
            result = response.json()
            print("\nClaude Response:")
            print(result.get('choices', [{}])[0].get('message', {}).get('content', 'No content in response'))
            return True
        else:
            print("\n✗ API connection failed")
            print(f"Error: {response.text}")
            return False
            
    except Exception as e:
        print(f"\n✗ API connection failed with exception:")
        print(f"Error: {str(e)}")
        return False

def test_claude_api_sdk():
    """Test Claude API using the Anthropic Python SDK"""
    try:
        from anthropic import Anthropic
        
        api_key = os.environ.get("ANTHROPIC_AUTH_TOKEN")
        if not api_key:
            print("Error: ANTHROPIC_AUTH_TOKEN environment variable not set")
            print("Please set it with: export ANTHROPIC_AUTH_TOKEN='your-key-here'")
            return False
        
        print("Initializing Anthropic client...")
        client = Anthropic(api_key=api_key)
        
        print("Sending request to Claude API...")
        response = client.messages.create(
            model="claude-3-sonnet-20240620",
            max_tokens=300,
            temperature=0.2,
            system="You are a precise and helpful coding assistant for developers—respond with clean, correct, and minimal code or concise technical guidance.",
            messages=[
                {"role": "user", "content": "Python function to reverse a string."}
            ]
        )
        
        print("\n✓ API connection successful!")
        print("\nClaude Response:")
        print(response.content[0].text)
        return True
        
    except ImportError:
        print("Anthropic Python SDK not installed.")
        print("Install it with: pip install anthropic")
        return False
    except Exception as e:
        print(f"\n✗ API connection failed with exception:")
        print(f"Error: {str(e)}")
        return False

if __name__ == "__main__":
    print("========== CLAUDE API TEST ==========")
    print("Testing direct API connection first...\n")
    
    success = test_claude_api_direct()
    
    if not success:
        print("\n\nTrying with Anthropic SDK as fallback...\n")
        success = test_claude_api_sdk()
    
    if not success:
        print("\n❌ All API connection attempts failed")
        sys.exit(1)
    else:
        print("\n✅ API connection test succeeded")