#!/bin/bash
# install-apache.sh
# Bootstrap script — run on private EC2 after SSH via bastion
# Usage: bash scripts/install-apache.sh [server_number]
# Example: bash scripts/install-apache.sh 1

SERVER_NUM=${1:-1}

echo "======================================"
echo " AWS VPC Project — Server $SERVER_NUM Setup"
echo "======================================"

# Update system
echo "[1/5] Updating system..."
sudo apt update -y && sudo apt upgrade -y

# Install Apache
echo "[2/5] Installing Apache..."
sudo apt install -y apache2

# Start and enable Apache
echo "[3/5] Starting Apache..."
sudo systemctl start apache2
sudo systemctl enable apache2

# Create health check endpoint
echo "[4/5] Creating health check file..."
echo "OK" | sudo tee /var/www/html/health

# Deploy website
echo "[5/5] Deploying website..."
if [ "$SERVER_NUM" = "1" ]; then
  sudo cp /home/ubuntu/index.html /var/www/html/index.html 2>/dev/null || \
  echo "<h1>Server 1 — AZ-A | $(hostname -f)</h1><p>Served via AWS ALB</p>" | sudo tee /var/www/html/index.html
else
  sudo cp /home/ubuntu/server2.html /var/www/html/index.html 2>/dev/null || \
  echo "<h1>Server 2 — AZ-B | $(hostname -f)</h1><p>Served via AWS ALB</p>" | sudo tee /var/www/html/index.html
fi

# Restart Apache
sudo systemctl restart apache2

# Verify
echo ""
echo "======================================"
echo " Setup complete! Verifying..."
echo "======================================"
sudo systemctl status apache2 --no-pager | grep "Active:"
echo ""
echo "Health check: $(curl -s localhost/health)"
echo "Web server:   $(curl -s localhost | head -1)"
echo ""
echo "✅ Server $SERVER_NUM is ready for the ALB target group!"
