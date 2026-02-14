# Ansible Configuration for LawPoint Deployment

This directory contains Ansible playbooks for configuring servers and deploying the LawPoint application.

## Prerequisites

1. **Ansible** installed on your local machine
2. **SSH access** to target servers
3. **SSH key** for authentication

## Installation

### Install Ansible

**Ubuntu/WSL:**
```bash
sudo apt update
sudo apt install ansible -y
```

**macOS:**
```bash
brew install ansible
```

**Windows (WSL recommended)**

## Configuration

### 1. Update Inventory

Edit `inventory.ini` and add your server IP:

```ini
[lawpoint_servers]
54.123.456.789 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/lawpoint-key.pem
```

### 2. Test Connection

```bash
ansible -i inventory.ini lawpoint_servers -m ping
```

## Deployment

### Deploy Application

```bash
ansible-playbook -i inventory.ini deploy.yml
```

### What It Does

1. ✅ Updates system packages
2. ✅ Installs Docker and Docker Compose
3. ✅ Configures Docker service
4. ✅ Creates application directory
5. ✅ Copies docker-compose.yml
6. ✅ Pulls Docker images from Docker Hub
7. ✅ Starts all containers
8. ✅ Verifies application is running

## Common Commands

```bash
# Check syntax
ansible-playbook -i inventory.ini deploy.yml --syntax-check

# Dry run
ansible-playbook -i inventory.ini deploy.yml --check

# Run with verbose output
ansible-playbook -i inventory.ini deploy.yml -v

# Run specific tasks
ansible-playbook -i inventory.ini deploy.yml --tags docker
```

## Integration with Terraform

After Terraform creates infrastructure:

1. Get EC2 IP from Terraform output
2. Update `inventory.ini` with the IP
3. Run Ansible playbook to deploy

```bash
# Get Terraform output
cd ../terraform
terraform output instance_public_ip

# Update inventory.ini
cd ../ansible
# Edit inventory.ini with the IP

# Deploy
ansible-playbook -i inventory.ini deploy.yml
```

## Troubleshooting

### Issue: Permission denied (SSH)

**Solution**: Ensure SSH key has correct permissions
```bash
chmod 400 ~/.ssh/lawpoint-key.pem
```

### Issue: Host key verification failed

**Solution**: Add to `~/.ssh/config`:
```
Host *
    StrictHostKeyChecking no
```

Or run once:
```bash
ssh-keyscan -H <SERVER_IP> >> ~/.ssh/known_hosts
```

### Issue: Python not found

**Solution**: Install Python on target server
```bash
ssh ubuntu@<IP> 'sudo apt install python3 -y'
```
