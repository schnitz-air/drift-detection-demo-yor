# Cortex Cloud Drift Detection Demo

This repository contains a sample Infrastructure as Code (IaC) setup using Terraform and GitHub Actions to demonstrate the drift detection capabilities of Cortex Cloud.

## Overview

The setup deploys a simple Nginx web server (Namespace, Deployment, and Service) to a Kubernetes cluster. The GitHub Actions workflow automatically applies the Terraform configuration whenever changes are pushed to the `main` branch.

## Prerequisites

1. A Kubernetes cluster.
2. A GitHub repository to host this code.
3. Cortex Cloud configured to monitor your Kubernetes cluster and GitHub repository.

## Setup Instructions

### 1. Configure AWS IAM and GitHub Secrets

To allow GitHub Actions to authenticate with your Amazon EKS cluster, you need to configure AWS IAM credentials and add your `kubeconfig` as a repository secret.

#### A. Create an IAM User for GitHub Actions

1. Create an IAM user in your AWS account (e.g., `github-actions-eks-deployer`).
2. Create and attach an IAM policy that allows the user to describe the EKS cluster. Example policy:
   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Action": [
                   "eks:DescribeCluster"
               ],
               "Resource": "arn:aws:eks:<region>:<account-id>:cluster/<cluster-name>"
           }
       ]
   }
   ```
3. Generate an **Access Key ID** and **Secret Access Key** for this user.
4. Add this user to the `aws-auth` ConfigMap in your EKS cluster (in the `kube-system` namespace) with `system:masters` permissions so it can create and manage resources.

#### B. Add GitHub Secrets

1. Go to your GitHub repository settings.
2. Navigate to **Secrets and variables** > **Actions**.
3. Add the following secrets:
   * `AWS_ACCESS_KEY_ID`: The Access Key ID generated in step A3.
   * `AWS_SECRET_ACCESS_KEY`: The Secret Access Key generated in step A3.
   * `KUBECONFIG`: The contents of your `~/.kube/config` file (or the specific kubeconfig for your cluster). You can extract just the current context using `kubectl config view --minify --flatten`.

### 2. Push the Code

Push the contents of this directory to your GitHub repository's `main` branch. The GitHub Actions workflow will automatically trigger and deploy the resources to your cluster.

```bash
git init
git add .
git commit -m "Initial commit: Add Terraform and GitHub Actions for drift demo"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```

## Executing the Drift Detection Demo

Once the initial deployment is successful, you can demonstrate Cortex Cloud's drift detection capabilities by following these steps:

### Step 1: Establish the Baseline

1. Verify in Cortex Cloud that the resources (Namespace `cortex-drift-demo`, Deployment `nginx-deployment`, Service `nginx-service`) are discovered and mapped to this GitHub repository.
2. Show that Cortex Cloud reports **No Drift** for these resources, as the cluster state matches the IaC baseline.

### Step 2: Introduce Manual Drift

Simulate an out-of-band change by manually modifying a resource directly in the Kubernetes cluster using `kubectl`.

For example, change the number of replicas in the deployment:

```bash
kubectl scale deployment nginx-deployment --replicas=5 -n cortex-drift-demo
```

Or, change the container image:

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.26.0 -n cortex-drift-demo
```

### Step 3: Observe Drift in Cortex Cloud

1. Navigate back to Cortex Cloud.
2. Wait for the next scan cycle or manually trigger a scan.
3. Cortex Cloud will detect the discrepancy between the cluster state (e.g., 5 replicas) and the IaC definition in GitHub (2 replicas).
4. Show the **Drift Detected** alert in the Cortex Cloud UI, highlighting the specific fields that differ.

### Step 4: Remediate the Drift

You can remediate the drift in two ways:

**Option A: Revert the manual change (Align Cluster to IaC)**
Run the GitHub Actions workflow again (or run `terraform apply` locally) to revert the cluster state back to the IaC definition.

**Option B: Update the IaC (Align IaC to Cluster)**
If the manual change was intentional, update the `replicas` variable in `terraform/variables.tf` to match the new cluster state, commit, and push the change.

```hcl
# terraform/variables.tf
variable "replicas" {
  description = "The number of replicas for the Nginx deployment"
  type        = number
  default     = 5 # Updated to match cluster state
}
```

After pushing the update, Cortex Cloud will re-evaluate and report that the drift has been resolved.
 
