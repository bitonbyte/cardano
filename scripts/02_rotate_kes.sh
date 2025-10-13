#!/bin/bash
# Rotate KES vkey and skey

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
KES_DIR="/home/ubuntu/mainnet/keys-stake-pool"
KES_VKEY_FILE="$KES_DIR/kes.vkey"
KES_SKEY_FILE="$KES_DIR/kes.skey"

# Rotate KES keys
cardano-cli node key-gen-KES \
    --verification-key-file "$KES_VKEY_FILE" \
    --signing-key-file "$KES_SKEY_FILE"

# Check if generation succeeded
if [ $? -eq 0 ]; then
    echo "✅ KES keys rotated successfully."
else
    echo "❌ Failed to rotate KES keys."
    exit 1
fi