@echo off
:: Post-build: Deploy the build artifacts

:: Deployment path
SET DEPLOY_PATH=C:\nginx\html\project-dir
SET BUILD_OUTPUT=dist\qa_build

:: Verify that the build was successful before deployment
IF NOT EXIST "%WORKSPACE%\%BUILD_OUTPUT%" (
    echo "No build artifacts found in %WORKSPACE%\%BUILD_OUTPUT%. Deployment aborted."
    exit /b 1
)

:: Check if the deployment directory exists, create if not
IF NOT EXIST "%DEPLOY_PATH%" (
    echo Deployment directory does not exist. Creating...
    mkdir "%DEPLOY_PATH%"
)

:: Remove existing files from the deployment directory
echo Clearing existing files from the deployment directory...
rmdir /S /Q "%DEPLOY_PATH%"
IF %ERRORLEVEL% NEQ 0 (
    echo "Failed to clear the deployment directory."
    exit /b 1
)

:: Copy built files to the deployment directory
echo Copying build files to deployment directory...
xcopy /E /H /C /I "%WORKSPACE%\%BUILD_OUTPUT%" "%DEPLOY_PATH%"
IF %ERRORLEVEL% NEQ 0 (
    echo "File copy failed. Deployment unsuccessful."
    exit /b 1
)

echo "Deployment completed successfully!"
exit /b 0
