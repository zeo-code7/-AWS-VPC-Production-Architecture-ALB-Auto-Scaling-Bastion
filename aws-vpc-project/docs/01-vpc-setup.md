# 01 · Create the VPC

## Overview
The VPC (Virtual Private Cloud) is your isolated network on AWS. Everything lives inside it.

## Configuration

| Field | Value |
|---|---|
| Name | my-vpc01 |
| IPv4 CIDR | 10.0.0.0/16 |
| IPv6 | Disabled |
| Tenancy | Default |
| DNS Hostnames | ✅ Enabled |
| DNS Resolution | ✅ Enabled |

## Steps

1. Go to **VPC → Your VPCs → Create VPC**
2. Select **VPC only** (not "VPC and more")
3. Enter Name tag: `my-vpc01`
4. IPv4 CIDR block: `10.0.0.0/16`
5. Leave IPv6 as **No IPv6 CIDR block**
6. Tenancy: **Default**
7. Click **Create VPC**

> ⚠️ Always enable DNS hostnames. Without it, EC2 instances can't resolve public hostnames — this breaks SSM Session Manager and many bootstrap scripts.

## What you get
A /16 CIDR gives you **65,536 IP addresses** to distribute across your subnets. More than enough for this project.

---
Next: [02 · Subnets →](02-subnets.md)
