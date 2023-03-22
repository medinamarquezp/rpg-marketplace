# 🧙‍♂️ Role-playing game ERC1155 marketplace

This project implements a Role-playing item marketplace by using an ERC1155 smart contract. Buyers should acquire Golden Coins by using MATIC tokens to be able to buy other marketplace items.

## Prerequisites

- Node JS installed: https://nodejs.org/en/download/
- Truffle suite installed: https://trufflesuite.com/docs/truffle/how-to/install/

## Testnet network

### Polygon Mumbai (testnet) information

- **Network:** Polygon Mumbai
- **New RPC URL:** https://rpc-mumbai.maticvigil.com/
- **Chain ID:** 80001
- **Currency symbol:** MATIC
- **Block explorer:** https://mumbai.polygonscan.com/
- **Faucet:** https://faucet.polygon.technology/

More info here: https://wiki.polygon.technology/docs/develop/metamask/config-polygon-on-metamask/

## Truffle

#### Deployment

- Copy .env.example and rename it to .env
- Set required variables on .env file

```sh
truffle compile
truffle migrate --network mumbai
```

#### Test

Tests all available operations on the contract.

```sh
truffle test
```
