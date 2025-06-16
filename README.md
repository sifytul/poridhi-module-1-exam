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
aws ec2 create-key-pair --key-name key-pair --query 'KeyMaterial' --output text > ~/.ssh/key-pair.pem 
chmod 400 ~/.ssh/key-pair.pem
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

## **Post-Deployment**
1. **Verify Resources** in AWS Console
2. **Save Stack Outputs** for application configuration
3. **Destroy Resources** when done:
   ```bash
   pulumi destroy --yes
   ```

## **Troubleshooting**
- **Python Errors**: Ensure virtualenv is activated
- **AWS Permissions**: Verify IAM user has proper rights
- **Pulumi Version**: Check with `pulumi version`

## **Cleanup**
```bash
# Remove stack and resources
pulumi stack rm <stack_name> --yes
