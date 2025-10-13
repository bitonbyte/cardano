# 🪙 Cardano Node Setup Guide

This repository provides detailed, step-by-step guidance for **Cardano stake pool operators (SPOs)** to set up, manage, and maintain their **relay** and **block-producing** nodes.

It’s based on real-world operator experience and aims to make the setup process simple, reliable, and repeatable.

---

## 📁 Repository Structure

| Folder / File | Description |
| ------------- | ----------- |
| [`notes/`](./notes) | Comprehensive documentation and best practices for node setup, maintenance, and monitoring. |
| [`notes/01_host_setup.md`](./notes/01_host_setup.md) | Setting up the host |
| [`notes/02_keys_glossary.md`](./notes/02_keys_glossary.md) | Keys Glossary |
| [`notes/03_cardano-node_cardano-cli.md`](./notes/03_cardano-node_cardano-cli.md) | Install cardano-node and cardano-cli |
| [`notes/04_run_node.md`](./notes/04_run_node.md) | Run a node |
| [`notes/05_relay_node_service.md`](./notes/05_relay_node_service.md) | Configure service for relay node |
| [`notes/06_copy_db.md`](./notes/06_copy_db.md) | Make a copy of DB |
| [`notes/06_sync_db_faq.md`](./notes/06_sync_db_faq.md) | DB synchronization questions |
| [`notes/07_block_node_service.md`](./notes/07_block_node_service.md) | Configure service for block producing node |
| [`notes/08_payment_keys.md`](./notes/08_payment_keys.md) | Generate payment keys |
| [`notes/09_pool_keys.md`](./notes/09_pool_keys.md) | Generate stake pool keys |
| [`notes/10_run_block_node.md`](./notes/10_run_block_node.md) | Run block producing node |
| [`notes/11_register_stake_addr.md`](./notes/11_register_stake_addr.md) | Register stake address |
| [`notes/12_register_pool.md`](./notes/12_register_pool.md) | Register stake pool |
| [`notes/13_relay_block_peer_connectivity.md`](./notes/13_relay_block_peer_connectivity.md) | Connect Relay node to block node and to peers |
| [`notes/14_pool_maintenance.md`](./notes/14_pool_maintenance.md) | Pool maintenance and rotating KES keys |
| [`notes/15_pool_deregister.md`](./notes/15_pool_deregister.md) | Deregistering a Pool |
| [`notes/16_clean_up.md`](./notes/16_clean_up.md) | Cleaning up files from localhost |
| [`scripts/`](./scripts) | Shell scripts to automate routine operations mentioned in the notes. |

---

## 🚀 Getting Started

### 1️⃣ Clone the repository
```bash
git clone https://github.com/<your-username>/cardano.git
cd cardano
