# Claude Bot Usage Guide

This guide explains how to use the Claude bot to create pull requests for your NetflixClone repository.

## ✨ New: Official Claude Code Action

**We've upgraded to the official Anthropic claude-code-action!** This provides:

- **Built-in conciseness** - Automatically provides proportional responses
- **Better reliability** - Professionally maintained by Anthropic  
- **Simpler configuration** - No more custom Python scripts to maintain
- **Enhanced code understanding** - Better repository analysis capabilities

## Proportional Response Sizing

Claude now provides responses proportional to the complexity of your request:

- **Simple fixes** (typos, one-liners): Brief responses with minimal explanation
- **Small features**: Concise explanations with targeted code changes  
- **Complex features**: Detailed analysis and comprehensive implementation
- **Bug fixes**: Short problem description + solution

This means you'll get appropriately-sized responses instead of overly verbose explanations for simple tasks.

## Step-by-Step Guide

### 1. Creating an Issue for Claude

1. Go to your GitHub repository: https://github.com/Vasucd/NetflixClone
2. Click on the "Issues" tab
3. Click the "New issue" button
4. Provide a descriptive title for your task/feature
5. In the issue description, include `@claude` followed by your request
   
   Example:
   ```
   @claude Can you implement a splash screen for the app?
   ```
   
6. Click "Submit new issue"

### 2. Adding Claude to an Existing Issue

1. Navigate to the existing issue
2. Add a new comment with `@claude` followed by your request
   
   Example:
   ```
   @claude Please implement a splash screen with the Netflix logo
   ```
   
3. Click "Comment"

### 3. What Happens Next

1. Claude bot will respond with a comment indicating that it's working
2. It will analyze your repository and the request
3. Claude creates a new branch for its changes
4. It implements the requested feature
5. It commits the changes and pushes them to the branch
6. Finally, Claude creates a pull request (PR) and provides a link in its comment

### 4. Reviewing and Merging the PR

1. Click on the PR link provided by Claude
2. Review the changes to ensure they meet your requirements
3. Request changes or provide feedback by commenting on the PR
4. When satisfied, click "Merge pull request"

## Best Practices for Working with Claude

### Effective Requests

1. **Be specific**: Clearly describe what you want Claude to implement
   ```
   @claude Create a splash screen that displays the Netflix logo for 3 seconds at app launch
   ```

2. **Provide context**: Include relevant details that help Claude understand your needs
   ```
   @claude The app currently doesn't have a splash screen. Please create one that matches Netflix's branding.
   ```

3. **Reference existing code**: Point to specific files or functionality
   ```
   @claude Please add a splash screen similar to how we implemented the login screen in LoginViewController.swift
   ```

### Common Tasks for Claude

- **Feature Implementation**: 
  ```
  @claude Implement a video player for movie previews
  ```

- **Bug Fixes**: 
  ```
  @claude Fix the layout issue in TableViewController where cells overlap
  ```

- **Code Refactoring**: 
  ```
  @claude Refactor the network layer to use async/await
  ```

- **Documentation**: 
  ```
  @claude Add documentation to the HomeViewController class
  ```

## Troubleshooting

If Claude encounters issues:

1. Check the GitHub Actions logs for errors
2. Verify that your self-hosted runner is active
3. Make sure the environment variables are configured correctly
4. Try rephrasing your request to be more specific

## Environment Configuration

The Claude bot is configured to run on your self-hosted runner with the following environment setup:

- **API Endpoint**: Salesforce Claude proxy
- **Model**: claude-sonnet-4-20250514
- **Authentication**: Bearer token authentication
- **Runner**: Self-hosted on your local machine