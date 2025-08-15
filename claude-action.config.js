/**
 * Configuration for the Claude Code GitHub Action
 * This file helps configure the claude-code-action for use with Salesforce proxy
 */

module.exports = {
  // The API endpoint to use
  apiBase: 'https://eng-ai-model-gateway.sfproxy.devx-preprod.aws-esvc1-useast2.aws.sfdc.cl/chat/completions',
  
  // Model configuration
  model: 'claude-3-sonnet-20240620',
  
  // Environment flags
  useDirectCompletionEndpoint: true,
  skipBedrockAuth: true,
  
  // Runner options
  runner: 'self-hosted'
};