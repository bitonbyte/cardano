#!/bin/bash
# Generate operational certificate, node.cert

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
KES_VKEY_FILE="/home/ubuntu/mainnet/keys-stake-pool/kes.vkey"
KES_SKEY_FILE="/home/ubuntu/mainnet/keys-stake-pool/kes.skey"
COLD_SKEY_FILE="/home/ubuntu/mainnet/keys-stake-pool/cold.skey"
COLD_COUNTER_FILE="/home/ubuntu/mainnet/keys-stake-pool/cold.counter"
NODE_CERT_EXISTING_FILE="/home/ubuntu/mainnet/certs-stake-pool/node.cert"
NODE_CERT="/home/ubuntu/mainnet/scripts/stake-pool/output/node.cert"
GENESIS_FILE="/opt/cardano/mainnet/config/shelley-genesis.json"

echo "Using Genesis File: ${GENESIS_FILE}"

# -----------------------------
# Calculate KES period
# -----------------------------

# Max KES evolutions for mainnet
MAX_KES_EVOLUTIONS=$(jq -r '.maxKESEvolutions' "$GENESIS_FILE")
echo "MaxKESEvolutions: $MAX_KES_EVOLUTIONS"
# MAX_KES_EVOLUTIONS=62

# Get current slot
currentSlot=$(cardano-cli query tip --mainnet | jq -r '.slot')
echo "currentSlot: $currentSlot"

# Get slots per KES period
slotsPerKESPeriod=$(jq -r '.slotsPerKESPeriod' $GENESIS_FILE)
echo "slotsPerKESPeriod: $slotsPerKESPeriod"

# Compute current KES period
currentKESPeriod=$(( currentSlot / slotsPerKESPeriod ))
echo "currentKESPeriod: $currentKESPeriod"

# End KES Period
endSlot=$((currentSlot + (slotsPerKESPeriod *  MAX_KES_EVOLUTIONS)))
echo "endSlot: ${endSlot}"
endKesPeriod=$((currentKESPeriod + MAX_KES_EVOLUTIONS))
echo "endKesPeriod: ${endKesPeriod}"

# Set startKesPeriod to the current KES period
startKesPeriod=${currentKESPeriod}
echo "startKesPeriod: ${startKesPeriod}"

# -----------------------------
# Issue operational certificate
# -----------------------------
# Create New node.cert with new issue number (from cold.counter) for the new KES period

echo "Issuing operational certificate..."
cardano-cli node issue-op-cert \
    --kes-verification-key-file "$KES_VKEY_FILE" \
    --cold-signing-key-file "$COLD_SKEY_FILE" \
    --operational-certificate-issue-counter "$COLD_COUNTER_FILE" \
    --kes-period "$startKesPeriod" \
    --out-file "$NODE_CERT"

# -----------------------------
# cold.counter
# -----------------------------
# Each time you run 'issue-op-cert', cold.counter file increments counter automatically
# Do not manually change it.
echo "Counter incremented in ${COLD_COUNTER_FILE}"

if [ $? -eq 0 ]; then
    echo "✅ Operational certificate generated: $NODE_CERT"
else
    echo "❌ Failed to generate operational certificate."
fi

echo "***** NOTE *****"
echo "1. You need to rotate KES keys after slot: ${endSlot}"
echo "2. The corresponding KesPeriod is: ${endKesPeriod}"
echo "3. Counter incremented in ${COLD_COUNTER_FILE}"
echo "***** ACTION ITEM(S) *****"
echo "1. Replace $NODE_CERT_EXISTING_FILE with $NODE_CERT and restart server"