# 🔑 Cardano Key Pairs

Cryptographic keys used by Cardano are based on the `ed25519` key pair scheme.

- **Verification key (`*.vkey`)** – public
- **Secret key (`*.skey`)** – private and sensitive

---

## 💼 Wallet Address Key Pairs

1. Payment
- `payment.vkey`
  - Public key for payment address
  - Not sensitive; may be shared
- `payment.skey`
  - Private signing key
  - Grants access to funds at the payment address
  - ❗ Store offline or secure machine for long-term safety
- `payment.addr`
  - Wallet’s payment address
  - Derived from `payment.vkey` + `stake.vkey`

2. Stake
- `stake.vkey`
  - Public key for stake address
  - Not sensitive; may be shared
- `stake.skey`
  - Private stake signing key
  - Grants access to any awards cash held in the stake address
  - Enables delegating the wallet to a stake pool
  - ❗ Store offline or secure machine for long-term safety
- `stake.addr`
  - Wallet’s stake address
  - Derived from `stake.vkey`

---

## 🧊 Stake Pool Cold Keys

- `cold.vkey`
  - Public key for `cold.skey`
  - Not sensitive; may be shared

- `cold.skey`
  - Extremely sensitive private key for the stake pool
  - Required for:
    - Stake pool registration
    - Updating registration parameters
    - KES key rotation
    - Pool retirement
  - ❗ Store offline, e.g., on an air-gapped machine or a USB drive.

- `cold.counter`
  - Incrementing counter file that tracks the number of times operational 
    certificates (`opcert`) are generated for the relevant stake pool.
  - Always rotate KES keys with the latest `cold.counter`

---

## 🎲 VRF Hot Keys

- `vrf.vkey`
  - Public VRF verification key
  - Not sensitive and not required for block production

- `vrf.skey`
  - Private VRF key
  - Required on a hot node for block-producing functionality
  - ⚠️ Sensitive but must be present on block producer

---

## 🔐 KES Hot Keys

- `kes.vkey`
  - Public KES verification key
  - Not sensitive; not needed on producer

- `kes.skey`
  - Private KES signing key
  - Needed to start the stake pool’s block producer
  - Must be rotated regularly
  - ⚠️ Sensitive but must be present on block producer

--- 

## ⏳ Operational Certificate

- `node.cert`
  - KES keys are needed to establish a stake pool's `operating certificate`, 
  - KES keys are valid for around 90 days
  - Rotate KES keys and create a new operational certificate every 90 days (or sooner) for a stake pool to continue minting blocks

