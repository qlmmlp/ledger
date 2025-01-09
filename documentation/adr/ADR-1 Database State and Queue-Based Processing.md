# ADR 1: Database State and Queue-Based Processing

## Status
Proposed (Supersedes previous Event Sourcing ADR)

## Context
The system needs to handle high-volume financial transactions while maintaining complete audit trail and ensuring data consistency. The business requires near real-time balance updates and historical transaction tracking. Direct database is used for a state management with queue-based async processing.

## Challenges
- Complex financial processing flows that evolve over time require extensible architecture
- Need to separate transactional consistency from asynchronous processing
- Multiple data access patterns cannot be efficiently served by a single data model
- Requirements for both real-time balance updates and complete historical audit trail
- Need to handle high load on read operations without impacting write consistency

## Decision
Implementation of CQRS (Command Query Responsibility Segregation) with queue-based async processing:

### Database as Source of Truth
- PostgreSQL maintains the authoritative system state
- All ledger entries preserved as immutable historical record
- Database transactions ensure ACID compliance for state changes
- Complete audit trail through ledger entries table
- Operation state tracked in dedicated status tables
- Read models maintained through database views

### Queue-Based Processing
- Redis lists used for FIFO operation queues
- Separate queue per ledger to maintain processing order
- Operation status tracked in dedicated database tables
- Clear state transitions: PENDING → PROCESSING → COMPLETED
- Failed operations handled through dedicated error queues
- Sequential processing guaranteed through queue isolation

### CQRS Implementation
- Separate write and read operations at the architectural level
- Write operations:
  - Validate and enqueue operations
  - Process through worker services
  - Execute database transactions for state changes
  - Maintain proper transaction isolation levels
  - Trigger projection updates
- Read operations:
  - Served from read-optimized projections in Redis
  - No database transaction requirements
  - Eventually consistent with write operations
- Projections:
  - Maintained asynchronously by dedicated workers
  - Store aggregated/denormalized data for fast reads
  - Include balance snapshots, transaction summaries
  - Support efficient API response generation
  - Rebuilt from database state if needed

### Transaction Boundaries
- Database transactions only initiated for state-changing operations
- Clear separation between queue processing and database transactions
- Queue processing may trigger multiple database transactions
- Database transactions scoped to minimal necessary operations

## Consequences

### Positive
- Simpler architecture without event sourcing complexity
- Complete audit trail through database history
- Clear separation of concerns between processing and storage
- Improved query performance through specialized read models
- Better scalability by separating read and write concerns
- Natural fit for the financial domain where transaction history is crucial
- Independent scaling of queue processing and database operations

### Negative
- Need to manage queue processing state
- Eventually consistent read models
- Must handle queue processing failures
- Additional operational overhead for queue management

## Implementation Notes
- Queue processing implemented using Redis lists and pub/sub
- Database transactions explicitly managed in service layer
- Queue processors designed for idempotent processing
- Clear separation between queue processing and database operations
- Proper error handling for both queue and transaction failures
- Read models updated through database triggers or background jobs

## References

### Requirements
- [NFR-2.2 Database Transaction Management](../requirements/non-functional-requirements.md#nfr-22-database-transaction-management)
- [NFR-2.3 Transaction Isolation](../requirements/non-functional-requirements.md#nfr-23-transaction-isolation)
- [NFR-2.5 Data Consistency](../requirements/non-functional-requirements.md#nfr-25-data-consistency)
- [NFR-3.2 Architectural Pattern](../requirements/non-functional-requirements.md#nfr-32-architectural-pattern)

### Related ADRs
- [ADR-2: Two-tier Storage Strategy](ADR-2%20Modular%20Monolith%20Design.md)
- [ADR-4: Asynchronous API Pattern](ADR-4%20Asynchronous%20API%20Pattern.md)