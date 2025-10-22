# Clean up

## Files - DO NOT DELETE

- poolMetadata.json
  - This file must be hosted at https://adasurge.com/poolMetadata.json at all times. Do not delete at this URL.
  - Safe to delete in local host but needs to be available on the URL above. 

## Files - DELETE

Local vs on-chain:
- Certificates are just local files until you include them in a transaction and submit it.
- Once submitted and confirmed, the information is stored `on-chain` and immutable.
- Certificates can be re-created locally if lost, as long as you have the relevant keys (stake.vkey, stake.skey, cold.vkey, cold.skey).

### Certificates on chain

- delegation.cert
- pool-registration.cert
- stake.cert

### Others
- poolMetadataHash.txt

