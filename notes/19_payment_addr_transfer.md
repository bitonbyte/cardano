# Transfer from payment.addr to cryptocurrency wallet

Transfer the ADA from localhost payment.addr to cryptocurrency wallet.

## Get receiver address on wallet from Daedalus or Yoroi

E.g. `addr1qyw27dun0rq9zwhh78mkph0e3s6syvk0lhpmwdl740u7wdcnemknujapsdxrkkg4tz0zg4j7k3nftg777dhsv8qx5c9qum7ezh`

## Query UTXOs of sender payment address

```bash
cardano-cli query utxo \
  --address $(cat payment.addr) \
  --mainnet
```
⚠️ NOTE: This query might take a moment to respond

```bash
# Response
{
    "8963e2b1b9c4b9c7d03eef7928250d4a78418d354bf79000da99e72917bba9bb#0": {
        "address": "addr1q8qzv85u5mkur78fyd4un63huygpg2kfsc2vc0vnkzvssdhh2nj6h4ltsy3fjajfs74ev5zqgl230ekwgxhntefd3pyqht7n3y",
        "datum": null,
        "datumhash": null,
        "inlineDatum": null,
        "inlineDatumRaw": null,
        "referenceScript": null,
        "value": {
            "lovelace": 1008997309
        }
    }
}
```
UTXO identifier: `8963e2b1b9c4b9c7d03eef7928250d4a78418d354bf79000da99e72917bba9bb#0`

## Move funds from sender to receiver

### Build transaction to move everything from sender to receiver

**Syntax**
```bash
cardano-cli conway transaction build \
  --mainnet \
  --tx-in <UTXO ID> \
  --change-address <receiver_payment_addr> \
  --out-file withdraw.raw
```

**Actual**
```bash
cardano-cli conway transaction build \
  --mainnet \
  --tx-in 8963e2b1b9c4b9c7d03eef7928250d4a78418d354bf79000da99e72917bba9bb#0 \
  --change-address addr1qyw27dun0rq9zwhh78mkph0e3s6syvk0lhpmwdl740u7wdcnemknujapsdxrkkg4tz0zg4j7k3nftg777dhsv8qx5c9qum7ezh \
  --out-file send.raw
```
> Estimated transaction fee: 169681 Lovelace

### Sign the transaction

```bash
cardano-cli conway transaction sign \
  --tx-body-file send.raw \
  --signing-key-file payment.skey \
  --mainnet \
  --out-file send.signed
```

### Submit the transaction

```bash
cardano-cli conway transaction submit \
  --tx-file send.signed \
  --mainnet
```
```log
Transaction successfully submitted. Transaction hash is:
{"txhash":"02a5fcf8f3c6ccb9d301d0c79c3b04d1d6498b75962833dc1c9d043e25d109c7"}
```

## Verify transaction

### Check sender's payment address

```bash
cardano-cli query utxo \
  --address $(cat payment.addr) \
  --mainnet
```
> {}

Returns nothing

### Check receiver's payment address

```bash
cardano-cli query utxo \
  --address addr1qyw27dun0rq9zwhh78mkph0e3s6syvk0lhpmwdl740u7wdcnemknujapsdxrkkg4tz0zg4j7k3nftg777dhsv8qx5c9qum7ezh \
  --mainnet
```

```log
>
{
    "02a5fcf8f3c6ccb9d301d0c79c3b04d1d6498b75962833dc1c9d043e25d109c7#0": {
        "address": "addr1qyw27dun0rq9zwhh78mkph0e3s6syvk0lhpmwdl740u7wdcnemknujapsdxrkkg4tz0zg4j7k3nftg777dhsv8qx5c9qum7ezh",
        "datum": null,
        "datumhash": null,
        "inlineDatum": null,
        "inlineDatumRaw": null,
        "referenceScript": null,
        "value": {
            "lovelace": 1008827628
        }
    }
}
```
Total amount moved,
`"lovelace": 1008827628`
