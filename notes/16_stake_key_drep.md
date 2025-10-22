# Stake key delegation to DRep

- A stake key can only withdraw rewards if it is currently delegated to a DRep
- Query stake address and verify that your stake key is delegated to a DRep

## Check for pool retirement

Wait until the epoch at which your pool is set to retire.
- Check [adastat.net](https://adastat.net/pools) to confirm the pool has retired.

## Query UTXOs of your payment address (to fund transaction fees)

Get a list of UTXOs from your payment.addr and use one as transaction input, 
```bash
cardano-cli query utxo \
  --address $(cat payment.addr) \
  --mainnet
```
⚠️ NOTE: This query might take a moment to respond

```bash
> #Response
{
    "e696a0ba0438ca073281ddbd150e4d37972924fed1d011277f0dd792b0ab1a4e#0": {
        "address": "addr1q8qzv85u5mkur78fyd4un63huygpg2kfsc2vc0vnkzvssdhh2nj6h4ltsy3fjajfs74ev5zqgl230ekwgxhntefd3pyqht7n3y",
        "datum": null,
        "datumhash": null,
        "inlineDatum": null,
        "inlineDatumRaw": null,
        "referenceScript": null,
        "value": {
            "lovelace": 507538428
        }
    }
}
```

Only one UTXO was found, and we can use that.

- UTXO identifier: `e696a0ba0438ca073281ddbd150e4d37972924fed1d011277f0dd792b0ab1a4e#0`
  - `#0` → the index of the output in that transaction
- Address: addr1q8qzv85u5m... → your payment address
- Value: 507,538,428 lovelace → ~507.5 ADA available in this UTXO

## Check stake.addr

The pool deposit is refunded to the rewards address (stake.addr)
```bash
$ cardano-cli query stake-address-info \ 
  --address $(cat stake.addr) \
  --mainnet
```
```bash
# Response
[
    {
        "address": "stake1u8m4fedt6l4czg5eweyc02uk2pqy04ghum8yrte4u5kcsjq0njplj",
        "govActionDeposits": {},
        "rewardAccountBalance": 500000000,
        "stakeDelegation": null,
        "stakeRegistrationDeposit": 2000000,
        "voteDelegation": null
    }
]
```

### Balance 
- 1 ADA = 1,000,000 lovelace
- `rewardAccountBalance: 500000000` → 500 ADA in rewards (in lovelace)
  - This was the deposit during pool registration
- `stakeRegistrationDeposit: 2000000` → 2 ADA deposit for registering the stake address (this will also be returned when you deregister the stake key)
  - This is the stake registration deposit which is different from pool registration deposit
- `stakeDelegation: null` → currently not delegated
- So both rewards and deposit are available to withdraw.

### Submit a transaction that delegates your stake key to a DRep (--always-abstain).

**A stake key can only withdraw rewards if it is currently delegated to a DRep.**
In other words, `stake-address-info` query must have `"voteDelegation": "alwaysAbstain"` but in this case it is `null`.

1. Delegate your stake key to a DRep
```bash
cardano-cli conway stake-address vote-delegation-certificate \
  --stake-verification-key-file stake.vkey \
  --always-abstain \
  --out-file drep.delegate.cert
```

2. Build transaction

**Syntax**
```bash
cardano-cli conway transaction build \
  --mainnet \
  --tx-in <TX_HASH>#<TX_INDEX> \
  --certificate-file drep.delegate.cert \
  --change-address <payment_addr> \
  --out-file delegate.raw
```

**Actual**
```bash
cardano-cli conway transaction build \
  --mainnet \
  --tx-in e696a0ba0438ca073281ddbd150e4d37972924fed1d011277f0dd792b0ab1a4e#0 \
  --certificate-file drep.delegate.cert \
  --change-address addr1q8qzv85u5mkur78fyd4un63huygpg2kfsc2vc0vnkzvssdhh2nj6h4ltsy3fjajfs74ev5zqgl230ekwgxhntefd3pyqht7n3y \
  --out-file delegate.raw
```
> Estimated transaction fee: 180373 Lovelace

3. Sign the transaction
```bash
cardano-cli conway transaction sign \
  --tx-body-file delegate.raw \
  --signing-key-file payment.skey \
  --signing-key-file stake.skey \
  --mainnet \
  --out-file delegate.signed
```

4. Submit the transaction
```bash
cardano-cli conway transaction submit \
  --tx-file delegate.signed \
  --mainnet
```

5. Wait for 1 block confirmation (takes about 20-60 secs). After that, your stake key is officially delegated to a DRep.

6. Verify by querying stake addr.

```bash
$ cardano-cli query stake-address-info \
  --address $(cat stake.addr) \
  --mainnet

> #Response
[
    {
        "address": "stake1u8m4fedt6l4czg5eweyc02uk2pqy04ghum8yrte4u5kcsjq0njplj",
        "govActionDeposits": {},
        "rewardAccountBalance": 500000000,
        "stakeDelegation": null,
        "stakeRegistrationDeposit": 2000000,
        "voteDelegation": "alwaysAbstain"
    }
]
```
Observe, `"voteDelegation": "alwaysAbstain"`
