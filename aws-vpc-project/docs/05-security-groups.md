# 05 · Security Groups

## Overview
Security groups are stateful virtual firewalls. We need two: one for the ALB and one for EC2 instances.

---

## SG-1: ALB Security Group (`sg-alb`)

Go to **EC2 → Security Groups → Create security group**

| Field | Value |
|---|---|
| Name | mySG / sg-alb |
| Description | Allows HTTP access from internet |
| VPC | my-vpc01 |

### Inbound Rules
| Type | Protocol | Port | Source | Purpose |
|---|---|---|---|---|
| HTTP | TCP | 80 | 0.0.0.0/0 | Public web traffic |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Secure web traffic |
| SSH | TCP | 22 | 0.0.0.0/0 | Admin access |

### Outbound Rules
| Type | Protocol | Port | Destination |
|---|---|---|---|
| All traffic | All | All | 0.0.0.0/0 |

---

## SG-2: EC2 Security Group (`sg-ec2`)

| Field | Value |
|---|---|
| Name | sg-ec2 |
| Description | Allow traffic from ALB only |
| VPC | my-vpc01 |

### Inbound Rules
| Type | Protocol | Port | Source | Purpose |
|---|---|---|---|---|
| HTTP | TCP | 80 | sg-alb | From ALB only — not internet |
| SSH | TCP | 22 | Bastion SG | From bastion only |

### Outbound Rules
| Type | Protocol | Port | Destination |
|---|---|---|---|
| All traffic | All | All | 0.0.0.0/0 |

> 🔒 **Key security principle:** Setting EC2 inbound source to `sg-alb` (the ALB's security group ID) instead of `0.0.0.0/0` ensures EC2 only accepts traffic that came through your load balancer. Direct access is blocked.

---
Next: [06 · Bastion Host →](06-bastion-host.md)
