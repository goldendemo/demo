# Maia: Your Agentic Data Engineer for Personalized Demos

![Maia Banner](https://placehold.co/1200x300/7B68EE/FFFFFF?text=Maia%3A%20The%20Data%20Productivity%20Cloud)

## Introduction

Welcome to the official repository for personalized demonstrations of **Maia, the Data Productivity Cloud's Agentic Data Engineer**. This project provides the necessary resources, scripts, and documentation to showcase the power of Maia in various data environments. Whether you're a potential customer, a data enthusiast, or a developer, this repository will help you understand and experience firsthand how Maia can revolutionize your data workflows.

## What is Maia?

Maia is a state-of-the-art agentic data engineer designed to automate and optimize the entire data lifecycle. From data ingestion and transformation to analysis and visualization, Maia acts as an intelligent partner, enabling data teams to focus on generating insights rather than managing infrastructure.

### Key Features of Maia:

* **Automated Data Ingestion:** Seamlessly connect to a wide range of data sources.
* **Intelligent Transformations:** Let Maia handle complex data cleaning, normalization, and enrichment tasks.
* **Natural Language Interaction:** Query your data and orchestrate workflows using plain English.
* **Proactive Monitoring & Optimization:** Maia continuously monitors performance and suggests improvements.
* **Scalable & Secure:** Built on a robust cloud architecture to handle data at any scale.

## Getting Started with Personalized Demos

This repository contains everything you need to run a personalized demo of Maia. Follow these steps to get started:

### Prerequisites
* **Matillion DPC Account:** Access to the hub at `https://hub.matillion.com`.
* **GitHub Actions:** Ensure you have permissions to view and trigger workflows in the Actions tab.
* **Snowflake:** A valid Snowflake user/role with access to the `snowflake_dwh_*` connections.

## ⚙️ Required Integration: Matillion GitHub App

**IMPORTANT:** To enable synchronization between this repository and the Matillion Data Productivity Cloud (DPC), you must ensure the Matillion GitHub App is installed and has access to this repository.

1. **Install the App:** If not already present in your organization/account, install the [Matillion App from the GitHub Marketplace](https://docs.matillion.com/data-productivity-cloud/designer/docs/installing-matillion-app-github-marketplace/).
2. **Grant Permissions:** Ensure the app has "Read and Write" access to code and metadata for this specific repository.
3. **Overview:** For more details on how this integration manages secure communication, see the [Matillion GitHub App Overview](https://docs.matillion.com/data-productivity-cloud/designer/docs/matillion-github-app-overview/).

## Provisioned Environments
This repository is linked to a Matillion DPC Project containing the following environments:
* **Demo:** Primary environment for live walkthroughs (Admin access).
* **Develop:** Sandbox for creating new pipelines.
* **Production:** Locked-down environment for final deployments.

### Installation

### Verification
1. Open the **Actions** tab to see the CI/CD pipelines.
2. Check the **Settings > Secrets and variables > Actions** to verify that `DPC_PROJECT_ID` and Snowflake credentials have been securely provisioned.

## Running a Demo

The setup for this experience is fully automated. To showcase the power of **Maia, the Agentic Data Engineer**, please follow the comprehensive step-by-step instructions located in the internal documentation folder:

### 📖 [User Guide: Executing the Maia Experience](.maia-experience/USER_GUIDE.md)

### What’s Covered in the Guide:

* **Triggering Workflows:** How to use GitHub Actions to initiate the data engineering lifecycle.
* **Environment Validation:** How to verify the three provisioned DPC environments: `demo`, `develop`, and `production`.
* **Connection Security:** Understanding the unique platform connection pattern (`snowflake_dwh_{env_name}`) that ensures data isolation.
* **Natural Language Interaction:** Examples of how to interact with Maia to perform transformations and analysis.

---

### Quick Start Verification
Before starting the guide, ensure your automated environment is healthy:
1. **GitHub Actions:** Check the **Actions** tab to confirm workflows are present and ready.
2. **DPC Project:** Log in to Matillion DPC and verify Project ID `{{DPC_PROJECT_ID}}` exists.
3. **Snowflake Secrets:** Ensure `SNOWFLAKE_PK` is present in your GitHub Repository Secrets.
---
