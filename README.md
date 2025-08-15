# Bug Echo API

A simple API to trigger GitHub Actions workflows with bug details.

## Overview

This project provides two components:

1. **Bug Echo API** - A Flask-based API that forwards bug details to GitHub Actions
2. **Bug Echo Workflow** - A GitHub workflow that echoes bug information and creates issues

## Setup

### Prerequisites

- Python 3.x
- Flask
- GitHub Personal Access Token with `workflow` permission

### Installation

```bash
pip install flask requests
```

### Environment Variables

Set your GitHub token as an environment variable:

```bash
export GITHUB_TOKEN=your_github_token
```

### Running the API

```bash
python bug_echo_api.py
```

This will start the server on port 5000.

## Usage

### API Endpoints

#### Health Check

```
GET /health
```

Returns the health status of the API.

#### Get API Instructions

```
GET /instructions
```

Returns detailed instructions on how to use the API.

#### Echo Bug to GitHub Actions

```
POST /echo-bug
```

Payload:
```json
{
  "title": "Bug title",
  "description": "Bug description"
}
```

This triggers the `bug-echo.yml` workflow in GitHub Actions.

#### Get Curl Command

```
POST /echo-bug-curl
```

Payload:
```json
{
  "title": "Bug title",
  "description": "Bug description"
}
```

Returns a curl command that can be used to trigger the workflow directly.

### Examples

#### Using curl

```bash
curl -X POST http://localhost:5000/echo-bug \
  -H "Content-Type: application/json" \
  -d '{"title":"Button not working","description":"The login button does nothing when clicked"}'
```

## Workflow

The GitHub workflow (`bug-echo.yml`):

1. Echoes the bug title and description
2. Creates a bug_report.json file with details
3. Creates a GitHub issue with the bug information

## License

MIT