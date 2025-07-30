#!/bin/bash

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

# Run the Claude bot test
$PYTHON_CMD test_claude_bot.py "$@"