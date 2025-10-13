# Run Node

cardano-node must be configured first and then it can either be a `relay node` or a `block producing node`. Before assigning a node to act as a `relay` or as a `

## Configuration Files

The `cardano-node` application requires several mandatory configuration files to operate:

1. **Main Config**  
   General node settings such as `logging` and `versioning`. It also references the Genesis files below.
2. **Genesis Files**  
   Define the initial structure and protocol parameters for each Cardano Ledger era:
    - `Byron Genesis`
    - `Shelley Genesis`
    - `Alonzo Genesis`
    - `Conway Genesis`
3. **Topology**  
   Sets default network peers and supports dynamic peer discovery via Cardano's peer-to-peer (P2P) networking.
4. **Checkpoints**
   Helps node synchronize more efficiently with the blockchain by providing a list of known good block checkpoints.

## Environments

There are three environments and config files can be found in their respective links
1. Testnet / Preview [https://book.play.dev.cardano.org/environments/preview]
2. Testnet / Preprod [https://book.play.dev.cardano.org/environments/preprod]
3. Mainnet / Production [https://book.play.dev.cardano.org/environments/mainnet]

## Directory Structure

Standard practice for manual software installs goes to `/opt` directory

```text
/opt/cardano/mainnet/
├── db
├── config
    ├── alonzo-genesis.json
    ├── byron-genesis.json
    ├── config.json
    ├── checkpoints.json
    |── shelley-genesis.json
    └── topology.json
```

## /opt directory permission

```bash
sudo mkdir /opt/cardano
sudo chown -R ubuntu:ubuntu /opt/cardano
```

## Download configuration files

```bash
mkdir -p /opt/cardano/mainnet/config
cd /opt/cardano/mainnet/config
curl -O -J "https://book.play.dev.cardano.org/environments/mainnet/{config,topology,byron-genesis,shelley-genesis,alonzo-genesis,conway-genesis,checkpoints}.json"
```

OPTIONAL: More config files are also available to download
> curl -O -J "https://book.play.dev.cardano.org/environments/mainnet/{config,db-sync-config,submit-api-config,topology,byron-genesis,shelley-genesis,alonzo-genesis,conway-genesis,checkpoints}.json"

## Database

Create a database directory,
```bash
mkdir -p /opt/cardano/mainnet/db
```

## Run the node

```bash
cardano-node run \
  --topology /opt/cardano/mainnet/config/topology.json \
  --database-path /opt/cardano/mainnet/db \
  --socket-path /opt/cardano/mainnet/db/node.socket \
  --host-addr 0.0.0.0 \
  --port 3001 \
  --config /opt/cardano/mainnet/config/config.json
```

## Monitor Sync Progress

Add `node.socket` file to `PATH`
```bash
vi ~/.bashrc
# Socket file used by cardano-cli to communicate with running cardano-node
export CARDANO_NODE_SOCKET_PATH=/opt/cardano/mainnet/db/node.socket
```

Reload `.bashrc`,
```bash
source ~/.bashrc
echo $CARDANO_NODE_SOCKET_PATH
```

```bash
$ cardano-cli query tip --mainnet
{
    "block": 154833,
    "epoch": 7,
    "era": "Byron",
    "hash": "52aae213b9074d32e67cdd6c1325394e57acd4f03217336d9575673f9dc91b75",
    "slot": 154864,
    "slotInEpoch": 3664,
    "slotsToEpochEnd": 17936,
    "syncProgress": "1.26"
}
```
`syncProgress:1.26` is the percentage your node that has been synced. 100 meaning it is fully synced.