# 03 · Internet Gateway & Route Tables

## Overview
The Internet Gateway (IGW) connects your VPC to the public internet. Route tables tell traffic where to go.

---

## Part A — Internet Gateway

### Steps
1. Go to **VPC → Internet Gateways → Create internet gateway**
2. Name: `my-internet-gateway`
3. Click **Create internet gateway**
4. After creation: **Actions → Attach to VPC**
5. Select `my-vpc01` → **Attach internet gateway**

You should see **State: Attached** ✅

---

## Part B — Public Route Table

### Create route table
1. Go to **VPC → Route Tables → Create route table**
2. Name: `my-route-table`
3. VPC: `my-vpc01`
4. Click **Create route table**

### Add IGW route
1. Select the route table → **Routes tab → Edit routes**
2. Click **Add route**
3. Destination: `0.0.0.0/0`
4. Target: **Internet Gateway** → select `my-internet-gateway`
5. Click **Save changes**

Your routes should now look like:

| Destination | Target | Purpose |
|---|---|---|
| 10.0.0.0/16 | local | Internal VPC traffic |
| 0.0.0.0/0 | igw-xxx | All internet traffic |

### Associate with public subnets
1. Select route table → **Subnet associations tab**
2. Click **Edit subnet associations**
3. Check ✅ `public-subnet-a` and `public-subnet-b`
4. Save

---

## Part C — Private Route Tables (for NAT Gateway)

Create a separate route table for each private subnet after NAT Gateways are created (see [04 · EC2](04-ec2-instances.md)).

| Route Table | Subnet | 0.0.0.0/0 Target |
|---|---|---|
| private-rt-a | private-subnet-a | nat-gw-a |
| private-rt-b | private-subnet-b | nat-gw-b |

> ⚠️ Private subnets must NOT route to the Internet Gateway directly. They route outbound traffic through NAT Gateways only.

---
Next: [04 · EC2 Instances →](04-ec2-instances.md)
