# Service daemon for Relay node

Configure the node to act as a `relay node`. It is easier to maintain the node if a service is created that starts automatically on boot.

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
    ├── relay-node-mainnet.sh
    └── relay-node.env
```

```text
/etc/systemd/system
└── relay-node-mainnet.service
```
## Port
Cardano relay node port,    
`Port:3001`

## Shell executable script

Add `scripts`

```bash
mkdir /opt/cardano/mainnet/scripts
cd /opt/cardano/mainnet/scripts
vi relay-node-mainnet.sh
```

Add the following to `relay-node-mainnet.sh`,
```bash
#!/bin/bash
echo "Environment: $CARDANO_NODE_SOCKET_PATH"

cardano-node run \
  --topology /opt/cardano/mainnet/config/topology.json \
  --database-path /opt/cardano/mainnet/db \
  --socket-path /opt/cardano/mainnet/db/node.socket \
  --host-addr 0.0.0.0 \
  --port 3001 \
  --config /opt/cardano/mainnet/config/config.json
```

Change permissions,
```bash
chmod 755 relay-node-mainnet.sh
```

## Environment file

```bash
vi /opt/cardano/mainnet/scripts/relay-node.env
CARDANO_NODE_SOCKET_PATH=/opt/cardano/mainnet/db/node.socket
PATH=/home/ubuntu/.local/bin
```

## Create service 

```bash
vi relay-node-mainnet.service
[Unit]
Description       = Cardano Relay Mainnet Service
Wants             = network-online.target
After             = network-online.target

[Service]
User              = ubuntu
Group             = ubuntu
Type              = simple
WorkingDirectory  = /opt/cardano/mainnet
EnvironmentFile   = /opt/cardano/mainnet/scripts/relay-node.env
ExecStart         = /bin/bash -c '/opt/cardano/mainnet/scripts/relay-node-mainnet.sh'
ExecReload        = pkill -HUP cardano-node
KillSignal        = SIGINT
RestartKillSignal = SIGINT
TimeoutStopSec    = 300
LimitNOFILE       = 32768
Restart           = always
RestartSec        = 5
SyslogIdentifier  = relay-node-mainnet

[Install]
WantedBy          = multi-user.target
```

```bash
chmod 644 relay-node-mainnet.service 
sudo mv relay-node-mainnet.service /etc/systemd/system
```

Reload systemd unit files after making any changes,
```bash
sudo systemctl daemon-reload
```

## Start, Stop, Restart

You can now start, stop, restart and check status of the service,
```bash
sudo systemctl start relay-node-mainnet
sudo systemctl stop relay-node-mainnet
sudo systemctl restart relay-node-mainnet
```

Check status of service, 'status' provides a detailed response,
```bash
systemctl status relay-node-mainnet
systemctl is-active relay-node-mainnet
active
```

## LOGS

### Filter by systemd unit

Show logs from relay-node-mainnet.service unit:

Real time log streaming,
```bash
sudo journalctl -f -u relay-node-mainnet.service
```

Basic Log View,
```bash
sudo journalctl -u relay-node-mainnet.service
```

Logs from current boot,
```bash
sudo journalctl -u relay-node-mainnet.service -b
```

### Filter by SysLogIdentifier

To filter by `SyslogIdentifier  = relay-node-mainnet` value in service file,
```bash
sudo journalctl -t relay-node-mainnet
```

### (OPTIONAL) For File based log

You can modify your service file to include:
```bash
StandardOutput=append:/var/log/relay-node-mainnet.log
StandardError=append:/var/log/relay-node-mainnet-error.log
```

Then reload the service,
```bash
sudo systemctl daemon-reload
sudo systemctl restart relay-node-mainnet
```

## Start on boot

Enable daemon service unit to start on boot.
```bash
sudo systemctl enable relay-node-mainnet
Created symlink /etc/systemd/system/multi-user.target.wants/relay-node-mainnet.service → /etc/systemd/system/relay-node-mainnet.service.
```

Disable daemon service unit to start on boot.
```bash
sudo systemctl disable relay-node-mainnet
```

Checking if daemon service unit is enabled on boot,
```bash
systemctl is-enabled relay-node-mainnet
enabled
```
