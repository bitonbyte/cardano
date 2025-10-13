#!/bin/bash
# Backup KES vkey and skey, cold.counter, node.cert

# -----------------------------
# Setup logging
# -----------------------------
LOG_FILE="/home/ubuntu/mainnet/scripts/stake-pool/log.txt"
echo "Log file: ${LOG_FILE}"

# Redirect all stdout and stderr to log file and terminal
exec > >(tee -a "$LOG_FILE") 2>&1

echo "===== $(date +'%Y-%m-%d %H:%M:%S') Starting $(basename "$0") ====="

# -----------------------------
# Variables
# -----------------------------

KEYS_ARCHIVE_DIR="/home/ubuntu/mainnet/keys-stake-pool/archive"
CERTS_ARCHIVE_DIR="/home/ubuntu/mainnet/certs-stake-pool/archive"

KES_VKEY_FILE="/home/ubuntu/mainnet/keys-stake-pool/kes.vkey"
KES_SKEY_FILE="/home/ubuntu/mainnet/keys-stake-pool/kes.skey"
COLD_COUNTER_FILE="/home/ubuntu/mainnet/keys-stake-pool/cold.counter"

NODE_CERT_FILE="/home/ubuntu/mainnet/certs-stake-pool/node.cert"

# Create both archive directories if they don't exist
mkdir -p "$KEYS_ARCHIVE_DIR"
mkdir -p "$CERTS_ARCHIVE_DIR"

# Create date folders in both archive dirs
TODAY_DIR=$(date +"%Y%m%d")
KEYS_DEST_DIR="$KEYS_ARCHIVE_DIR/$TODAY_DIR"
CERTS_DEST_DIR="$CERTS_ARCHIVE_DIR/$TODAY_DIR"

mkdir -p "$KEYS_DEST_DIR"
mkdir -p "$CERTS_DEST_DIR"

# Get current time
CURRENT_TIME=$(date +"%H%M%S")

# Copy key files with time suffix to keys archive dir
cp "$KES_VKEY_FILE" "$KEYS_DEST_DIR/kes.vkey.$CURRENT_TIME"
cp "$KES_SKEY_FILE" "$KEYS_DEST_DIR/kes.skey.$CURRENT_TIME"
cp "$COLD_COUNTER_FILE" "$KEYS_DEST_DIR/cold.counter.$CURRENT_TIME"

# Copy node.cert with time suffix to certs archive dir
cp "$NODE_CERT_FILE" "$CERTS_DEST_DIR/node.cert.$CURRENT_TIME"

echo "✅ Keys archived to: $KEYS_DEST_DIR"
echo "✅ Node certificate archived to: $CERTS_DEST_DIR"