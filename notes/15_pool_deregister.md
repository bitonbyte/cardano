# Stake pool deregistration

**WARNING:The pool deposit is refunded to the rewards address (stake.addr). Do not de-register the stake address before you get the deposit back.**

## Epoch for retirment

### Earliest retirement epoch

The epoch must be after the current epoch.

Query current epoch,
```bash
$ cardano-cli query tip --mainnet
...
    "epoch": 588,
...
```

The earliest retirement is
- Current epoch: `588`
- Retirement epoch: `589`

### Maximum retirement epoch (Optional)

```bash
$ cardano-cli query protocol-parameters \
  --mainnet \
  --out-file protocol.json
$ cat protocol.json | grep eMax
>  "poolRetireMaxEpoch": 18,
```

The maximum epoch retirement is
- Current epoch: `588`
- Retirement epoch: `606`

## Create deregistration certificate

```bash
cardano-cli conway stake-pool deregistration-certificate \
  --cold-verification-key-file cold.vkey \
  --epoch <future epoch> \
  --out-file pool-deregistration.cert
```

## Transaction fees

(This query will take about 20 seconds to execute)
```bash
cardano-cli conway transaction build \
--mainnet \
--tx-in $(cardano-cli query utxo --address $(cat payment.addr) --mainnet --out-file  /dev/stdout | jq -r 'keys[0]') \
--change-address $(cat payment.addr) \
--witness-override 2 \
--certificate-file  pool-deregistration.cert \
--out-file tx.raw
```
`> Estimated transaction fee: 180329 Lovelace`

## Sign the transaction

```bash
cardano-cli conway transaction sign \
    --mainnet \
    --tx-body-file tx.raw \
    --signing-key-file payment.skey \
    --signing-key-file cold.skey \
    --out-file tx.signed
```

## Submit

```bash
cardano-cli conway transaction submit \
--mainnet \
--tx-file tx.signed
```
`> Transaction successfully submitted. Transaction hash is: {"txhash":"e696a0ba0438ca073281ddbd150e4d37972924fed1d011277f0dd792b0ab1a4e"}`

## Verify
Go to https://adastat.net/ and search for the Pool. You will notice the annotation that the pool is set to retire.


## Reference
1. (https://docs.cardano.org/stake-pool-operators/maintenance)
2. (https://cardano-course.gitbook.io/cardano-course/handbook/create-a-stake-pool/retiring-a-stake-pool)
3. (https://github.com/input-output-hk/cardano-node-wiki/blob/main/docs/stake-pool-operations/12_retire_stakepool.md)
4. (https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node/part-iv-administration/retiring-your-stake-pool)