# UC-TR.2 Convert Funds

**Actor**: User

**Relevant Assumptions**:
- [A-3 Currency Denomination](../requirements/assumptions.md#a-3-currency-denomination)
- [A-5 Exchange Rates Source](../requirements/assumptions.md#a-5-exchange-rates-source)
- [A-6 Exchange Rate Precision](../requirements/assumptions.md#a-6-exchange-rate-precision)
- [A-7 Currency Conversion Rounding](../requirements/assumptions.md#a-7-currency-conversion-rounding)
- [A-8 Concurrent Transaction Processing](../requirements/assumptions.md#a-8-concurrent-transaction-processing)
- [A-9 Transaction Order Guarantee](../requirements/assumptions.md#a-9-transaction-order-guarantee)

**Scope**: Ledger System

**Preconditions**:
- Ledger exists in ACTIVE state
- Source currency has sufficient balance

**Success End Condition**: Source currency decreased, target currency increased

**Required Data**:
- Ledger identifier
- Source currency code
- Target currency code
- Amount to convert (from source currency)

**Main Success Scenario**:
1. User submits conversion request
2. System validates:
    - Ledger exists and is ACTIVE
    - Both currencies exist in ledger
    - Sufficient source balance
    - Conversion rate available
3. System calculates conversion:
    - Determines current exchange rate
    - Calculates target amount
4. System updates balances:
    - Decreases source currency
    - Increases target currency
5. System returns:
    - Updated balances for both currencies
    - Applied exchange rate
    - Timestamp of operation

**Error Scenarios**:
1. Ledger not found or not ACTIVE
2. Currency not found in ledger
3. Insufficient source balance
4. Conversion rate unavailable
5. Same currency specified for source and target
6. Balance update failure

**State Transitions**:
- Source currency wallet decreased
- Target currency wallet increased