# Stake pool maintenance and operations

## Directory Structure

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
        ├── 01_certs_keys_backup.sh
        ├── 02_rotate_kes.sh
        ├── 03_generate-node-cert.sh
        └── logs.txt
```

## About KES keys

1. KES period basics
- **KES period** - fixed number of blockchain slots (defined by `slotsPerKESPeriod` in genesis).
- **KES key** - can only be used for a limited number of periods (defined by `maxKESIterations` in genesis).
  - Example: maxKESIterations = `62`

2. When a KES key expires
- `startKesPeriod = 1264`
- `maxKESIterations = 62`, the certificate is `valid for 62 KES periods`.
```bash
expireKesPeriod = startKesPeriod + maxKESIterations
expireKesPeriod = 1264 + 62 = 1326
```
- After KES period `1326`, the key cannot sign blocks anymore.

3. When to recreate the certificate
- Best practice: start a new certificate 1 KES period before expiration to ensure smooth rotation.
- Example: Current certificate valid from 1264 → expires at 1326
    - Create the next certificate at KES period 1325

4. How to calculate in slots
- To convert to blockchain slot numbers:
- slotsPerKESPeriod = 129,600
- expireKesPeriod = 1326
```bash
expirationSlot = expireKesPeriod * slotsPerKESPeriod
expirationSlot = 1326 * 129,600 ≈ 171,849,600
```

## Maintenance steps

Goal: Generate `node.cert`.

1. Rotate KES keys (ideally, 1 KES period before expiration to ensure smooth rotation)
2. Create a new node operational certificate
3. Restart block producing node with this certificate

Create the following scripts at `/home/ubuntu/mainnet/scripts/stake-pool`:
- [01_certs_keys_backup.sh] (../scripts/01_certs_keys_backup.sh)
    - Backs up certificates and keys that will be replaced 
- [02_rotate_kes.sh] (../scripts/02_rotate_kes.sh)
    - Replaces KES keys

The following script should already be created:
- [03_generate-node-cert.sh] (../scripts/03_generate-node-cert.sh)
    - Creates new operational certificate for the node

Run the following scripts:
```bash
$ cd /home/ubuntu/mainnet/scripts/stake-pool
$ ./01_certs_keys_backup.sh
$ ./02_rotate_kes.sh
$ ./03_generate-node-cert.sh
```

Copy the newly generated operational certificate to the right directory,
```bash
$ cp /home/ubuntu/mainnet/scripts/stake-pool/output/node.cert /home/ubuntu/mainnet/certs-stake-pool/node.cert
```

Restart node,
```bash
sudo systemctl restart block-node-mainnet
```
