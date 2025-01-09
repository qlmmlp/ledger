## Functional requirements

### FR-1 Ledger Management
System shall provide functionality to create and manage ledgers.
Reference: [2.a Ledger Management](business-requirements.md#2a-ledger-management)

### FR-1.1 Ledger Creation
System shall create new ledgers with unique identifiers.
Reference: [2.a Ledger Management](business-requirements.md#2a-ledger-management)

### FR-1.2 Ledger Currency Settings
System shall allow setting one or multiple currencies per ledger.
Reference: [2.a Ledger Management](business-requirements.md#2a-ledger-management), [B.2 Multi-Currency Features](business-requirements.md#b2-multi-currency-features)

### FR-1.3 Currency Validation
🔄 System shall validate all currency operations against ISO 4217 currency codes.
Reference: [B.2 Multi-Currency Features](business-requirements.md#b2-multi-currency-features)

### FR-1.4 Currency Availability Management
🔄 System shall maintain a list of supported currencies.
Reference: [B.2 Multi-Currency Features](business-requirements.md#b2-multi-currency-features)

### FR-1.5 Currency Support Status
🔄 System shall verify currency support status before any currency-related operation.
Reference: [B.2 Multi-Currency Features](business-requirements.md#b2-multi-currency-features)

### FR-2 Transaction Processing
System shall provide functionality to process financial transactions within ledgers.
Reference: [2.b Transaction Processing](business-requirements.md#2b-transaction-processing)

### FR-2.1 Transaction Recording
System shall record new transactions with specified ledger ID, transaction type (debit/credit), amount, currency, and transaction ID.
Reference: [2.b Transaction Processing](business-requirements.md#2b-transaction-processing)

### FR-2.2 Transaction Idempotency
🔄 System shall ensure that transactions with duplicate transaction IDs are processed only once.
Reference: [2.b Transaction Processing](business-requirements.md#2b-transaction-processing), [3.b Transaction Safety](business-requirements.md#3b-transaction-safety)

### FR-2.3 Transaction Atomicity
🔄 System shall process transactions atomically, ensuring that both debit and credit operations are completed successfully or none of them is applied.
Reference: [3.b Transaction Safety](business-requirements.md#3b-transaction-safety)

### FR-2.4 Transaction Performance
System shall process up to 1,000 transactions per minute.
Reference: [4.a Performance Goals](business-requirements.md#4a-performance-goals)

### FR-2.5 Transaction Validation
🔄 System shall validate transaction data including:
- Ledger existence
- Currency support
- Amount positivity
- Transaction ID format
  Reference: [2.b Transaction Processing](business-requirements.md#2b-transaction-processing), [4.c Error Management](business-requirements.md#4c-error-management)

### FR-2.6 Transaction History
🔄 System shall maintain complete history of all transactions for each ledger.
Reference: [2.b Transaction Processing](business-requirements.md#2b-transaction-processing)

### FR-3 Balance Management
System shall provide functionality to query and manage ledger balances.
Reference: [2.c Balance Query](business-requirements.md#2c-balance-query)

### FR-3.1 Balance Querying
System shall return current balance for a specified ledger.
Reference: [2.c Balance Query](business-requirements.md#2c-balance-query)

### FR-3.2 Multi-Currency Balance
System shall return balances for all currencies associated with the ledger.
Reference: [2.c Balance Query](business-requirements.md#2c-balance-query), [B.2 Multi-Currency Features](business-requirements.md#b2-multi-currency-features)

### FR-3.3 Balance Calculation
🔄 System shall calculate balance as a sum of all processed transactions for each currency independently.
Reference: [2.c Balance Query](business-requirements.md#2c-balance-query)

### FR-3.4 Real-time Balance Updates
🔄 System shall reflect all processed transactions in balance calculations immediately.
Reference: [2.c Balance Query](business-requirements.md#2c-balance-query), [4.a Performance Goals](business-requirements.md#4a-performance-goals)

### FR-3.5 Zero Balance Handling
🔄 System shall include currencies with zero balance in balance query response if they were ever used in the ledger.
Reference: [2.c Balance Query](business-requirements.md#2c-balance-query)

### FR-4 Error Handling
System shall provide comprehensive error handling and reporting.
Reference: [4.c Error Management](business-requirements.md#4c-error-management)

### FR-4.1 Validation Errors
🔄 System shall return validation errors for:
- Invalid currency codes
- Invalid amount format
- Non-existent ledger ID
- ⚠️ Duplicate reference ID
- Unsupported currency
  Reference: [4.c Error Management](business-requirements.md#4c-error-management)

### FR-4.2 System Errors
🔄 System shall handle and properly report system-level errors:
- Database connectivity issues
- External service failures
- Resource constraints
  Reference: [4.c Error Management](business-requirements.md#4c-error-management)

### FR-4.3 Error Response Format
🔄 System shall provide error responses containing:
- Error code
- Error message
- Error details when applicable
  Reference: [4.c Error Management](business-requirements.md#4c-error-management)

### FR-5 Currency Conversion
System shall support currency conversion functionality.
Reference: [B.3 Currency Exchange](business-requirements.md#b3-currency-exchange)

### FR-5.1 Exchange Rate Integration
System shall integrate with external currency conversion API.
Reference: [B.3 Currency Exchange](business-requirements.md#b3-currency-exchange)

### FR-5.2 Balance Conversion
🔄 System shall provide ability to request balance in any supported currency with conversion.
Reference: [B.3 Currency Exchange](business-requirements.md#b3-currency-exchange)

### FR-5.3 Exchange Rate Caching
🔄 System shall maintain cache of exchange rates to minimize external API calls.
Reference: [B.3 Currency Exchange](business-requirements.md#b3-currency-exchange)

### FR-5.4 Failed Conversion Handling
🔄 System shall handle external conversion service failures gracefully.
Reference: [B.3 Currency Exchange](business-requirements.md#b3-currency-exchange)