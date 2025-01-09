### A-1 Currency Configuration
Supported currencies are defined at deployment time with configuration.

### A-2 Transaction Identification
Each transaction has two identifiers:
- Client-provided reference ID that must be unique
- System-generated transaction ID for internal referencing

### A-3 Currency Denomination
System operates only with currencies that are composed of 100 units of minimal nominal (similar to dollars/cents, euros/cents structure).

### A-4 Authentication
⚠️ Obsolete: ~~System does not implement authentication or authorization mechanisms.~~

### A-5 Exchange Rates Source
System uses external service as source of truth for currency exchange rates.

### A-6 Exchange Rate Precision
Exchange rates are stored with 6 decimal places precision.

### A-7 Currency Conversion Rounding
🔄 All currency conversions are rounded down to minimal currency unit.

### A-8 Concurrent Transaction Processing
System processes transactions concurrently but guarantees only eventual consistency for reference ID uniqueness check.

### A-9 Transaction Order Guarantee
System guarantees sequential processing of transactions within a single ledger through event streaming architecture.

### A-10 Reference ID Deduplication
⚠️ [To be considered: time window vs infinite history for reference ID uniqueness]

### A-11 Read/Write Operations Ratio
System assumes read operations significantly outnumber write operations with an estimated 10:1 ratio.

### A-12 Query Patterns
System assumes a majority of queries target recent data (last 24-48 hours) with historical queries being less frequent but spanning longer time periods.

### A-13 Write Operation Distribution
System assumes write operations have consistent distribution with occasional peaks during business hours.

### A-14 Peak Load Patterns
System assumes regional peak loads during business hours and potential periodic high-load intervals during batch operations.

### A-15 System Scope - Reporting
System focuses on transaction processing and balance querying operations. Reporting functionality is out of scope for the current implementation.

### A-16 Currency Display Format
System provides amounts in minor currency units (e.g., cents). Display formatting is handled by clients.

### A-17 Projection Rebuild
System does not provide projection rebuild capability. All projections are built from incoming events only.

### A-18 Ledger System Boundaries
System operates as a record-keeping service only. Fund operations (add/subtract) represent recorded events, not actual financial transactions. No integration with external financial systems is provided or required.

### A-19 Ledger Isolation
Ledgers are isolated entities with no direct fund transfer capabilities between them. Each ledger maintains its own independent balance tracking. Cross-ledger operations are out of scope for the current implementation.

### A-20 Transaction Listing
System does not provide transaction listing functionality. Paginated transaction history and scanning capabilities are out of scope for the current implementation.


