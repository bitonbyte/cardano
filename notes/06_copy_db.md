# Copy /db folder

The db folder takes a long time to sync with mainnet. About 5 - 7 days.  
After creating the relay node, you would want to copy it to the block node instead of waiting for the block-node to synch for another 5-7 days.


## Copy to localhost from relay node

First, stop the service in the remote server on relay node. This ensures the /db folder doesn't get corrupted while syncing.
```bash
sudo systemctl stop relay-node-mainnet
```

Execute on localhost to pull the db folder from relay node,
```bash
rsync -avz -e "ssh -i /path/to/private_key.pem -p PORT" user@host:/opt/cardano/mainnet/db/ /local/path/db/
```

### Trailing slash behavior

Adding or omitting the trailing / changes whether you copy the contents or the directory including its name.

```bash
# Includes contents of the folder only:
rsync -avz user@remote:/remote/folder/ /local/folder/

# Includes the folder itself:
rsync -avz user@remote:/remote/folder /local/
```

## Copy to block node from localhost

Execute on localhost to push the db folder to block node,
```bash
rsync -avz --progress -e "ssh -i /path/to/private_key.pem -p PORT" /local/path/db user@remote:/opt/cardano/mainnet/
```

For about 10-20% better performance, modify the above query to,
```bash
rsync -avz --progress -e "ssh -c aes128-gcm@openssh.com -i /path/to/private_key.pem -p PORT" /local/path/db user@remote:/opt/cardano/mainnet/
```
`-c`: cipher

Delete all files in the `db/` folder except `immutable/` and `protocolMagicId`. The rest of it will be generated when you run the node.

Same node version on source and target to avoid compatibility issues.
```bash
cardano-node --version
```

Ensure the target node’s user (e.g., ubuntu) owns the copied files:
```bash
sudo chown -R ubuntu:ubuntu /opt/cardano/mainnet/db
```