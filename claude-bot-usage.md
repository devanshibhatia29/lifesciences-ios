# Claude Bot Local Testing Guide

This document explains how to test the `@claude` GitHub bot locally, without needing to create actual GitHub issues.

## Quick Start

Run the standalone Claude bot test script:

```bash
./run_claude_bot.sh "Can you help me with Swift UI navigation?"
```

This will:
1. Install any required dependencies
2. Send your question to the Claude API
3. Display Claude's response as it would appear in a GitHub comment

## How the @claude Bot Works

The `@claude` bot is triggered by:
1. Creating an issue that mentions `@claude` in the body
2. Adding a comment with `@claude` to an issue or pull request
3. Adding a review comment with `@claude` on a pull request

The bot uses the GitHub Action defined in `.github/workflows/claude.yml` and relies on the [claude-code-action](https://github.com/anthropics/claude-code-action) to process the requests and generate responses.

## Testing Options

### 1. Simple Script (Recommended)

For quick tests, use the standalone script:

```bash
./run_claude_bot.sh "Your question here"
```

You can ask any coding or repository-related question.

### 2. GitHub Actions Local Test (Requires Docker)

If you want to test the actual GitHub Actions workflow:

```bash
# Start Docker Desktop first
act -W .github/workflows/claude-local-test.yml --secret-file .secrets --container-architecture linux/amd64
```

This simulates the GitHub Actions environment locally.

## Common Questions for Testing

Try these example questions to test the bot:

```
./run_claude_bot.sh "Can you explain how UINavigationController works in Swift?"
```

```
./run_claude_bot.sh "Write a Swift function to parse JSON into a User struct"
```

```
./run_claude_bot.sh "What's the best way to handle error states in a Netflix-style UI?"
```

## Troubleshooting

If you encounter issues:

1. **API Key Problems**: Verify the API key in the scripts
2. **Python Issues**: Make sure you have Python 3 and requests installed
3. **Network Issues**: Check your connection to the Salesforce proxy endpoint