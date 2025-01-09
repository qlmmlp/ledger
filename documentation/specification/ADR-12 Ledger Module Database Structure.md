# ADR 12: Ledger Module Database Structure

## Status
Proposed

## Context
The Ledger module requires a reliable database structure to serve as the source of truth for financial calculations and records. The database must ensure ACID compliance for all operations while maintaining a clear and maintainable structure that supports double-entry bookkeeping principles and multi-currency operations.

## Challenges
- Supporting double-entry bookkeeping principles
- Maintaining ACID compliance for financial calculations
- Handling multiple currencies per ledger
- Ensuring data model clarity and maintainability
- Providing reliable source of truth for financial state
- Managing currency reference data

## Decision
Implementation of a PostgreSQL schema based on four core entities representing ledgers, currencies, their relationships, and entries.

### Core Entities and Relationships

#### Currency
Reference data for supported currencies:
- Currency code (ISO 4217) as primary key
- Name
- Minor unit (e.g., 2 for USD/EUR, represents number of decimal places)
- Status (enum: ACTIVE, INACTIVE)

#### Ledger
Core entity representing a set of financial records:
- Unique identifier
- Status (enum: PENDING, ACTIVE, ERROR)
- Temporal tracking

#### LedgerToCurrency
Maps supported currencies to ledgers:
- Composite primary key (ledger_id, currency_code)
- References both Ledger and Currency
- Controls which currencies can be used in ledger entries

#### LedgerEntry
Records financial entries following double-entry principle:
- Unique identifier
- Reference to ledger
- Reference to currency
- Amount in minor currency units
- Entry type (enum: DEBIT, CREDIT)
- Reference ID for idempotency
- Temporal tracking

### Key Design Decisions

1. **Complete Currency Management**
- Centralized currency reference data
- Clear currency status management
- Proper handling of currency precision through minor unit

2. **Simple Core Structure**
- Four focused entities with clear responsibilities
- Direct relationships with strong referential integrity
- Currency support managed through mapping table

3. **Currency Handling**
- Currency references validated against Currency table
- Available currencies controlled through mapping table
- Minor units enforced through Currency definition

4. **Double-Entry Implementation**
- Each financial operation requires balanced debit and credit entries
- All entries reference source ledger and valid currency
- ACID compliance ensures consistency of related entries

## Consequences

### Positive
- Guaranteed ACID compliance for financial calculations
- Clean, minimal structure focusing on essential ledger concepts
- Centralized currency management
- Strong referential integrity
- Simple to understand and maintain
- Proper handling of currency properties

### Negative
- Need to maintain currency reference data
- All entries must handle currency reference
- Currency constraint checks required for entries

## References

### Requirements
- [NFR-2.1 Amount Handling](../requirements/non-functional-requirements.md#nfr-21-amount-handling)
- [NFR-2.2 Database Transaction Management](../requirements/non-functional-requirements.md#nfr-22-database-transaction-management)

### Assumptions
- [A-3 Currency Denomination](../requirements/assumptions.md#a-3-currency-denomination)

### Related ADRs
- [ADR-8: Integer-Only Currency Values](ADR-8.md)