# Transfer Stake Rewards

Move rewards money(deposit in this case) from stake.addr to paymnet.addr

## Query UTXOs of your payment address

```bash
cardano-cli query utxo \
  --address $(cat payment.addr) \
  --mainnet
```
⚠️ NOTE: This query might take a moment to respond

```bash
# Response
{
    "9ec8dd9c342ce72942eff3821e4e139ed184a93ad81194207963c080af441577#0": {
        "address": "addr1q8qzv85u5mkur78fyd4un63huygpg2kfsc2vc0vnkzvssdhh2nj6h4ltsy3fjajfs74ev5zqgl230ekwgxhntefd3pyqht7n3y",
        "datum": null,
        "datumhash": null,
        "inlineDatum": null,
        "inlineDatumRaw": null,
        "referenceScript": null,
        "value": {
            "lovelace": 507358055
        }
    }
}
```

- UTXO identifier: `9ec8dd9c342ce72942eff3821e4e139ed184a93ad81194207963c080af441577#0`

## Steps to build the withdrawal transaction

You need:
- Your payment address (`payment.addr`) to receive the funds
- Your stake signing key (`stake.skey`)
- Current protocol parameters

### Protocol parameters,

```bash
cardano-cli query protocol-parameters --mainnet --out-file params.json
```

### Build raw transaction

**Syntax**
```bash
cardano-cli conway transaction build \
  --mainnet \
  --tx-in <TX_HASH>#<TX_INDEX> \
  --withdrawal <stake_addr> \
  --change-address <payment_addr> \
  --out-file withdraw.raw
```

- <TX_HASH>#<TX_INDEX> - UTXO Identifier
  - `9ec8dd9c342ce72942eff3821e4e139ed184a93ad81194207963c080af441577#0`
- <payment_addr>
  - `addr1q8qzv85u5mkur78fyd4un63huygpg2kfsc2vc0vnkzvssdhh2nj6h4ltsy3fjajfs74ev5zqgl230ekwgxhntefd3pyqht7n3y`

**Example**
```bash
cardano-cli conway transaction build \
  --mainnet \
  --tx-in 9ec8dd9c342ce72942eff3821e4e139ed184a93ad81194207963c080af441577#0 \
  --withdrawal stake1u8m4fedt6l4czg5eweyc02uk2pqy04ghum8yrte4u5kcsjq0njplj+500000000 \
  --change-address addr1q8qzv85u5mkur78fyd4un63huygpg2kfsc2vc0vnkzvssdhh2nj6h4ltsy3fjajfs74ev5zqgl230ekwgxhntefd3pyqht7n3y \
  --out-file withdraw.raw
```
> Estimated transaction fee: 180241 Lovelace

### Sign the transaction

```bash
cardano-cli conway transaction sign \
  --tx-body-file withdraw.raw \
  --signing-key-file payment.skey \
  --signing-key-file stake.skey \
  --mainnet \
  --out-file withdraw.signed
```

### Submit the transaction

```bash
$ cardano-cli conway transaction submit \
  --tx-file withdraw.signed \
  --mainnet

> Transaction successfully submitted. Transaction hash is:
{"txhash":"e24e5dd0ea9a416fb112531ff8bc964b961ee3acb0d68d66445a27fe55f5e399"}
```

