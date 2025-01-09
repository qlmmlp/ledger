# ADR 5: Event Streaming Processing

## Status
Accepted

## Context
The system requires reliable event processing with guaranteed ordering within each ledger while maintaining high throughput. Concurrent access patterns must be managed at the event streaming level to ensure system consistency.

## Challenges
- Need to maintain event order within ledger boundaries
- Managing concurrent access patterns at stream level
- Need to handle potential duplicate events from retries
- Requirement to scale processing while preserving order
- Recovery from processing failures
- Clear separation between stream-level and database-level consistency

## Decision
Event streaming processing is implemented utilizing Redis Streams with natural ordering capabilities and explicit concurrency control.

### Concurrency Management
- Event stream handles all concurrent access patterns
- Ledger-based stream partitioning ensures ordered processing
- No reliance on database-level concurrency control
- Clear separation from database transaction management

### Processing Guarantees
- Events are processed exactly once through idempotency checks
- Processing order maintained at stream level
- Transaction boundaries remain independent of stream processing
- Failed events handled through dedicated error channel

### Implementation Strategy
- Redis Streams provide natural event ordering
- Consumer groups manage event distribution
- Processing status tracked per event
- Ledger-based stream partitioning for scaling
- Dedicated dead-letter queue for failed events

## Consequences

### Positive
- Clear separation of concurrency concerns
- Reliable event processing
- Maintained data consistency
- Clear processing guarantees
- Scalable event handling
- Independent scaling of stream processing

### Negative
- Complex stream management requirements
- Need to handle stream-level failures
- Additional complexity when scaling across processors
- More complex testing scenarios required
- Separate monitoring needed for stream processing

## Implementation Notes
- Redis Streams handle all concurrent access patterns
- Database transactions remain focused on data consistency
- Processing status maintained for recovery scenarios
- Stream affinity maintained per ledger
- Clear separation between stream and transaction error handling

## References

### Requirements
- [NFR-2.2 Database Transaction Management](../requirements/non-functional-requirements.md#nfr-22-database-transaction-management)
- [NFR-2.5 Data Consistency](../requirements/non-functional-requirements.md#nfr-25-data-consistency)
- [NFR-3.2 Architectural Pattern](../requirements/non-functional-requirements.md#nfr-32-architectural-pattern)

### Related ADRs
- [ADR-1: Event Sourcing and CQRS Implementation](ADR-1.md)
- [ADR-2: Two-tier Storage Strategy](ADR-2.md)
- [ADR-4: Asynchronous API Pattern](ADR-4.md)