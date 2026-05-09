# 09 · Troubleshooting Guide

Real issues encountered during this project and how they were fixed.

---

## ❌ 503 Service Temporarily Unavailable

**Symptom:** ALB DNS returns 503 in browser.

**Cause:** ALB has no healthy targets in the target group.

**Fix — Step by step:**

```bash
# 1. SSH into private EC2 via bastion
ssh -i private.pem -J ubuntu@13.206.97.41 ubuntu@10.0.2.146

# 2. Install and start Apache
sudo apt update -y && sudo apt install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2

# 3. Create health check file (CRITICAL)
echo "OK" | sudo tee /var/www/html/health
echo "<h1>OK</h1>" | sudo tee /var/www/html/index.html

# 4. Verify Apache is running
curl localhost
```

Then in AWS Console:
- **EC2 → Target Groups → ALB → Targets**
- Wait 30–60 seconds for health check to pass
- Status should change to **Healthy** ✅

---

## ❌ SSH: Connection Timed Out (to private EC2)

**Symptom:** `ssh ubuntu@10.0.2.146` hangs or times out.

**Cause:** Private EC2 has no public IP — you can't reach it directly.

**Fix:** Always use the bastion jump:
```bash
ssh -i private.pem -J ubuntu@<BASTION_PUBLIC_IP> ubuntu@<PRIVATE_IP>
```

---

## ❌ WARNING: UNPROTECTED PRIVATE KEY FILE

**Symptom:** SSH gives permission warning, refuses to connect.

**Fix:**
```bash
chmod 400 private.pem
```

---

## ❌ Instances showing "Unhealthy" in Target Group

**Causes and fixes:**

| Cause | Fix |
|---|---|
| Apache not running | `sudo systemctl start apache2` |
| Health check path missing | `echo "OK" > /var/www/html/health` (or change path to `/`) |
| Security group blocking port 80 | Add HTTP:80 inbound from ALB SG |
| Wrong health check port | Set to `traffic-port` in target group settings |

---

## ❌ NAT Gateway Not Working (Private EC2 can't reach internet)

**Cause:** NAT Gateway placed in private subnet instead of public.

**Fix:** 
- Delete NAT Gateway
- Recreate it in the **PUBLIC subnet** with an Elastic IP
- Update private route table: `0.0.0.0/0 → nat-gw-id`

---

## ❌ Route Table Not Routing Internet Traffic

**Symptom:** Public EC2 has public IP but can't reach the internet.

**Fix:**
- VPC → Route Tables → select your public route table
- Routes → Edit routes → Add route:
  - Destination: `0.0.0.0/0`
  - Target: Internet Gateway → `igw-xxx`
- Save changes
- Check subnet associations — public subnets must be associated with this route table

---

## ❌ ALB Shows "Provisioning" for Too Long

**Cause:** Subnets selected may be private instead of public.

**Fix:**
- Edit ALB → Network mapping
- Ensure only **public subnets** are selected for each AZ

---

## ✅ Health Check Reference

| Endpoint | Expected Response | Used for |
|---|---|---|
| `/health` | `200 OK` with body "OK" | ALB health check |
| `/index.html` | `200 OK` with HTML | ALB health check (alternate) |
| `/` | `200 OK` | General availability |

---

## 💡 Quick Debug Checklist

```
□ Is Apache running? → systemctl status apache2
□ Does /health file exist? → ls /var/www/html/
□ Does security group allow port 80 from ALB? → check inbound rules
□ Is instance registered in target group? → EC2 → Target Groups → Targets
□ Is target group attached to ALB listener? → EC2 → Load Balancers → Listeners
□ Is ALB in PUBLIC subnets? → EC2 → Load Balancers → Network mapping
□ Is NAT Gateway in PUBLIC subnet? → VPC → NAT Gateways
□ Does private route table route to NAT GW? → VPC → Route Tables
```
