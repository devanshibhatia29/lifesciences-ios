# Claude Bot Troubleshooting

## Issue Fixed

The Claude bot was encountering an error because it was trying to use an incorrect model identifier:

```
API Error (claude-3-sonnet-20240620): 400 {"error":{"message":"{\"message\":\"The provided model identifier is invalid.\"}","type":"None","param":"None","code":"400"}}
```

## Solution

The model identifier has been updated in `.github/workflows/claude.yml` from `claude-3-sonnet-20240620` to `claude-sonnet-4-20250514` to match the model supported by your Salesforce proxy endpoint.

## Testing

To test that the Claude bot is now working:

1. Create or find an issue in your repository
2. Add a comment mentioning `@claude` with a request like "Can you add a simple splash screen to the app?"
3. The GitHub Actions workflow should trigger and Claude should now be able to process your request

## Additional Information

The GitHub runner is configured properly, and the workflow is set to use your self-hosted runner. The key issue was just the model identifier mismatch.

If you encounter any other issues, check:

1. That your self-hosted runner is running and connected
2. That the API key is correctly set in GitHub repository secrets
3. That the environment variables are properly set in the runner environment