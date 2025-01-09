# UC-TR.3 Subtract Funds

**Actor**: User

**Relevant Assumptions**:
- [A-18 Ledger System Boundaries](../requirements/assumptions.md#a-18-ledger-system-boundaries)
- [A-3 Currency Denomination](../requirements/assumptions.md#a-3-currency-denomination)
- [A-8 Concurrent Transaction Processing](../requirements/assumptions.md#a-8-concurrent-transaction-processing)
- [A-9 Transaction Order Guarantee](../requirements/assumptions.md#a-9-transaction-order-guarantee)

**Scope**: Ledger System

**Preconditions**:
- Ledger exists in ACTIVE state
- Specified currency wallet has sufficient balance

**Success End Condition**: Ledger balance decreased for specified currency

**Required Data**:
- Ledger identifier
- Currency code
- Amount to subtract

**Main Success Scenario**:
1. User submits subtract funds request
2. System validates:
    - Ledger exists and is ACTIVE
    - Currency exists in ledger
    - Amount is positive
    - Sufficient balance available
3. System updates balance
4. System returns updated state

**Error Scenarios**:
1. Ledger not found or not ACTIVE
2. Currency not found in ledger
3. Invalid amount
4. Insufficient balance

**State Transitions**:
- Currency wallet balance decreased by specified amount