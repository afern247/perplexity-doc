# iOS App Release Workflow

This repository demonstrates my GitHub Actions workflow for releasing an iOS app to the App Store.

## Workflow Overview

The `Release to App Store` workflow is triggered manually and performs the following steps:

1. Checks out the code
2. Sets up the environment and installs dependencies
3. Decodes and adds the necessary authentication key
4. Runs Fastlane to build and upload the app
5. Prints logs in case of failure
6. Cleans up the workspace

## Key Features

- Self-hosted runner for controlled build environment
- Secure handling of sensitive credentials using GitHub Secrets
- Integration with Fastlane for streamlined deployment
- Error logging and workspace cleanup
