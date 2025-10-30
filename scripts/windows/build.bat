@echo off

:: Capture the 'env' parameter (injected by Bitbucket)
SET PARAM_ENV=%env%

:: Define the expected environment variable for this job
SET EXPECTED_ENV=qa

:: Validate the environment
IF NOT "%PARAM_ENV%"=="%EXPECTED_ENV%" (
    echo "Triggered for %PARAM_ENV%, but this job is configured for %EXPECTED_ENV%. Aborting."
    exit /b 1
)

echo "Environment check passed. Proceeding with the build for %EXPECTED_ENV%..."

:: Navigate to workspace
cd "%WORKSPACE%"
echo Workspace Directory: %WORKSPACE%


:: Build the application
echo Building the React application...

npm install --force && npm run build:qa
IF %ERRORLEVEL% NEQ 0 (
    echo "Error: Build failed!"
    exit /b 1
)

echo "Pre-build completed successfully!"

