# Yield Farming

A dApp which implements the concept of yield farming / liquidity mining following the [Dapp University Tutorial](https://www.youtube.com/watch?v=CgXQC4dbGUE).

## Purpose

Users can stake and unstake a mock stablecoin called mDAI. When unstake, users withdraw mDAI tokens and are rewarded with protocol tokens called DAPP.

## Setup

- `npm install` - install all the modules needed to run the dApp
- Install and start [Ganache](https://www.trufflesuite.com/ganache)
- Install and setup [MetaMask](https://metamask.io/)

## Useful commands

- `truffle compile` - compile solidity contracts
- `truffle migrate [--reset]` - migrate solidity contracts. when you redeploy, replace the old contracts
- `truffle console` - interact with javascript runtime environment
- `truffle test` - run test scripts

- `npm run start` - start the local server for the dApp


## User Interface

![alt text](img/yield_farming_UI.jpg)

## Misc

```
# Inside of a truffle console
> tokenFarm = await TokenFarm.deployed()

> tokenFarm

> tokenFarm.address

> name = await tokenFarm.name()
```
