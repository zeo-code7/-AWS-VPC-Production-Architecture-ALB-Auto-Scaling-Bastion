# 02 · Create Subnets

## Overview
We create 4 subnets — 2 public and 2 private — spread across 2 Availability Zones for high availability.

## Subnet Plan

| Name | Type | AZ | CIDR | Purpose |
|---|---|---|---|---|
| public-subnet-a | Public | ap-south-1a | 10.0.0.0/24 | ALB + NAT Gateway |
| public-subnet-b | Public | ap-south-1b | 10.0.1.0/24 | ALB + NAT Gateway |
| private-subnet-a | Private | ap-south-1a | 10.0.2.0/24 | EC2 Server 1 |
| private-subnet-b | Private | ap-south-1b | 10.0.3.0/24 | EC2 Server 2 |

Each /24 subnet gives **256 IP addresses** (251 usable — AWS reserves 5).

## Steps

1. Go to **VPC → Subnets → Create subnet**
2. Select VPC: `my-vpc01`
3. Add all 4 subnets in one session using **Add new subnet**

### Subnet 1 — Public A
- Subnet name: `public-subnet-a`
- Availability Zone: `ap-south-1a`
- IPv4 CIDR: `10.0.0.0/24`

### Subnet 2 — Public B
- Subnet name: `public-subnet-b`
- Availability Zone: `ap-south-1b`
- IPv4 CIDR: `10.0.1.0/24`

### Subnet 3 — Private A
- Subnet name: `private-subnet-a`
- Availability Zone: `ap-south-1a`
- IPv4 CIDR: `10.0.2.0/24`

### Subnet 4 — Private B
- Subnet name: `private-subnet-b`
- Availability Zone: `ap-south-1b`
- IPv4 CIDR: `10.0.3.0/24`

4. Click **Create subnet**

## Enable Auto-assign Public IP (Public subnets only)

After creation, for each **public** subnet:
- Select subnet → **Actions → Edit subnet settings**
- ✅ Enable **Auto-assign public IPv4 address**
- Save

> ⚠️ Do NOT enable auto-assign public IP on private subnets. Private instances must have no public IP — all traffic must route through the ALB.

---
Next: [03 · Internet Gateway →](03-internet-gateway.md)
