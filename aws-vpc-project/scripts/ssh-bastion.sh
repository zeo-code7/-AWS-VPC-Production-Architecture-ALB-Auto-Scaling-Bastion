#!/bin/bash
# ssh-bastion.sh
# Helper script to SSH into private EC2 via bastion host
# Usage: bash scripts/ssh-bastion.sh [server_ip]

# ── CONFIG — update these values ──────────────────────────
KEY_FILE="private.pem"                          # Path to your .pem key
BASTION_IP="13.206.97.41"                       # Public EC2 (bastion) IP
PRIVATE_IP_1="10.0.2.146"                       # Private EC2 Server 1
PRIVATE_IP_2="10.0.3.x"                         # Private EC2 Server 2
SSH_USER="ubuntu"                               # Default user for Ubuntu AMI
# ──────────────────────────────────────────────────────────

TARGET=${1:-$PRIVATE_IP_1}

echo "======================================"
echo " Bastion SSH Jump"
echo "======================================"
echo " Key:     $KEY_FILE"
echo " Bastion: $BASTION_IP"
echo " Target:  $TARGET"
echo "======================================"
echo ""

# Check key file exists
if [ ! -f "$KEY_FILE" ]; then
  echo "❌ Key file not found: $KEY_FILE"
  echo "   Place your .pem file in the current directory."
  exit 1
fi

# Fix permissions
chmod 400 "$KEY_FILE"

echo "🔐 Jumping via bastion → connecting to $TARGET..."
echo ""

ssh -i "$KEY_FILE" \
    -J "$SSH_USER@$BASTION_IP" \
    "$SSH_USER@$TARGET" \
    -o StrictHostKeyChecking=no \
    -o ServerAliveInterval=60

echo ""
echo "Session ended."
