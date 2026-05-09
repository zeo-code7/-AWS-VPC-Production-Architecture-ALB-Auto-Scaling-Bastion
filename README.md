# 🏗️ AWS VPC Production Architecture — Full Project

> A production-grade AWS networking project built entirely from the AWS Console.
> Custom VPC · Application Load Balancer · Auto Scaling · Private Subnets · Bastion Host

![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![VPC](https://img.shields.io/badge/VPC-Networking-0a66c2?style=for-the-badge)
![ALB](https://img.shields.io/badge/ALB-Load%20Balancer-00c27b?style=for-the-badge)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active%20✅-success?style=for-the-badge)

---

## 📐 Architecture Diagram

```
┌─────────────────────── AWS Region: ap-south-1 (Mumbai) ────────────────────────┐
│                                                                                  │
│  ┌──────────────────────────── VPC: my-vpc01 (10.0.0.0/16) ──────────────────┐  │
│  │                                                                             │  │
│  │   ┌────── AZ-1: ap-south-1a ──────────┐  ┌───── AZ-2: ap-south-1b ──────┐ │  │
│  │   │                                    │  │                               │ │  │
│  │   │  ┌─── Public Subnet ────────────┐  │  │  ┌─── Public Subnet ───────┐ │ │  │
│  │   │  │  NAT Gateway A               │  │  │  │  NAT Gateway B          │ │ │  │
│  │   │  │  ALB Node ──────────────────────────── ALB Node                 │ │ │  │
│  │   │  └──────────────────────────────┘  │  │  └─────────────────────────┘ │ │  │
│  │   │                                    │  │                               │ │  │
│  │   │  ┌─── Private Subnet ───────────┐  │  │  ┌─── Private Subnet ──────┐ │ │  │
│  │   │  │  EC2: Server 1               │  │  │  │  EC2: Server 2          │ │ │  │
│  │   │  │  10.0.2.146                  │  │  │  │  10.0.3.x               │ │ │  │
│  │   │  └──────────────────────────────┘  │  │  └─────────────────────────┘ │ │  │
│  │   └────────────────────────────────────┘  └───────────────────────────────┘ │  │
│  │                                                                               │  │
│  │   Auto Scaling Group ─────────────────────────────────────────────────────   │  │
│  │   Security Group (mySG): HTTP:80, SSH:22                                      │  │
│  │   Bastion Host: Public EC2 → SSH jump → Private EC2                           │  │
│  └───────────────────────────────────────────────────────────────────────────────┘  │
│                                                                                  │
│  Internet Gateway ──► ALB (FirstALB) ──► Target Group ──► EC2 instances         │
│  S3 Gateway Endpoint (private S3 access)                                         │
└──────────────────────────────────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
aws-vpc-project/
│
├── README.md                        ← You are here
│
├── website/
│   ├── server1/
│   │   └── index.html               ← Server 1 webpage (Blue theme · AZ-A)
│   └── server2/
│       └── index.html               ← Server 2 webpage (Green theme · AZ-B)
│
├── scripts/
│   ├── install-apache.sh            ← User data script for EC2 bootstrap
│   └── ssh-bastion.sh               ← Helper script for SSH jump via bastion
│
├── docs/
│   ├── 01-vpc-setup.md              ← Step-by-step VPC creation guide
│   ├── 02-subnets.md                ← Subnet configuration guide
│   ├── 03-internet-gateway.md       ← IGW + route table setup
│   ├── 04-ec2-instances.md          ← EC2 launch guide (public + private)
│   ├── 05-security-groups.md        ← Security group rules
│   ├── 06-bastion-host.md           ← Bastion SSH jump setup
│   ├── 07-load-balancer.md          ← ALB + Target Group configuration
│   ├── 08-auto-scaling.md           ← Auto Scaling Group setup
│   └── 09-troubleshooting.md        ← Common issues & fixes (503, SSH, etc.)
│
└── screenshots/                     ← Add your console screenshots here
    └── README.md                    ← Screenshot index
```

---

## ⚙️ Tech Stack

| Component | Service | Config |
|---|---|---|
| Network | AWS VPC | 10.0.0.0/16 |
| Compute | EC2 (Ubuntu 22.04) | t3.micro |
| Load Balancer | Application Load Balancer | Internet-facing, HTTP:80 |
| Scaling | Auto Scaling Group | Min:2 Max:6 |
| Gateway | Internet Gateway | Attached to VPC |
| NAT | NAT Gateway | 1 per AZ |
| Security | Security Groups | HTTP + SSH |
| Access | Bastion Host | SSH jump server |
| Storage | S3 Gateway Endpoint | Private access |
| Region | ap-south-1 | Mumbai |

---

## 🚀 Quick Start

### Prerequisites
- AWS account with IAM permissions
- Key pair (.pem file) created in ap-south-1
- AWS Console access

### Deploy Order
Follow the docs in numbered order:

```bash
# 1. Create VPC
docs/01-vpc-setup.md

# 2. Create Subnets
docs/02-subnets.md

# 3. Internet Gateway
docs/03-internet-gateway.md

# 4. Launch EC2 Instances
docs/04-ec2-instances.md

# 5. Configure Security Groups
docs/05-security-groups.md

# 6. Set up Bastion Host
docs/06-bastion-host.md

# 7. Create Load Balancer
docs/07-load-balancer.md

# 8. Configure Auto Scaling
docs/08-auto-scaling.md
```

### Deploy Website to EC2

SSH into each private EC2 via bastion and run:

```bash
# Install web server
sudo apt update && sudo apt install -y apache2

# Deploy Server 1 (on private EC2 in AZ-A)
sudo cp index.html /var/www/html/index.html
sudo systemctl restart apache2

# Create health check endpoint
echo "OK" | sudo tee /var/www/html/health
```

Or use the bootstrap script:
```bash
bash scripts/install-apache.sh
```

---

## 🔑 Key Concepts Demonstrated

- **VPC Isolation** — Custom network with full control over IP ranges
- **Subnet Segmentation** — Public subnets for ALB/NAT, private subnets for EC2
- **Internet Gateway** — Enables public internet access for public subnets
- **NAT Gateway** — Outbound-only internet for private instances (no inbound)
- **Application Load Balancer** — Distributes HTTP traffic across both AZs
- **Target Groups** — Health-checked pool of EC2 instances
- **Auto Scaling** — Automatically adjusts instance count based on CPU load
- **Bastion Host** — Secure SSH jump server into private subnet
- **Security Groups** — Stateful firewall — EC2 only accepts traffic from ALB
- **S3 Gateway Endpoint** — Private S3 access without internet routing

---

## 🛠️ Troubleshooting

| Problem | Cause | Fix |
|---|---|---|
| 503 Service Unavailable | ALB health check failing | Ensure Apache running + `/health` file exists |
| SSH timeout to private EC2 | No bastion jump | Use `ssh -J` jump syntax |
| Instance unreachable | Security group blocking | Add HTTP:80 inbound from ALB SG |
| NAT not working | NAT in wrong subnet | NAT Gateway must be in PUBLIC subnet |
| Route table not routing | Missing IGW route | Add `0.0.0.0/0 → igw-xxx` to public RT |

See [`docs/09-troubleshooting.md`](docs/09-troubleshooting.md) for full details.

---

## 📸 Screenshots

All console screenshots are in the [`screenshots/`](screenshots/) folder.
See [`screenshots/README.md`](screenshots/README.md) for the full index.

---

## 👤 Author

**Mohan**
AWS Cloud & Networking Enthusiast · ap-south-1
Built May 2026 · Hands-on console project

---

## 📄 License

MIT License — free to use, learn from, and build upon.
