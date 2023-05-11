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
3. This repository, `placeholder_repo_name`, cloned into the codespace required above.



## Select Cloud
- [GCP](#GCP)
- [AWS](#AWS)

## GCP

### Deploy Kubernetes
1. Create Credentials
    - [Launch a CloudShell](https://console.cloud.google.com/home/dashboard?cloudshell=true) in your desired GCP project.
    - Execute the following command in the cloudshell.  Click 'Authorize' if prompted and confirm the creation of the project

    ```sh
source <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/feature/gcp-project-tools/tools/gcp/gcp-project-setup) && \
    gcp-project-setup -p placeholder_tenant_key-placeholder_cluster_environment
```
    - 1Copy the contents of the `creds.json` file that was generated by the above command into this repository, within the codespace.

2. Deploy Kubernetes with Terraform
    - Set credentials for Terraform using the `creds.json` created in step 1a.:

    ```sh
export GOOGLE_CREDENTIALS=$(pwd)/creds.json
```

    - Reference documents for [terraform-module-cloud-gcp-kubernetes-cluster](https://github.com/GlueOps/terraform-module-cloud-gcp-kubernetes-cluster) and use the pre-created directory `terraform/kubernetes` within this repo for the `main.tf` file to deploy the cluster.

3. Access the new Kubernetes Cluster

    ```sh
source <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/feature/gcp-project-tools/tools/gcp/gke-auth) && \
    gke-auth
```
    
### Teardown Kubernetes
Use the following command to destroy the cluster when it is no longer needed.

```sh
source <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/feature/gcp-project-tools/tools/gcp/gcp-project-teardown) && \
    gcp-project-teardown -p placeholder_tenant_key-placeholder_cluster_environment
```


## AWS

