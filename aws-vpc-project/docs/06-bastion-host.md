# 06 · Bastion Host — SSH Jump into Private Subnet

## Overview
Private EC2 instances have no public IP. To access them, we SSH into the public bastion host first, then jump into the private instance.

```
Your Machine → (SSH) → Bastion (13.206.97.41) → (SSH) → Private EC2 (10.0.2.146)
```

---

## Method 1 — SSH Jump Flag (Recommended)

From your local machine, use the `-J` (jump) flag:

```bash
ssh -i private.pem -J ubuntu@13.206.97.41 ubuntu@10.0.2.146
```

This creates a direct tunnel in one command. No need to manually SSH into the bastion first.

---

## Method 2 — Two-step SSH (Manual)

### Step 1: Copy .pem key to bastion
```bash
scp -i private.pem private.pem ubuntu@13.206.97.41:/home/ubuntu/
```

### Step 2: SSH into bastion
```bash
ssh -i private.pem ubuntu@13.206.97.41
```

### Step 3: From bastion, SSH into private EC2
```bash
# Inside the bastion
sudo su
chmod 400 /home/ubuntu/private.pem
ssh -i /home/ubuntu/private.pem ubuntu@10.0.2.146
```

> This is exactly what was done in the project — visible in `screenshots/Screenshot_113541.png`

---

## Fix Permission Error

If you see `WARNING: UNPROTECTED PRIVATE KEY FILE`, fix with:

```bash
chmod 400 private.pem
```

---

## What to do once inside private EC2

```bash
# Update and install Apache
sudo apt update -y
sudo apt install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2

# Create health check endpoint (required by ALB!)
echo "OK" | sudo tee /var/www/html/health

# Verify Apache is running
sudo systemctl status apache2
curl localhost
```

---

## Using the helper script

```bash
# From your machine
bash scripts/ssh-bastion.sh
```

See `scripts/ssh-bastion.sh` for the full script.

---
Next: [07 · Load Balancer →](07-load-balancer.md)
