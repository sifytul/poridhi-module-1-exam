# **Project Setup Guide: AWS Infrastructure Deployment with Pulumi**

## **Prerequisites**
- AWS account with CLI access
- Pulumi CLI installed (`curl -fsSL https://get.pulumi.com | sh`)
- Git installed

## **1. System Setup**
```bash
# Update package lists and install Python virtualenv
sudo apt update && sudo apt install -y python3.8-venv
```

## **2. AWS Configuration**
```bash
# Configure AWS CLI (interactive)
aws configure

# Create EC2 key pair
aws ec2 create-key-pair --key-name key-pair --query 'KeyMaterial' --output text > ~/.ssh/key-pair.id_rsa 
chmod 400 ~/.ssh/key-pair.id_rsa
```

## **3. Repository Setup**
```bash
# Clone infrastructure repository
git clone https://github.com/sifytul/poridhi-module-1-exam.git .
cd aws_infra
```

## **5. Pulumi Initialization**
```bash
# Login to Pulumi (choose your backend)
pulumi login  # For Pulumi Cloud, or use --local for filesystem

# Verify installation
pulumi about

# Create new stack (interactive)
pulumi stack init <any_name>

# Preview changes
pulumi preview
```

## **6. Deploy Infrastructure**
```bash
# Apply changes (auto-approve)
pulumi up --yes

# Show outputs (URLs, IPs etc.)
pulumi stack output
```


## **7. Test**
```bash
# collect node_instance_public_ip and replace in curl
pulumi stack output nodejs_public_ip


# health endpoint
curl -s <node_instance_public_ip>:4000/health | jq

# users endpoint
curl -s <node_instance_public_ip>:4000/users | jq


```




## **Post-Deployment**
1. **Verify Resources** in AWS Console
2. **Save Stack Outputs** for application configuration
3. **Destroy Resources** when done:
   ```bash
   pulumi destroy --yes
   ```

## **Cleanup**
```bash
# Remove stack and resources
pulumi stack rm <stack_name> --yes
