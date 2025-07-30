# GitHub Actions Local Troubleshooting Guide

## Setup Summary

1. We installed `act` using Homebrew:
   ```bash
   brew install act
   ```

2. Created a `.secrets` file with your Anthropic API key:
   ```
   ANTHROPIC_API_KEY=your_api_key_here
   ANTHROPIC_AUTH_TOKEN=your_api_key_here
   API_KEY=your_api_key_here
   ```

3. Added `.secrets` to `.gitignore` to prevent accidentally committing your API key

## Commands to Run Workflows

Run the test-claude-api.yml workflow:
```bash
act -W .github/workflows/test-claude-api.yml -s ANTHROPIC_AUTH_TOKEN=$ANTHROPIC_API_KEY --secret-file .secrets --container-architecture linux/amd64
```

Run the claude-basic.yml workflow:
```bash
act -W .github/workflows/claude-basic.yml -s API_KEY=$ANTHROPIC_API_KEY --secret-file .secrets --container-architecture linux/amd64
```

## Common Issues and Solutions

### Docker Not Running

**Issue**: Error message about Docker not being available
**Solution**: Make sure Docker Desktop is running on your Mac

### Apple M-series Chip Issues

**Issue**: Architecture incompatibility
**Solution**: Always use `--container-architecture linux/amd64` flag with the `act` command

### Secret Not Found

**Issue**: Workflow fails with "secret not found" or similar error
**Solution**: 
- Make sure your `.secrets` file contains the correct variable names as used in the workflow
- Ensure you're using the `-s` flag to map secrets correctly (as shown in the commands above)

### Permission Issues

**Issue**: Permission denied errors when running Docker commands
**Solution**: Make sure your user has Docker permissions or run with `sudo`

### Python Issues

**Issue**: Python-related errors in the workflow
**Solution**: The workflows use Python 3.10, so make sure your Docker image supports this version

### Network Issues with Anthropic API

**Issue**: Cannot connect to Anthropic API
**Solution**: Check your network connection, VPN settings, or corporate proxy settings

## Advanced Configuration

You can create an `.actrc` file in your project directory with common flags:

```
--secret-file=.secrets
--container-architecture=linux/amd64
```

Then you can run `act` without these flags, making the commands simpler.