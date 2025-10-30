#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# -----------------------
# Configurable Variables
# -----------------------
PARAM_ENV="$env"
EXPECTED_ENV="uat"
PROJECT="project-dir"
DEPLOY_PATH="/home/nginx/html/$PROJECT"
BUILD_OUTPUT="dist/uat_build"
BACKUP_DIR="/home/nginx/html/backup"

# -----------------------
# Validate environment
# -----------------------
if [ "$PARAM_ENV" != "$EXPECTED_ENV" ]; then
  echo "❌ Triggered for '$PARAM_ENV', but this job is configured for '$EXPECTED_ENV'. Aborting."
  exit 1
fi

echo "✅ Environment check passed. Proceeding with the build for '$EXPECTED_ENV'..."

# -----------------------
# Navigate to workspace
# -----------------------
cd "$WORKSPACE"
echo "📂 Workspace Directory: $WORKSPACE"

# -----------------------
# Clean previous install artifacts
# ----------------------a-
echo "🧹 Removing node_modules and package-lock.json..."
rm -rf node_modules package-lock.json

# -----------------------
# Install dependencies
# -----------------------
echo "📦 Installing npm packages..."
npm install

# -----------------------
# Build the React application
# -----------------------
echo "🔨 Building the React application for '$EXPECTED_ENV'..."
npm run build:uat

# -----------------------
# Validate build output
# -----------------------
if [ ! -d "$BUILD_OUTPUT" ]; then
  echo "❌ No build artifacts found in '$WORKSPACE/$BUILD_OUTPUT'. Deployment aborted."
  exit 1
fi

echo "✅ Build output found at $BUILD_OUTPUT"
echo "🔍 Build output contents:"
ls -la "$BUILD_OUTPUT"

# -----------------------
# Backup existing deployment
# -----------------------
echo "🗄️  Backing up current deployment..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ZIP_NAME="${PROJECT}_${TIMESTAMP}.zip"
ZIP_PATH="${BACKUP_DIR}/${ZIP_NAME}"

mkdir -p "$BACKUP_DIR"

if [ -d "$DEPLOY_PATH" ] && [ "$(ls -A "$DEPLOY_PATH")" ]; then
  echo "📦 Creating zip backup..."
  zip -r "$ZIP_PATH" "$DEPLOY_PATH"/* > /dev/null
  echo "✅ Backup ZIP created at $ZIP_PATH"
else
  echo "⚠️  Deployment path '$DEPLOY_PATH' is empty or missing. Skipping backup."
fi

# -----------------------
# Deploy the new build
# -----------------------
echo "🚚 Deploying new build to $DEPLOY_PATH..."

# Clean existing deployment directory (preserve the directory itself)
echo "🧼 Clearing existing files in $DEPLOY_PATH ..."
rm -rf "${DEPLOY_PATH:?}/"*
rm -rf "${DEPLOY_PATH:?}/".* 2>/dev/null || true  # remove hidden files (like .htaccess), ignore . and ..

# Copy build files to deployment path
echo "🚚 Copying new build to $DEPLOY_PATH ..."
cp -r "$BUILD_OUTPUT"/* "$DEPLOY_PATH"
cp -r "$BUILD_OUTPUT"/.* "$DEPLOY_PATH" 2>/dev/null || true  # copy hidden files (e.g., .htaccess)

echo "✅ Deployment completed successfully!"
