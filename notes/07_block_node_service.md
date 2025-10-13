# Service daemon for Block Producing node

Configure the node to act as a `block producing node`. It is easier to maintain the node if a service is created that starts automatically on boot.

## Configuration Steps

Follow the steps used to configure `relay node`. Replace `relay` with `block` on all files.

## Directory Structure

```text
/opt/cardano/mainnet/
├── db
├── config
    ├── alonzo-genesis.json
    ├── byron-genesis.json
    ├── config.json
    ├── checkpoints.json
    ├── shelley-genesis.json
    └── topology.json
├── scripts
    ├── block-node-mainnet.sh
    └── block-node.env
```

```text
/etc/systemd/system
└── block-node-mainnet.service
```

## Port
Cardano block node port,    
`Port:3002`


