# Generate all stake pool specific keys and certificates

## Directory Structure (Block producing node)

```text
$HOME/mainnet
├── keys-stake-pool
    ├── cold.skey
    ├── cold.vkey
    ├── cold.counter
    ├── kes.skey
    ├── kes.vkey
    ├── vrf.skey
    └── vrf.vkey
├── certs-stake-pool
    └── node.cert
├── scripts
    └── stake-pool
        ├── 03_generate-node-cert.sh
        └── logs.txt
```

To run a stake pool, three key pairs are needed:
- Cold keys
- KES keys
- VRF keys

## Generate Cold keys

`cold.vkey`, `cold.skey` & `cold.counter`

```bash
cardano-cli node key-gen \
    --cold-verification-key-file cold.vkey \
    --cold-signing-key-file cold.skey \
    --operational-certificate-issue-counter cold.counter
```

## Generate KES keys

`kes.vkey` & `kes.skey`

```bash
cardano-cli node key-gen-KES \
    --verification-key-file kes.vkey \
    --signing-key-file kes.skey
```

## Generate VRF keys

`vrf.vkey` & `vrf.skey`

Generate and update vrf key permissions to read-only.
```bash
cardano-cli node key-gen-VRF \
    --verification-key-file vrf.vkey \
    --signing-key-file vrf.skey

chmod 400 vrf.skey
```

## Stake pool operations certificate

Goal: Generate `node.cert`.

Create the following script at `/home/ubuntu/mainnet/scripts/stake-pool`:
- `03_generate-node-cert.sh` (../scripts/03_generate-node-cert.sh)
    - Script creates new node operational certificate

Run the following script:
```bash
$ cd /home/ubuntu/mainnet/scripts/stake-pool
$ ./03_generate-node-cert.sh
```

Copy the newly generated operational certificate to the right directory,
```bash
$ cp /home/ubuntu/mainnet/scripts/stake-pool/output/node.cert /home/ubuntu/mainnet/certs-stake-pool/node.cert
```
