#!/usr/bin/env bash

# cleanup-demo.sh
# Safely tears down and deletes a replicated SDD Barista demo local folder and its linked GitHub repository.

set -euo pipefail

# Print instructions / usage
usage() {
    echo "Usage: $0 <local_directory_to_delete>"
    echo "Example: $0 /home/user/my-new-barista-demo"
    exit 1
}

# 1. Check arguments
if [ "$#" -ne 1 ]; then
    usage
fi

NEW_DIR="$1"
REPO_NAME="$(basename "$NEW_DIR")"

echo "=== SDD Barista Demo Cleanup ==="
echo "Local Directory:   $NEW_DIR"
echo "GitHub Repo Name:  $REPO_NAME"
echo "================================"

# 2. Check for dependencies
if ! command -v gh &> /dev/null; then
    echo "❌ Error: 'gh' CLI tool is not installed."
    exit 1
fi

# 3. Verify gh authentication
if ! gh auth status &> /dev/null; then
    echo "❌ Error: GitHub CLI is not authenticated."
    exit 1
fi

# 4. Fetch the authenticated user's login
USER_NAME="$(gh api user -q .login)"
REPO_FULL_NAME="$USER_NAME/$REPO_NAME"

echo "Target Remote Repo: $REPO_FULL_NAME"
echo ""

# 5. Safety confirmation
echo "⚠️  WARNING: This will permanently delete:"
echo "   1. The local directory: $NEW_DIR"
echo "   2. The GitHub repository: https://github.com/$REPO_FULL_NAME"
echo ""
read -rp "Are you absolutely sure you want to delete these? [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# 6. Delete GitHub Remote Repository
echo "🌐 Deleting remote GitHub repository '$REPO_FULL_NAME'..."
if gh repo delete "$REPO_FULL_NAME" --yes; then
    echo "✔ Remote repository deleted successfully."
else
    echo "⚠️  Could not delete remote repository (it may already be deleted or permission denied)."
fi

# 7. Delete Local Folder
if [ -d "$NEW_DIR" ]; then
    echo "🧹 Deleting local directory '$NEW_DIR'..."
    rm -rf "$NEW_DIR"
    echo "✔ Local directory deleted successfully."
else
    echo "ℹ Local directory '$NEW_DIR' does not exist; skipping local deletion."
fi

echo ""
echo "✨ Cleanup complete!"
