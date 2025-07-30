#!/bin/bash
# Environment variables for the GitHub Actions self-hosted runner

# Claude API Keys
export ANTHROPIC_AUTH_TOKEN="sk-u16oSLDpP54rkAxvlqyEXg"
export ANTHROPIC_API_KEY="sk-u16oSLDpP54rkAxvlqyEXg"

# Additional configuration
export CLAUDE_CODE_SKIP_BEDROCK_AUTH="1"
export CLAUDE_CODE_USE_BEDROCK="1"

# Output confirmation
echo "Environment variables for GitHub runner configured:"
echo "ANTHROPIC_AUTH_TOKEN: ${ANTHROPIC_AUTH_TOKEN:0:5}..."
echo "ANTHROPIC_API_KEY: ${ANTHROPIC_API_KEY:0:5}..."