# UC-LD.2 Get Ledger State

**Actor**: User

**Relevant Assumptions**:
- [A-11 Read/Write Operations Ratio](../requirements/assumptions.md#a-11-readwrite-operations-ratio)
- [A-12 Query Patterns](../requirements/assumptions.md#a-12-query-patterns)
- [A-16 Currency Display Format](../requirements/assumptions.md#a-16-currency-display-format)

**Scope**: Ledger System

**Preconditions**:
- Ledger exists in ACTIVE state

**Success End Condition**: Current ledger state provided

**Required Data**:
- Ledger identifier

**Main Success Scenario**:
1. User requests ledger state
2. System validates:
    - Ledger exists and is ACTIVE
3. System returns:
    - List of all currencies
    - Current balance for each currency
    - Last operation timestamp

**Error Scenarios**:
1. Ledger not found or not ACTIVE
2. State retrieval failure

**State Transitions**:
- No state changes (read-only operation)
