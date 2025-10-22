# Deregister stake address

## Query payment.addr with new balance transferred from stake.addr

```bash
cardano-cli query utxo \
  --address $(cat payment.addr) \
  --mainnet
```
⚠️ NOTE: This query might take a moment to respond

```log
> 
{
    "e24e5dd0ea9a416fb112531ff8bc964b961ee3acb0d68d66445a27fe55f5e399#0": {
        "address": "addr1q8qzv85u5mkur78fyd4un63huygpg2kfsc2vc0vnkzvssdhh2nj6h4ltsy3fjajfs74ev5zqgl230ekwgxhntefd3pyqht7n3y",
        "datum": null,
        "datumhash": null,
        "inlineDatum": null,
        "inlineDatumRaw": null,
        "referenceScript": null,
        "value": {
            "lovelace": 1007177814
        }
    }
}
```
UTXO identifier: `e24e5dd0ea9a416fb112531ff8bc964b961ee3acb0d68d66445a27fe55f5e399#0`

## Query stake.addr after rewards were transferred

```bash
cardano-cli query stake-address-info \
--address $(cat stake.addr) \
--mainnet

> 
[
    {
        "address": "stake1u8m4fedt6l4czg5eweyc02uk2pqy04ghum8yrte4u5kcsjq0njplj",
        "govActionDeposits": {},
        "rewardAccountBalance": 0,
        "stakeDelegation": null,
        "stakeRegistrationDeposit": 2000000,
        "voteDelegation": "alwaysAbstain"
    }
]
```

## Deregister stake.addr and move registration deposit to payment.addr

### Build the deregistration certificate

```bash
cardano-cli conway stake-address deregistration-certificate \
  --stake-verification-key-file stake.vkey \
  --key-reg-deposit-amt 2000000 \
  --out-file stake.dereg.cert
```

### Build the transaction

```bash
cardano-cli conway transaction build \
  --mainnet \
  --tx-in e24e5dd0ea9a416fb112531ff8bc964b961ee3acb0d68d66445a27fe55f5e399#0 \
  --certificate-file stake.dereg.cert \
  --change-address $(cat payment.addr) \
  --out-file dereg.raw
```
> Estimated transaction fee: 180505 Lovelace

### Sign the transaction

```bash
cardano-cli conway transaction sign \
  --tx-body-file dereg.raw \
  --signing-key-file payment.skey \
  --signing-key-file stake.skey \
  --mainnet \
  --out-file dereg.signed
```

### Submit to blockchain

```bash
cardano-cli conway transaction submit \
  --tx-file dereg.signed \
  --mainnet
```
```log
> Transaction successfully submitted. Transaction hash is:
{"txhash":"8963e2b1b9c4b9c7d03eef7928250d4a78418d354bf79000da99e72917bba9bb"}
```

## Verification

### Query stake.addr (it will be empty)

After stake deregistration, stake.addr will be empty,
```bash
cardano-cli query stake-address-info \
  --address $(cat stake.addr) \
  --mainnet
```

### Query payment.addr (it will have all the ADA)

```bash
cardano-cli query utxo \
  --address $(cat payment.addr) \
  --mainnet
```
```log
>
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