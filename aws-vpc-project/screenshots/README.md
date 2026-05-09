# 📸 Screenshots Index

Add your AWS Console screenshots to this folder. Below is the recommended naming and order.

## Upload Order for LinkedIn

| # | Filename | What it shows |
|---|---|---|
| 01 | `01-create-vpc.png` | Create VPC wizard — VPC only, 10.0.0.0/16 |
| 02 | `02-vpc-named.png` | VPC named my-vpc01 |
| 03 | `03-public-subnet.png` | Subnet 1 — Public, ap-south-1a, 10.0.0.0/24 |
| 04 | `04-private-subnet.png` | Subnet 2 — Private, ap-south-1b, 10.0.2.0/24 |
| 05 | `05-internet-gateway.png` | IGW attached to my-vpc01 ✅ |
| 06 | `06-route-table-create.png` | Create route table for my-vpc01 |
| 07 | `07-route-table-igw.png` | Edit routes — 0.0.0.0/0 → IGW |
| 08 | `08-ec2-public-launch.png` | Launch public EC2 — public subnet |
| 09 | `09-ec2-private-launch.png` | Launch private EC2 — private subnet |
| 10 | `10-public-ec2-summary.png` | Public EC2 — IP 13.206.97.41, Running ✅ |
| 11 | `11-private-ec2-summary.png` | Private EC2 — no public IP, 10.0.2.146 ✅ |
| 12 | `12-bastion-ssh-jump.png` | Terminal: SSH jump via bastion → 10.0.2.146 ✅ |
| 13 | `13-security-group.png` | Security group mySG — HTTP + SSH rules |
| 14 | `14-target-group.png` | Target group ALB — HTTP:80, /index.html |
| 15 | `15-alb-active.png` | FirstALB — Status: Active ✅, DNS name live |

## Demo Videos

| File | Content |
|---|---|
| `demo-alb-loadbalancing.mp4` | ALB switching between Server 1 and Server 2 |
| `demo-vpc-walkthrough.mp4` | Full console walkthrough of the architecture |

---

> Rename your screenshot files to match the names above before committing, so they display in order on GitHub.
