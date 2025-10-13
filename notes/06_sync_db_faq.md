# FAQ

**If I'm making two nodes, can I simply copy the /db folder to the other node?**

Yes, you can copy the /db folder from one Cardano node to another — and it’s actually a common way to speed up synchronization for new nodes.

## Caveats

✅ Why It Works
- The /db folder contains the local blockchain state.
- Copying it allows the second node to skip syncing from genesis, saving hours or even days.

⚠️ What to Watch Out For
- Stop the source node first (Prevents corruption while copying).
- Use: sudo systemctl stop cardano-node
- Use: rsync or scp carefully
- Preserve file permissions and structure:

```bash
rsync -avz /opt/cardano/mainnet/db/ user@target-node:/opt/cardano/mainnet/db/
# Ledger folder caution: Be careful not to overwrite a running node's DB
```
## Suggestions

- Some operators suggest clearing the ledger/ subfolder before copying, especially across different hardware or OS setups.
- If issues arise, try deleting /db/ledger on the target node and let it rebuild.
- **Node version:** Make sure both nodes run the same version of cardano-node to avoid compatibility issues.
- **Permissions:** Ensure the target node’s user (e.g., ubuntu) owns the copied files:

```bash
sudo chown -R ubuntu:ubuntu /opt/cardano/mainnet/db
```