# Connect Relay node to Block node

## 1. Relay topology.json

If block node is ready, go to your relay topology file and add its IP address and port number to "localRoots".

```bash
$ vi /opt/cardano/mainnet/config/topology.json
{
  "bootstrapPeers": [
    {
      "address": "backbone.cardano.iog.io",
      "port": 3001
    },
    {
      "address": "backbone.mainnet.cardanofoundation.org",
      "port": 3001
    },
    {
      "address": "backbone.mainnet.emurgornd.com",
      "port": 3001
    }
  ],
  "localRoots": [
    {
      "accessPoints": [
        {
          "address": "corenode.adasurge.com",
          "port": 3002
        }
      ],
      "advertise": false,
      "trustable": true,
      "valency": 1
    }
  ],
  "publicRoots": [
    {
      "accessPoints": [],
      "advertise": false
    }
  ],
  "useLedgerAfterSlot": 148350000
...
```
- `useLedgerAfterSlot` - indicates after which slot peers should be fetched from the ledger. A negative value will disable fetching peers from the ledger, and you will need to manually add peers to the topology file.
- `valency` - is the number of connections that your node should establish towards a specific group. If you have one IP in `localRoots`, then it should be 1; if you have one DNS name with two IPs behind it, then it should be 2; or if you have two IPs/DNS names with single IP behind each, then it should also be 2, and so on.
- `localRoots` - are for peers which the node should always have as hot connections, such as your BP or your other relays.
- `publicRoots` - represent a source of fallback peers, a source of peers to be used if peers from the ledger (`useLedgerAfterSlot`) are disabled or unavailable.

### 1.1. Purpose of publicRoots

-`publicRoots` is an optional configuration section for peer discovery.
- In a modern P2P-enabled Cardano node setup, you do not need to manually specify publicRoots.

#### 1.1.1. P2P replaces the old manual topology
Before P2P, you had to manually manage `topology.json` for every relay and specify:
- Other relays’ addresses (publicRoots)
- Your block producer (localRoots)

Now, with P2P networking enabled:
- Your node automatically discovers peers from the ledger and gossip network.
- It connects to trusted bootstrap peers (IOG relays) first, then learns new ones dynamically.

#### 1.1.2. Is P2P enabled?

Check for `"EnableP2P": true` on block producing node,
```bash
$ vi /opt/cardano/mainnet/config/config.json
...
"EnableP2P": true,
...
```

In modern Cardano node setups (using P2P topology), there are three connection sources:
1. bootstrapPeers — hardcoded trusted IOHK backbone relays (used at startup until other peers are discovered).
2. localRoots — peers that are part of your own topology (e.g., your relays connecting to your core).
3. publicRoots — optional list of publicly reachable nodes to help with peer discovery.

You can safely leave `publicRoots` empty (as in your example).

```bash
  "publicRoots": [
    {
      "accessPoints": [],
      "advertise": false
    }
  ],
```
- ✅ `accessPoints: []` → No manual public peers defined (fine for P2P).
- ✅ `advertise: false` → Your node won’t announce itself to the network (standard for relays behind firewalls or private setups).
- ✅ P2P logic still handles connections using bootstrapPeers + the network’s peer gossip mechanism.

Your node will still:
- Bootstrap via IOG relays (Input Output Global) (bootstrapPeers)
- Connect to your own core node (localRoots)
- Operate perfectly normally.

### 1.2. localRoots

```bash
"localRoots": [
    {
      "accessPoints": [
        {
          "address": "corenode.adasurge.com",
          "port": 3002
        }
      ],
      "advertise": false,
      "trustable": true,
      "valency": 1
    }
  ],
```
This ensures
- Your relay connects to your core (block producer).
- The core stays private (not publicly discoverable).

## 2. Restart relay node server

```bash
sudo systemctl restart relay-node-mainnet
```

## 3. Check logs

```bash
$ sudo journalctl -f -u relay-node-mainnet.service
```

```log
TraceLocalRootResult (DomainAccessPoint {dapDomain = "corenode.adasurge.com", dapPortNumber = 3002}) [(48.186.219.111,1800)]
TraceLocalRootGroups [(HotValency {getHotValency = 1},WarmValency {getWarmValency = 1},fromList [(48.186.219.111:3002,...)]
TraceLocalRootPeersChanged ... [(48.186.219.111:3002,...)]
```

Log shows:
- DNS corenode.adasurge.com was resolved to your public IP 48.186.219.111
- The relay established a warm connection (handshake complete)
- Diffusion mode InitiatorAndResponderDiffusionMode is correct (relay ↔ core both directions)
- No connection errors, meaning the core node’s port 3002 is reachable and open.

Relay node has successfully connected to your block-producing node.

### 3.1. Verify connectivity on block node

```bash
ss -tuna | grep <relay_ip>:<relay_port>
```
if you `ESTAB` connectivity to relay's IP and port then connection is good.

### 3.2. Verify connectivity on relay node

To confirm it’s active (not just warm):

```bash
ss -tuna | grep <block_ip>:<block_port>
```
if you `ESTAB` connectivity to block's IP and port then connection is good.

### 3.3. Verify connectivity to other peers

On relay node,
```bash
ss -tuna | grep <relay_ip>:<relay_port>
```

On block node,
```bash
ss -tuna | grep <block_ip>:<block_port>
```

There should be a lot of `ESTAB` connections to your node.