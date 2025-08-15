#!/usr/bin/env python3
"""
Simple API to echo bug title and description to GitHub Actions

This API provides an endpoint that triggers a GitHub workflow with bug details.
"""

from flask import Flask, request, jsonify
import requests
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'service': 'Bug Echo API',
        'description': 'Simple API to trigger GitHub Actions workflows with bug details'
    })

@app.route('/echo-bug', methods=['POST'])
def echo_bug():
    """
    Echo a bug to GitHub Actions
    
    Expected JSON:
    {
        "title": "Bug title",
        "description": "Bug description"
    }
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'success': False,
                'error': 'No JSON data provided'
            }), 400
        
        title = data.get('title', '').strip()
        description = data.get('description', '').strip()
        
        if not title or not description:
            return jsonify({
                'success': False,
                'error': 'Both title and description are required'
            }), 400
        
        # Get GitHub token from environment
        github_token = os.environ.get('GITHUB_TOKEN')
        if not github_token:
            return jsonify({
                'success': False,
                'error': 'GITHUB_TOKEN not found in environment'
            }), 500
        
        # Trigger GitHub workflow
        logger.info(f"Triggering GitHub workflow with bug: {title}")
        result = trigger_github_workflow(title, description, github_token)
        
        if result['success']:
            return jsonify({
                'success': True,
                'message': 'Successfully triggered GitHub workflow',
                'details': result
            })
        else:
            return jsonify({
                'success': False,
                'error': 'Failed to trigger GitHub workflow',
                'details': result
            }), 500
            
    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        return jsonify({
            'success': False,
            'error': f'Internal server error: {str(e)}'
        }), 500

def trigger_github_workflow(title, description, token):
    """
    Trigger GitHub Actions workflow using the GitHub API
    """
    try:
        owner = "Vasucd"
        repo = "NetflixClone"
        workflow_id = "claude.yml"  # The workflow file name
        
        # GitHub API URL for workflow dispatch
        url = f"https://api.github.com/repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches"
        
        headers = {
            "Accept": "application/vnd.github.v3+json",
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }
        
        # Workflow dispatch payload
        data = {
            "ref": "main",  # The branch to run the workflow on
            "inputs": {
                "bug_title": title,
                "bug_description": description
            }
        }
        
        response = requests.post(url, headers=headers, json=data)
        
        if response.status_code == 204:
            logger.info("Successfully triggered GitHub workflow")
            return {
                'success': True,
                'status_code': response.status_code,
                'workflow_url': f"https://github.com/{owner}/{repo}/actions/workflows/{workflow_id}"
            }
        else:
            logger.error(f"Failed to trigger GitHub workflow: {response.status_code} - {response.text}")
            return {
                'success': False,
                'status_code': response.status_code,
                'error': response.text,
                'note': 'Check your token has proper permissions (workflow and repo scope)'
            }
            
    except Exception as e:
        logger.error(f"Exception while triggering workflow: {str(e)}")
        return {
            'success': False,
            'error': str(e)
        }

@app.route('/echo-bug-curl', methods=['POST'])
def echo_bug_curl():
    """
    Alternative endpoint that provides a curl command to trigger workflow directly
    
    This is useful if your token doesn't have workflow permissions but you want
    to provide users with a curl command they can run themselves.
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'success': False,
                'error': 'No JSON data provided'
            }), 400
        
        title = data.get('title', '').strip()
        description = data.get('description', '').strip()
        
        if not title or not description:
            return jsonify({
                'success': False,
                'error': 'Both title and description are required'
            }), 400
        
        # Generate curl command
        owner = "Vasucd"
        repo = "NetflixClone"
        workflow_id = "claude.yml"
        
        curl_command = f"""
curl -X POST \\
  -H "Accept: application/vnd.github.v3+json" \\
  -H "Authorization: Bearer YOUR_GITHUB_TOKEN" \\
  -H "Content-Type: application/json" \\
  https://api.github.com/repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches \\
  -d '{{"ref":"main","inputs":{{"bug_title":"{title}","bug_description":"{description}"}}}}'
"""
        
        return jsonify({
            'success': True,
            'curl_command': curl_command,
            'note': 'Replace YOUR_GITHUB_TOKEN with a valid token with workflow permissions'
        })
            
    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        return jsonify({
            'success': False,
            'error': f'Internal server error: {str(e)}'
        }), 500

@app.route('/instructions', methods=['GET'])
def instructions():
    """Instructions for using the API"""
    return jsonify({
        'service': 'Bug Echo API',
        'description': 'Simple API to trigger GitHub Actions workflows with bug details',
        'usage': {
            'echo_bug': {
                'endpoint': '/echo-bug',
                'method': 'POST',
                'content_type': 'application/json',
                'body': {
                    'title': 'Bug title',
                    'description': 'Bug description'
                },
                'requirements': 'GITHUB_TOKEN environment variable with workflow permissions'
            },
            'echo_bug_curl': {
                'endpoint': '/echo-bug-curl',
                'method': 'POST',
                'content_type': 'application/json',
                'body': {
                    'title': 'Bug title',
                    'description': 'Bug description'
                },
                'output': 'Curl command that can be used to trigger the workflow directly'
            }
        },
        'example': 'curl -X POST http://localhost:5000/echo-bug -H "Content-Type: application/json" -d \'{"title":"Button not working","description":"The login button does nothing when clicked"}\'',
        'setup': 'Export GITHUB_TOKEN=your_token before starting the server'
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    logger.info(f"Starting Bug Echo API on port {port}")
    logger.info("Available endpoints:")
    logger.info(" - GET  /health       - Health check")
    logger.info(" - GET  /instructions - API instructions")
    logger.info(" - POST /echo-bug     - Echo bug to GitHub Actions")
    logger.info(" - POST /echo-bug-curl - Get curl command to trigger workflow")
    logger.info("")
    logger.info("IMPORTANT: Set GITHUB_TOKEN environment variable before starting")
    logger.info("Example: export GITHUB_TOKEN=your_github_token")
    
    app.run(host='0.0.0.0', port=port, debug=True)