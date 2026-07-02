#!/usr/bin/env bash

# duplicate-demo.sh
# Automates replicating the SDD Barista Agent template environment to a new local directory and fresh GitHub repository.

set -euo pipefail

# Print instructions / usage
usage() {
    echo "Usage: $0 <new_local_directory> <new_github_repo_name>"
    echo "Example: $0 /home/user/my-new-barista-demo my-new-barista-demo"
    exit 1
}

# 1. Check arguments
if [ "$#" -ne 2 ]; then
    usage
fi

NEW_DIR="$1"
REPO_NAME="$2"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== SDD Barista Demo Replicator ==="
echo "Source:      $SRC_DIR"
echo "Target Dir:  $NEW_DIR"
echo "GitHub Repo: $REPO_NAME"
echo "==================================="

# 2. Check for dependencies
if ! command -v gh &> /dev/null; then
    echo "❌ Error: 'gh' CLI tool is not installed."
    echo "Please install the GitHub CLI and authenticate before running this script."
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "❌ Error: 'git' is not installed."
    exit 1
fi

# 3. Verify gh authentication
if ! gh auth status &> /dev/null; then
    echo "❌ Error: GitHub CLI is not authenticated."
    echo "Please run 'gh auth login' to authenticate with GitHub."
    exit 1
fi

# 4. Check if target directory already exists
if [ -d "$NEW_DIR" ]; then
    echo "❌ Error: Target directory '$NEW_DIR' already exists."
    read -rp "Do you want to overwrite it? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
    echo "🧹 Cleaning existing target directory..."
    rm -rf "$NEW_DIR"
fi

# 5. Create new folder structure
echo "📁 Creating target directory..."
mkdir -p "$NEW_DIR"

# 6. Copy core template files (cleanly, excluding replication helper tools)
echo "📦 Copying clean template files..."
cp -r "$SRC_DIR"/.agents "$NEW_DIR/"
cp -r "$SRC_DIR"/docs "$NEW_DIR/"
cp "$SRC_DIR"/AGENTS.md "$NEW_DIR/"
cp "$SRC_DIR"/.gitignore "$NEW_DIR/"
cp "$SRC_DIR"/pyproject.toml "$NEW_DIR/"

# Exclude replication-specific assets from the new environment
rm -f "$NEW_DIR/docs/REPLICATION.md"

# 7. Initialize Git and commit
echo "🚀 Initializing local Git repository..."
cd "$NEW_DIR"
git init
git checkout -b main
git add .
git commit -m "chore: initialize sdd-barista-reference template structure"

# 8. Create and push to the new GitHub repository
echo "🌐 Creating brand-new GitHub repository and pushing..."
# This command automatically creates the remote repo, sets origin, and pushes
gh repo create "$REPO_NAME" --public --source=. --remote=origin --push

echo ""
echo "✨ Success! Your clean demo environment has been created successfully."
echo "📍 Local workspace: $NEW_DIR"
echo "📍 GitHub repository: $REPO_NAME"
echo ""
echo "To begin the demo, open the workspace in your editor and ask the agent to run:"
echo "   /prd-to-backlog"
echo "to upload the user stories from the PRD and populate your GitHub backlog!"
