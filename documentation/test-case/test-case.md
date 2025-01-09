# Test Case Catalog

## [UC-LD.1 Create Ledger](../use-case/UC-LD.1%20Create%20Ledger.md)

- TC-LD.1.1 Create Ledger Succeeds With Single Currency
- TC-LD.1.2 Create Ledger Succeeds With Multiple Currencies
- TC-LD.1.3 Create Ledger Fails When Currency List Empty
- TC-LD.1.4 Create Ledger Fails When Currency Not Supported
- TC-LD.1.5 Create Ledger Fails When Duplicate Currency Provided
- TC-LD.1.6 Create Ledger Fails During System Error
- TC-LD.1.7 Create Ledger Fails During Timeout

## [UC-LD.2 Get Ledger State](../use-case/UC-LD.2%20Get%20Ledger%20State.md)

- TC-LD.2.1 Get Ledger State Succeeds For Active Ledger
- TC-LD.2.2 Get Ledger State Fails When Ledger Not Found
- TC-LD.2.3 Get Ledger State Returns Zero Balances For New Ledger

## [UC-TR.1 Add Funds](../use-case/UC-TR.1%20Add%20Funds.md)

- TC-TR.1.1 Add Funds Succeeds To Empty Wallet
- TC-TR.1.2 Add Funds Succeeds To Non-Empty Wallet
- TC-TR.1.3 Add Funds Fails When Ledger Not Found
- TC-TR.1.4 Add Funds Fails When Currency Not In Ledger
- TC-TR.1.5 Add Funds Fails When Amount Is Zero
- TC-TR.1.6 Add Funds Maintains Order With Concurrent Operations

## [UC-TR.2 Convert Funds](../use-case/UC-TR.2%20Convert%20Funds.md)

- TC-TR.2.1 Convert Funds Succeeds With Full Amount
- TC-TR.2.2 Convert Funds Fails When Insufficient Balance
- TC-TR.2.3 Convert Funds Fails When Ledger Not Found
- TC-TR.2.4 Convert Funds Fails When Source Currency Not Found
- TC-TR.2.5 Convert Funds Fails When Target Currency Not Found
- TC-TR.2.6 Convert Funds Fails When Same Currency Used
- TC-TR.2.7 Convert Funds Fails When Exchange Rate Unavailable
- TC-TR.2.8 Convert Funds Applies Correct Rounding Rules
- TC-TR.2.9 Convert Funds Maintains Order With Concurrent Operations

## [UC-TR.3 Subtract Funds](../use-case/UC-TR.3%20Subtract%20Funds.md)

- TC-TR.3.1 Subtract Funds Succeeds
- TC-TR.3.2 Subtract Funds Succeeds With Full Amount
- TC-TR.3.3 Subtract Funds Fails When Insufficient Balance
- TC-TR.3.4 Subtract Funds Fails When Ledger Not Found
- TC-TR.3.5 Subtract Funds Fails When Currency Not In Ledger
- TC-TR.3.6 Subtract Funds Fails When Amount Is Zero
- TC-TR.3.7 Subtract Funds Updates Balance Correctly