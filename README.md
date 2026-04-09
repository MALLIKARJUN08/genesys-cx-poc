# Genesys Cloud CX as Code POC 🚀

A modular, automated, multi-environment proof-of-concept for managing Genesys Cloud resources through Terraform and GitHub Actions.

## 🏗️ Project Overview
This project uses **Infrastructure as Code (IaC)** to manage Genesys Cloud Routing Queues, Users, and Roles. It is designed to be scalable, secure, and easy for contact center administrators to use.

## 📁 Repository Structure
- **/modules**: The core "recipes" for Genesys resources.
  - `/divisions`: Division management.
  - `/queues`: Routing Queue management.
  - `/users`: Person/Account management.
  - `/roles`: Authorization & Permissions.
  - `/skills`: Routing Skills management.
- **/.github/workflows**: The automated CI/CD pipeline using GitHub Actions.
- `main.tf`: The root orchestrator.
- `*.auto.tfvars`: **Your control panel**—declarative resource configurations.
- `SETUP_GUIDE.md`: Complete build-from-scratch guide.
- `ARCHITECTURE.md`: System architecture and data flow.
- `CONFIG_REFERENCE.md`: Detailed variable reference.

## 🚦 Getting Started
1. **Manual Deployment**: Use the "Run workflow" button in the GitHub Actions tab to choose between `poc` and `prod`.
2. **Automated Deployment**: Any push to the `main` branch automatically deploys to the `poc` environment.

## 📖 Documentation
- [Complete Setup Guide](SETUP_GUIDE.md) - Step-by-step build instructions.
- [Architecture Overview](ARCHITECTURE.md) - System design and dependencies.
- [Configuration Reference](CONFIG_REFERENCE.md) - Detailed variable documentation.
- [Core Documentation](PROJECT_DOCUMENTATION.md)
- [Scaling to Multiple Environments](MULTI_ENVIRONMENT_GUIDE.md)
- [Walkthrough & Verification](walkthrough.md)

---
*Maintained by the DevOps & CX Team.*
