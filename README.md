<!-- markdownlint-disable MD033 MD034 MD036 MD041 -->

![miniutopia-hub](./public/social.png)

# Miniutopia Hub

A decentralized NFT studio and marketplace platform built on EVM chains.

## Prerequisites

**Required**

- Git
- Node.js 14 or LTS
- Yarn
- MetaMask or compatible EVM wallet

**Optional**

- S3 bucket instance (minio, etc.)

## Setup local development

```sh
# clone repository
git clone https://github.com/faithful1ofall/miniutopia-hub.git
cd miniutopia-hub

# install dependencies
yarn install

# copy env file and fill in values
cp .env.example .env

# run development server
yarn dev

# (optional) lint and format project
yarn lint
```

## Supported Networks

- Planq Atlas Testnet (Chain ID: 7077)

## Features

- NFT Collection Creation & Management
- Minting Platform
- Whitelist Management
- Royalty Registry
- Token Splits
- Badge System

<img src="./public/icon.png" height="96" align="right" />
