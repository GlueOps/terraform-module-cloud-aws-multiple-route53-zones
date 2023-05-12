# placeholder_repo_name

_Welcome to the tenant repository, used to manage a kubernetes deployment with the GlueOps Platform!_

## Overview
This README will outline the steps required to:

1. Create the necessary Accounts/Projects/Credentials to deploy kubernetes.
2. Deploy Kubernetes in the desired cloud. 
3. Deploy the GlueOps Platform (including ArgoCD) on the Kubernetes Cluster.
4. Tear down the cluster when it is no longer needed.

## Prerequisites
1. User account in the desired cloud with necessary permissions to create Service Users capable of deploying a Kubernetes cluster.
2. A [GlueOps codespace](https://github.com/GlueOps/glueops) at the latest version, which contains necessary tooling. <br /> **Note:** To ensure the latest version is used, [create a new Codespace with options](https://github.com/codespaces/new?hide_repo_select=true&ref=%F0%9F%9A%80%F0%9F%92%8E%F0%9F%99%8C%F0%9F%9A%80&repo=527049979) and select the newest version of `Dev container configuration`.
3. This repository, `placeholder_repo_name`, cloned into the codespace required above. Once the Codespace is created, the repo can be cloned using 

```sh
gh repo clone placeholder_github_owner/placeholder_repo_name
```


## Select Cloud
- [GCP](#GCP)
- [AWS](#AWS)

## GCP

### Deploy Kubernetes
1. Create Credentials
    * [Launch a CloudShell](https://console.cloud.google.com/home/dashboard?cloudshell=true) in your desired GCP project.
    * Execute the following command in the cloudshell.  Click 'Authorize' if prompted and confirm the creation of the project

    ```sh
    source <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/feature/gcp-project-tools/tools/gcp/gcp-project-setup) && \
        gcp-project-setup -p placeholder_tenant_key-placeholder_cluster_environment
    ```

    * Copy the contents of the `creds.json` file that was generated by the above command into this repository, within the codespace.

2. Deploy Kubernetes with Terraform
    * Set credentials for Terraform using the `creds.json` created in step 1a.:

    ```sh
    export GOOGLE_CREDENTIALS=$(pwd)/creds.json
    ```

    * Reference documents for [terraform-module-cloud-gcp-kubernetes-cluster](https://github.com/GlueOps/terraform-module-cloud-gcp-kubernetes-cluster) and use the pre-created directory `terraform/kubernetes` within this repo for the `main.tf` file to deploy the cluster.

3. Access the new Kubernetes Cluster by running the below command to set up kubeconfig

    ```sh
    source <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/feature/gcp-project-tools/tools/gcp/gke-auth) && \
        gke-auth
    ```
4. Now that Kubernetes is deployed and can be accessed, being [deploying the GlueOps Platform](#Deploying-GlueOps-the-Platform)


## AWS

### Deploy Kubernetes
1. Create Credentials
    * [Launch a CloudShell](https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-west-2) within the Primary/Root AWS Account.
    * Execute the following command in the cloudshell.  When prompted, enter the name of your captain account (e.g. glueops-captain-laciudaddelgato).

    ```sh
    bash <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/aws/tools/aws/account-setup.sh)
    ```

    * Create the`.env` as instructed into this repository, within the codespace.

2. Deploy Kubernetes with Terraform
    * Set credentials for Terraform using the `.env` created in step 1a.:

    ```sh
    export $(pwd)/.env
    ```

    * Reference documents for [terraform-module-cloud-aws-kubernetes-cluster](https://github.com/GlueOps/terraform-module-cloud-aws-kubernetes-cluster) and use the pre-created directory `terraform/kubernetes` within this repo for the `main.tf` file to deploy the cluster.

3. Access the new Kubernetes Cluster by running the below command to set up kubeconfig

    ```sh
    aws eks update-kubeconfig --region us-west-2 --name captain-cluster
    ```

4. Now that Kubernetes is deployed and can be accessed, being [deploying the GlueOps Platform](#Deploying-GlueOps-the-Platform)

## Deploying GlueOps the Platform


### Teardown Kubernetes

- [AWS](#AWS-Teardown)
- [GCP](#GCP-Teardown)

### AWS Teardown

Use the following command to destroy the cluster when it is no longer needed.
* [Launch a CloudShell](https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-west-2) within the Primary/Root AWS Account.
    * Execute the following command in the cloudshell.  When prompted, enter the name of your captain account (e.g. glueops-captain-laciudaddelgato).

```sh
bash <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/aws/tools/aws/account-nuke.sh)
```

### GCP Teardown

Use the following command to destroy the cluster when it is no longer needed.
* [Launch a CloudShell](https://console.cloud.google.com/home/dashboard?cloudshell=true) in your desired GCP project.
    * Execute the following command in the cloudshell.  Click 'Authorize' if prompted and confirm the deletion of the project

```sh
source <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/feature/gcp-project-tools/tools/gcp/gcp-project-teardown) && \
    gcp-project-teardown -p placeholder_tenant_key-placeholder_cluster_environment
```
