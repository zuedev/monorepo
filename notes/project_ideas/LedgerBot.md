# LedgerBot

> A ledger system for Discord. 📒

## Abstract

LedgerBot is a Discord bot that allows users to keep track of assets and liabilities. It is designed to be simple and easy to use, with a focus on usability and convenience. Users can create accounts, add transactions, view their balance, and more, all within Discord.

### Motivation

As a forever-DM for TTRPG games like D&D, I often find myself needing to keep track of various assets and liabilities for my players such as gold, items, and debts. I wanted a simple and easy-to-use system that would allow me to do this within Discord, without having to rely on external tools or websites. Not only does this make it more convenient for me and the players, but it also adds a layer of accountability and transparency to the game.

## Features

- [ ] **Serverless Architecture:** LedgerBot is designed to be ran using interaction endpoints via HTTP POSTs rather than over Gateway with a bot user. This allows for the bot to be ran in a serverless environment such as AWS Lambda or Google Cloud Functions, reducing the cost of running the bot to near zero when not in use whilst allowing for near-instantaneous scaling when needed.
- [ ] **Multi-Dimensional Ledger Scope:** Ledgers can be scoped at the local, regional, or global level, allowing for multiple games or campaigns to be tracked simultaneously.
  - [ ] **Local (Per-Channel) Ledgers:** Each channel can have its own ledger, allowing for multiple games or campaigns to be tracked simultaneously. This is the default mode of operation.
    - Local ledgers are identified by the following format: `local-<CHANNEL_ID>` where `<CHANNEL_ID>` is the unique identifier of the channel provided by Discord.
  - [ ] **Regional (Per-Guild) Ledgers:** Server admins can opt to have a single ledger shared across all channels, allowing for a global view of all assets and liabilities. This mode is disabled by default, but can work in conjunction with local ledgers.
    - Regional ledgers are identified by the following format: `regional-<GUILD_ID>` where `<GUILD_ID>` is the unique identifier of the guild provided by Discord.
  - [ ] **Global (Per-Bot) Ledger:** The bot itself maintains a global ledger that is shared across all servers, allowing for a universal view of all assets and liabilities. This mode is disabled by default, but can work in conjunction with local and regional ledgers.
    - Global ledgers are identified by the following format: `global-<APP_ID>` where `<APP_ID>` is the unique identifier of the application provided by Discord.
- [ ] **Account Management:** Users can create, delete, and view accounts, which represent individual entities within the ledger system.
  - [ ] **Account Creation:** Users can create new accounts with a unique name and description.
  - [ ] **Account Deletion:** Users can delete existing accounts, removing them from the ledger system.
  - [ ] **Account Listing:** Users can view a list of all accounts in the ledger system, along with their current balance.
- [ ] **Transaction Management:** Users can add, delete, and view transactions, which represent changes in the balance of an account.
  - [ ] **Transaction Creation:** Users can add new transactions to an account, specifying the amount, type, and description.
  - [ ] **Transaction Deletion:** Users can delete existing transactions, reverting their effects on the account balance.
  - [ ] **Transaction Listing:** Users can view a list of all transactions for an account, along with their details.
- [ ] **Ledger Inquiry:** Users can view the current state of the ledger, which includes a summary of all accounts and their balances.
- [ ] **Ledger Data Management:** Users can export, import, and reset the ledger, allowing for data backup, restoration, and cleanup.
  - [ ] **Ledger Export:** Users can export the current state of the ledger to a file, which can be saved and shared with others.
  - [ ] **Ledger Import:** Users can import a ledger from a file, which can be used to restore a previous state of the ledger.
  - [ ] **Ledger Reset:** Users can reset the ledger to its initial state, removing all accounts and transactions.
