# Terraform Infrastructure for LawPoint

This Terraform configuration provisions AWS infrastructure for deploying the LawPoint application.

## Architecture

- **VPC**: Custom VPC with public subnet
- **EC2 Instance**: t3.medium Ubuntu 22.04 LTS server
- **Security Group**: Opens ports 22, 80, 443, 3000, 4000
- **Elastic IP**: Static public IP address
- **Auto-deployment**: User data script installs Docker and runs containers

## Prerequisites

1. **AWS Account** with appropriate permissions
2. **AWS CLI** installed and configured
3. **Terraform** installed (v1.0+)
4. **SSH Key Pair** created in AWS

## Setup Steps

### 1. Get AWS Credentials

**Go to AWS Console:**
1. Sign in to AWS Console: https://console.aws.amazon.com
2. Click your username → **My Security Credentials**
3. Click **Access keys (access key ID and secret access key)**
4. Click **Create New Access Key**
5. Copy **Access Key ID** and **Secret Access Key**

### 2. Configure AWS CLI

```bash
cd terraform
wsl aws configure
# Enter Access Key ID
# Enter Secret Access Key
# Default region: us-east-1
# Default output format: json
```

### 3. Create SSH Key Pair

In AWS Console:
- Go to **EC2 → Key Pairs → Create Key Pair**
- Name: `lawpoint-key`
- File format: `.pem`
- Download and save securely
- On Linux/WSL: `chmod 400 lawpoint-key.pem`

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Plan Deployment

```bash
terraform plan
```

### 6. Deploy Infrastructure

```bash
terraform apply
# Type 'yes' to confirm
```

### 7. Get Connection Details

```bash
terraform output
```

## Usage

### Access Application

After deployment (5-10 minutes):

```
Frontend: http://<PUBLIC_IP>:3000
Backend API: http://<PUBLIC_IP>:4000/api/lawyers
```

### SSH into Server

```bash
ssh -i lawpoint-key.pem ubuntu@<PUBLIC_IP>
```

### Check Docker Containers

```bash
ssh -i lawpoint-key.pem ubuntu@<PUBLIC_IP>
docker ps
docker-compose logs -f
```

## Destroy Infrastructure

When done (to avoid costs):

```bash
terraform destroy
# Type 'yes' to confirm
```

## Costs

Estimated AWS costs:
- **EC2 t3.medium**: ~$30/month
- **EBS Storage (20GB)**: ~$2/month
- **Elastic IP**: Free (if attached)
- **Data Transfer**: Varies

**Total**: ~$32/month

## Customization

Edit `variables.tf` to change:
- `aws_region`: Different AWS region
- `instance_type`: t3.small or t3.large
- `ami_id`: Different Ubuntu version

## Troubleshooting

### Issue: "error validating provider credentials"

**Solution**: Run `aws configure` again with correct credentials

### Issue: "resource does not have attribute"

**Solution**: Update Terraform providers
```bash
terraform init -upgrade
```

### Issue: "Key pair does not exist"

**Solution**: Create key pair in AWS EC2 console

### Issue: Cannot access application after deployment

**Solution**: Wait 10 minutes for user data script to complete
```bash
ssh -i lawpoint-key.pem ubuntu@<IP>
tail -f /var/log/cloud-init-output.log
```
