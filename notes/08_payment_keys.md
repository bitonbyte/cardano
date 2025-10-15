# Generate all keys

## Directory Structure (Block node)

```text
$HOME/mainnet
├── keys-payment
    ├── payment.skey
    ├── payment.vkey
    ├── payment.addr
    ├── stake.skey
    ├── stake.vkey
    └── stake.addr
```

## Generate Payment Keys

`payment.skey` & `payment.vkey`

```bash
cardano-cli address key-gen \
    --verification-key-file payment.vkey \
    --signing-key-file payment.skey
```

## Generate Stake Keys and Stake address

`stake.skey` & `stake.vkey`
`stake.vkey` is used to generate `stake.addr`

```bash
cardano-cli stake-address key-gen \
    --verification-key-file stake.vkey \
    --signing-key-file stake.skey

cardano-cli stake-address build \
    --stake-verification-key-file stake.vkey \
    --out-file stake.addr \
    --mainnet
```

## Generate Wallet Keys

`payment.vkey` is used to generate `payment.addr`

```bash
cardano-cli address build \
    --payment-verification-key-file payment.vkey \
    --out-file payment.addr \
    --mainnet
```

- The `payment key` part lets you spend funds.
- The `stake key` part ties the address to a staking account, so the funds can earn rewards.
    - If you only had payment.vkey, the wallet could send/receive ADA, but wouldn’t earn staking rewards.
    - By linking to stake.vkey, the wallet also participates in delegation (staking).