# 07 · Application Load Balancer (ALB)

## Overview
The ALB (FirstALB) sits in the public subnets and distributes HTTP traffic across private EC2 instances in both AZs.

---

## Part A — Create Target Group

Go to **EC2 → Target Groups → Create target group**

| Field | Value |
|---|---|
| Target type | Instances |
| Name | ALB |
| Protocol | HTTP |
| Port | 80 |
| VPC | my-vpc01 |
| Protocol version | HTTP1 |

### Health Check Settings
| Field | Value |
|---|---|
| Health check protocol | HTTP |
| Health check path | /index.html |
| Healthy threshold | 5 |
| Unhealthy threshold | 2 |
| Timeout | 5 seconds |
| Interval | 30 seconds |
| Success codes | 200 |

> ⚠️ The health check path `/index.html` must exist on your EC2. If it returns anything other than HTTP 200, the instance is marked **unhealthy** and gets a 503.

### Register Targets
1. Click **Next: Register targets**
2. Select both private EC2 instances
3. Click **Include as pending below**
4. Click **Create target group**

---

## Part B — Create Application Load Balancer

Go to **EC2 → Load Balancers → Create load balancer → Application Load Balancer**

### Basic Configuration
| Field | Value |
|---|---|
| Name | FirstALB |
| Scheme | Internet-facing |
| IP address type | IPv4 |

### Network Mapping
| Field | Value |
|---|---|
| VPC | my-vpc01 |
| AZ-1 | ap-south-1a → public-subnet-a |
| AZ-2 | ap-south-1b → public-subnet-b |

> ⚠️ ALB must be placed in PUBLIC subnets — NOT private subnets. Even though it routes to private EC2s, the ALB itself must be internet-reachable.

### Security Groups
- Select: `mySG` (HTTP:80 + SSH:22 inbound)

### Listener
| Field | Value |
|---|---|
| Protocol | HTTP |
| Port | 80 |
| Default action | Forward to → ALB (target group) |

### Create
Click **Create load balancer**

Wait 2–3 minutes for status to change from **Provisioning** → **Active** ✅

---

## Verify ALB is Working

1. Go to **EC2 → Load Balancers → FirstALB**
2. Copy the **DNS name**: `FirstALB-1427038446.ap-south-1.elb.amazonaws.com`
3. Open in browser → you should see your website
4. Refresh multiple times → hostname alternates between Server 1 and Server 2 ✅

---

## ALB Details (from project)

| Field | Value |
|---|---|
| Name | FirstALB |
| Status | Active ✅ |
| Scheme | Internet-facing |
| AZs | ap-south-1a (aps1-az1) · ap-south-1b (aps1-az3) |
| VPC | vpc-0b3e3b7c0998bd561 (my-vpc01) |
| DNS | FirstALB-1427038446.ap-south-1.elb.amazonaws.com |

---
Next: [08 · Auto Scaling →](08-auto-scaling.md)
