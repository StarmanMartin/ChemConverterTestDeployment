# ChemConverterTestDeployment

Docker container factory for test deployments of ChemConverter

**⚠️ Disclaimer

This setup is for testing purposes only and should not be used in production.
Please shut down the container after you're done!**

## 🚀 What is this?

This repository provides a Dockerfile to build a Docker image that allows you to quickly and easily deploy Chem Converter (App & Client) in a test environment.
The content is automatically updated after each new commit on the selected branches.

-> __No webhooks are needed!__ It is easy to set up and you do not require any privileges.

The prebuilt image is available on Docker Hub:
```mstarman/chem-converter-test:0.0.4```

The included docker-compose.yml file demonstrates how to use the image.

## 🛠️ Getting Started

We provide an installation script that has only been tested on Ubuntu. However, you can also set it up manually in just a few steps

### Ubuntu install script

Run:

```shell
curl -H 'Cache-Control: no-cache' -O https://raw.githubusercontent.com/StarmanMartin/ChemConverterTestDeployment/main/setup.sh
chmod +x setup.sh
./setup.sh
```

### By Hand

1. Environment Variables

   * Copy the .env.sample file from this Repo to .env.

   * Make sure to review and update all environment variables, especially CONVERTER_URL and PROJECT_WEB_PORT.

2. Converter shared Folder Setup

   * Create a *converter* directory in the same location as your ```docker-compose.yml```.

   * This directory must contain the following subdirectories (you can also clone them from this repo):

   * Make two text files in the *converter* directory: ```APP_BRANCH.txt``` and ```CLIENT_BRANCH.txt```

   * Make sure you have the ```shell_script/example.sh`` from this repo 

```
converter/
   ├── dataset/
   ├── logs/
   ├── profiels/
   ├── shell_script/
         ├── set_branch.sh
         └── ...
   ├── APP_BRANCH.txt
   ├── CLIENT_BRANCH.txt
   └── htpasswd

```

Description of each folder:

* ```CLIENT_BRANCH.txt```: The GIT repo branch for the client. This branch is monitored and if there is a new commit, the server is automatically updated.
* ```APP_BRANCH.txt```: The GIT repo branch for the app. This branch is monitored and if there is a new commit, the server is automatically updated.
* ```shell_script/```: Any .sh scripts in this folder will be executed on container restart. This is useful for tasks such as installing packages (apt install ...) or updating environment variables.

## Switching Branches

To change the deployed Converter (App or Client) branch, modify the first line in the **APP_BRANCH.txt** or **CLIENT_BRANCH.txt**.