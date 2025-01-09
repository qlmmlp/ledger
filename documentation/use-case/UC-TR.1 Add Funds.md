# UC-TR.1 Add Funds

**Actor**: User

**Relevant Assumptions**:
- [A-18 Record Keeping Scope](../requirements/assumptions.md#a-18-record-keeping-scope)
- [A-3 Currency Denomination](../requirements/assumptions.md#a-3-currency-denomination)
- [A-8 Concurrent Transaction Processing](../requirements/assumptions.md#a-8-concurrent-transaction-processing)
- [A-9 Transaction Order Guarantee](../requirements/assumptions.md#a-9-transaction-order-guarantee)

**Scope**: Ledger System

**Preconditions**:
- Ledger exists in ACTIVE state

**Success End Condition**: Ledger balance increased for specified currency

**Required Data**:
- Ledger identifier
- Currency code
- Amount (positive number)

**Main Success Scenario**:
1. User submits add funds request
2. System validates:
    - Ledger exists and is ACTIVE
    - Currency exists in ledger
    - Amount is positive
3. System updates balance:
    - Adds amount to specified currency wallet
4. System returns:
    - Updated currency balance
    - Timestamp of operation

**Error Scenarios**:
1. Ledger not found or not ACTIVE
2. Currency not found in ledger
3. Invalid amount (zero or negative)
4. Balance update failure

**State Transitions**:
- Currency wallet balance increased by specified amount
