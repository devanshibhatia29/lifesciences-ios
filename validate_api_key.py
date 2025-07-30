#!/usr/bin/env python3
import re
import sys
import base64
import json

def validate_api_key(api_key):
    """
    Validate the format of an API key
    """
    print("\n=== API KEY VALIDATION ===\n")
    
    if not api_key:
        print("❌ API key is empty or None")
        return False
        
    print(f"API Key length: {len(api_key)} characters")
    
    # Check for common prefixes
    if api_key.startswith("sk-"):
        print("✓ API key has the 'sk-' prefix common for API keys")
    else:
        print("⚠️ API key doesn't start with 'sk-' prefix (might be okay depending on your setup)")
    
    # Check for Bearer prefix that shouldn't be in the key itself
    if api_key.startswith("Bearer "):
        print("❌ API key contains 'Bearer ' prefix - this should be removed from the key itself")
        print("   The 'Bearer' prefix is added by the authentication system, not part of the key")
        return False
        
    # Check for common formatting issues
    if api_key.startswith('"') and api_key.endswith('"'):
        print("❌ API key is wrapped in double quotes - these should be removed")
        return False
        
    if api_key.startswith("'") and api_key.endswith("'"):
        print("❌ API key is wrapped in single quotes - these should be removed")
        return False
    
    # Check for whitespace
    if api_key.strip() != api_key:
        print("❌ API key has leading or trailing whitespace - this should be removed")
        return False
    
    # Check for internal whitespace
    if " " in api_key:
        print("❌ API key contains spaces - this is probably incorrect")
        return False
        
    # Check for newlines
    if "\n" in api_key or "\r" in api_key:
        print("❌ API key contains newlines - these should be removed")
        return False
    
    # Check character set (should be alphanumeric plus maybe some special chars)
    if not re.match(r'^[a-zA-Z0-9\-_\.]+$', api_key):
        print("⚠️ API key contains unusual characters - double check that it's correct")
    else:
        print("✓ API key contains expected characters")
    
    # Typically, Claude API keys are base64-encoded or have base64 segments
    try:
        # Try to decode as base64 to see if it's valid base64
        if api_key.startswith('sk-'):
            # Skip the 'sk-' prefix for base64 check
            base64_part = api_key[3:]
            padding_needed = len(base64_part) % 4
            if padding_needed:
                base64_part += '=' * (4 - padding_needed)
            base64.b64decode(base64_part)
            print("✓ API key appears to contain valid base64-encoded data")
        else:
            # Skip this check if not a standard key format
            print("⚠️ Skipping base64 validation for non-standard key format")
    except Exception:
        print("⚠️ API key doesn't appear to be valid base64 (might be okay depending on your setup)")
    
    print("\n=== SUMMARY ===")
    print("Your API key format looks valid for use with the GitHub Action.")
    print("Make sure it is correctly stored as a secret named ANTHROPIC_AUTH_TOKEN in your repository.")
    print("If you're still having issues, try setting it directly as ANTHROPIC_API_KEY instead.")
    return True

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python validate_api_key.py YOUR_API_KEY")
        sys.exit(1)
        
    api_key = sys.argv[1]
    validate_api_key(api_key)