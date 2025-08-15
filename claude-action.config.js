/**
 * Configuration for the official Claude Code GitHub Action
 * This file helps configure the claude-code-action for use with Salesforce proxy
 */

module.exports = {
  // The API endpoint to use (for Salesforce proxy)
  apiBase: 'https://eng-ai-model-gateway.sfproxy.devx-preprod.aws-esvc1-useast2.aws.sfdc.cl/chat/completions',
  
  // Model configuration
  model: 'claude-sonnet-4-20250514',
  
  // Environment flags for official action
  useDirectCompletionEndpoint: true,
  skipBedrockAuth: true,
  
  // Runner options
  runner: 'self-hosted',
  
  // Additional settings for official action
  maxTokens: 4000,
  temperature: 0.1
};