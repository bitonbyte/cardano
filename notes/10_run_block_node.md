# Run "block" node as an actual block node

So far the block node is only acting as a relay node. Let's make it an actual block node. 

Once you have created the operational certificate `node.cert`, add the following to `cardano-node` script,
- --shelley-kes-key
- --shelley-vrf-key
- --shelley-operational-certificate


```bash
$ vi /opt/cardano/mainnet/scripts/lock-node-mainnet.sh
...
cardano-node run \
  --topology /opt/cardano/mainnet/config/topology.json \
  --database-path /opt/cardano/mainnet/db \
  --socket-path /opt/cardano/mainnet/db/node.socket \
  --host-addr 0.0.0.0 \
  --port 3002 \
  --config /opt/cardano/mainnet/config/config.json \
  --shelley-kes-key /home/ubuntu/mainnet/keys-stake-pool/kes.skey \
  --shelley-vrf-key /home/ubuntu/mainnet/keys-stake-pool/vrf.skey \
  --shelley-operational-certificate /home/ubuntu/mainnet/certs-stake-pool/node.cert
```

Restart the service,
```bash
sudo systemctl restart block-node-mainnet
```

## Logs

```log
Oct 05 04:51:44 oberon block-node-mainnet[216114]: [oberon:cardano.node.LeadershipCheck:Info:107] [2025-10-05 04:51:44.00 UTC] {"chainDensity":4.8736993e-2,"credentials":"Cardano","delegMapSize":1343727,"kind":"TraceStartLeadershipCheck","slot":168073613,"utxoSize":0} Oct 05 04:51:44 oberon block-node-mainnet[216114]: [oberon:cardano.node.Forge:Info:107] [2025-10-05 04:51:44.05 UTC] fromList [("credentials",String "Cardano"),("val",Object (fromList [("kind",String "TraceNodeNotLeader"),("slot",Number 1.68073613e8)]))] Oct 05 04:51:44 oberon block-node-mainnet[216114]: [oberon:cardano.node.ChainDB:Notice:90] [2025-10-05 04:51:44.67 UTC] Chain extended, new tip: fb9cd0fde0d9a7ff558af5ab9c6a5b87c6408174bbd1c273f57761318f08d36c at slot 168073613
```

You will notice the following log entries for a true `core node` (block node)
1. `TraceNodeNotLeader` entries
- This is expected most of the time. A block producer checks every slot to see whether it is the slot leader (the node responsible for producing a block). Most slots are not yours — so the logs will repeatedly show "TraceNodeNotLeader" for every slot checked.
2. `TraceStartLeadershipCheck` entries
- This is the node beginning the leadership check for a given slot. This happens every slot interval (every ~1 second for Cardano), so seeing them frequently in your log is normal.
3. `Chain extended, new tip`  entries
- This means your node successfully synced and adopted a new block into the chain. This is good — your node is functioning and following the chain.