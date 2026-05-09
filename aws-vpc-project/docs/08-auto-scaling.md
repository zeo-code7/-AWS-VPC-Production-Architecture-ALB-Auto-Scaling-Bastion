# 08 · Auto Scaling Group

## Overview
The Auto Scaling Group (ASG) automatically manages EC2 instance count across both private subnets based on demand.

---

## Create Launch Template

Go to **EC2 → Launch Templates → Create launch template**

| Field | Value |
|---|---|
| Name | prod-lt |
| AMI | Ubuntu 22.04 LTS |
| Instance type | t3.micro |
| Key pair | your-key.pem |
| Security group | sg-ec2 |
| Subnet | Do not include (ASG assigns) |

### User Data (bootstrap script)
```bash
#!/bin/bash
apt update -y
apt install -y apache2
systemctl start apache2
systemctl enable apache2
echo "OK" > /var/www/html/health
echo "<h1>Server: $(hostname -f)</h1>" > /var/www/html/index.html
```

---

## Create Auto Scaling Group

Go to **EC2 → Auto Scaling Groups → Create**

| Field | Value |
|---|---|
| Name | prod-asg |
| Launch template | prod-lt (latest) |
| VPC | my-vpc01 |
| Subnets | private-subnet-a, private-subnet-b |

### Attach Load Balancer
- Attach to existing target group: **ALB**
- Health check type: **ELB** (uses ALB health checks)
- Health check grace period: **120 seconds**

### Capacity
| Field | Value |
|---|---|
| Minimum | 2 |
| Desired | 2 |
| Maximum | 6 |

### Scaling Policy — Target Tracking
| Field | Value |
|---|---|
| Policy type | Target tracking |
| Metric | Average CPU utilization |
| Target value | 70% |
| Scale-out cooldown | 300 seconds |
| Scale-in cooldown | 300 seconds |

---

## How Scaling Works

```
CPU > 70% for 2 periods → ASG launches new instances (up to max:6)
CPU < 30% for 2 periods → ASG terminates instances (down to min:2)
```

Minimum of 2 ensures one instance is always alive in each AZ — if AZ-A fails, AZ-B continues serving traffic.

---
Next: [09 · Troubleshooting →](09-troubleshooting.md)
