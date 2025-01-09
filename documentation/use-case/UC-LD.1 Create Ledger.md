# UC-LD.1 Create Ledger

**Actor**: User

**Relevant Assumptions**:
- [A-1 Currency Configuration](../requirements/assumptions.md#a-1-currency-configuration)
- [A-3 Currency Denomination](../requirements/assumptions.md#a-3-currency-denomination)

**Scope**: Ledger System

**Preconditions**: None

**Success End Condition**: New ledger exists with specified currencies

**Required Data**:
- Currency list (non-empty list of supported currency codes)

**Main Success Scenario**:
1. User submits ledger creation request with currency list
2. System validates:
    - Currency list is not empty
    - All currencies are supported
    - No duplicate currencies in the list
3. System creates new ledger:
    - Assigns unique identifier
    - Initializes zero balance for each currency
4. System confirms ledger creation with:
    - Ledger identifier
    - List of initialized currencies
    - Initial balances

**Error Scenarios**:
1. Invalid currency list:
    - Empty list provided
    - Unsupported currency included
    - Duplicate currencies found
2. System unable to create ledger:
    - Ledger remains in PENDING state
    - Transitions to ERROR state if initialization fails
3. Timeout during initialization:
    - Ledger transitions to ERROR state
    - New creation attempt required

**States**:
- PENDING: Initial state during ledger creation and wallet initialization
- ACTIVE: Normal operational state after successful creation
- ERROR: Creation failed, ledger cannot be used

**State Transitions**:
1. New ledger record created in PENDING state
2. Currency wallets initialized with zero balances
3. Ledger state changed to ACTIVE upon successful initialization
