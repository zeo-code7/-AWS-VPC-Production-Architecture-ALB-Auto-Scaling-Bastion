# 04 · EC2 Instances

## Overview
We launch 3 EC2 instances: 1 Bastion Host (public) and 2 Web Servers (private).

---

## Instance Plan

| Name | Subnet | Public IP | Purpose |
|---|---|---|---|
| public ec2 (bastion) | public-subnet-a | 13.206.97.41 | SSH jump server |
| private server 1 | private-subnet-a | None | Web server AZ-A |
| private server 2 | private-subnet-b | None | Web server AZ-B |

---

## Launch Bastion Host (Public EC2)

1. Go to **EC2 → Instances → Launch instances**
2. Name: `public ec2`
3. AMI: **Ubuntu Server 22.04 LTS** (Free tier eligible)
4. Instance type: `t3.micro`
5. Key pair: select your `.pem` key pair (e.g. `public vpc`)

### Network settings
- VPC: `my-vpc01`
- Subnet: `public-subnet-a`
- Auto-assign public IP: **Enable**
- Security group: create new → name `launch-wizard-1`
  - Inbound: SSH · TCP · 22 · 0.0.0.0/0

6. Click **Launch instance**

---

## Launch Private Web Server 1

1. Go to **EC2 → Instances → Launch instances**
2. Name: `private`
3. AMI: **Ubuntu Server 22.04 LTS**
4. Instance type: `t3.micro`
5. Key pair: same `.pem` key

### Network settings
- VPC: `my-vpc01`
- Subnet: `private-subnet-a`
- Auto-assign public IP: **Disable**
- Security group: create new → name `launch-wizard-2`
  - Inbound: SSH · TCP · 22 · 0.0.0.0/0
  - Inbound: HTTP · TCP · 80 · 0.0.0.0/0

6. Click **Launch instance**

---

## Launch Private Web Server 2

Repeat the same steps as Server 1 but:
- Name: `ALb instance`
- Subnet: `private-subnet-b`

---

## Verify Instances

After launch, both should show:

| Instance | State | Public IP | Private IP |
|---|---|---|---|
| public ec2 | ✅ Running | 13.206.97.41 | 10.0.1.249 |
| private | ✅ Running | — | 10.0.2.146 |

---

## Install Apache on Private Instances

Use the bastion to SSH in (see [06 · Bastion Host](06-bastion-host.md)), then run:

```bash
sudo apt update -y
sudo apt install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2

# Create health check file
echo "OK" | sudo tee /var/www/html/health

# Deploy website
sudo cp /home/ubuntu/index.html /var/www/html/index.html
sudo systemctl restart apache2
```

Or use the bootstrap script: `scripts/install-apache.sh`

---
Next: [05 · Security Groups →](05-security-groups.md)
