# Jenkins CI/CD for React Application 🚀

This repository demonstrates a **Jenkins Freestyle Job** setup to build and deploy a **React.js application** using custom scripts for both **Windows** and **Linux** environments.

It includes:
- Automated environment validation
- Separate build and deploy stages
- Environment-specific builds (`qa`, `uat`)
- Safe deployment with backup (for Linux)
- Example scripts to use in Jenkins jobs

---

## ⚙️ Prerequisites

Before using these scripts, ensure that:

- **Jenkins** is installed and running.
- Node.js and npm are installed on the build agent.
- You have an existing **React project** in Jenkins workspace.
- For Linux: nginx or any web server is available for deployment.

---

## 🚧 Windows Setup (QA Environment)

1. Copy the batch files to your Jenkins workspace:
scripts/windows/build.bat
scripts/windows/deploy.bat

2. In Jenkins:
- Create a **Freestyle Project** named 'react-qa-build'.
- Under **Build Steps**, add:
  - **Execute Windows batch command** → 'scripts/windows/build.bat'
- Optionally add a **Post-build Step**:
  - **Execute Windows batch command** → 'scripts/windows/deploy.bat'

3. Ensure Jenkins injects the parameter 'env=qa' into the job.

---

## 🐧 Linux Setup (UAT Environment)

1. Copy 'scripts/linux/build_deploy.sh' to your Jenkins workspace.

2. Make the script executable:
chmod +x scripts/linux/build_deploy.sh

3. In Jenkins:
Create a Freestyle Project named react-uat-deploy.
Add a Build Step → “Execute shell”:
scripts/linux/build_deploy.sh

4. Jenkins should inject the parameter:
env=uat


📜 License

This project is open source under the MIT License — free to use and modify.
