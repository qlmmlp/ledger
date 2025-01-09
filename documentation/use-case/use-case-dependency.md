## Dependencies Between Operations

1. **Creation Dependencies**:
    - Add Funds requires prior Ledger Creation
    - Subtract Funds requires prior Ledger Creation
    - Convert Funds requires prior Ledger Creation
    - Get State requires prior Ledger Creation

2. **Operation Dependencies**:
    - Subtract Funds requires prior Add Funds (to have non-zero balance)
    - Convert Funds requires prior Add Funds (to have non-zero balance)
    - Subtract Funds may require multiple prior Add Funds operations to reach sufficient balance

3. **State Consistency**:
    - Balance after Add Funds must equal previous balance plus added amount
    - Balance after Subtract Funds must equal previous balance minus subtracted amount
    - Sum of balances after Convert Funds must reflect exchange rate application
    - Get State must reflect all prior successful operations