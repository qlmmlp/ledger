# ADR 9: Read-Optimized Projections

## Status
Accepted

## Context
The system needs to provide fast access to current balances and transaction data while handling high volume of transactions and maintaining consistency with the event log.

## Challenges
- Need for high-performance read operations
- Balance between read performance and consistency
- Real-time aggregation of transaction data
- Management of projection states
- Scaling of read operations
- Serving asynchronous API requests efficiently

## Decision
Read-optimized projections are implemented in Redis to support query operations.

### Projection Types Examples
- Balance projections
- Transaction history
- Operation status
- Aggregated views

### Consistency Model
- Eventually consistent with event log
- Clear consistency boundaries
- Projections are updated through domain events
- Async API responses served from projections
- Infrastructure events trigger projection updates

## Consequences

### Positive
- Improved query performance
- Scalable read operations
- Flexible view models
- Optimized data access
- Better user experience
- Reduced load on primary storage
- Fast async API responses

### Negative
- Eventually consistent data
- Projection maintenance overhead
- More complex system state
- Additional failure scenarios to handle

## Implementation Notes
- Projections are stored in Redis
- Each projection is updated through event handlers
- Inconsistency detection is implemented
- Projection health is monitored
- Only forward event processing is supported
- Async API endpoints use projections for responses

## References

### Requirements
- [NFR-2.3 Data Storage](../requirements/non-functional-requirements.md#nfr-24-data-storage)
- [NFR-3.2 Architectural Pattern](../requirements/non-functional-requirements.md#nfr-32-architectural-pattern)

### Related ADRs
- [ADR-1: Event Sourcing and CQRS Implementation](ADR-1.md)
- [ADR-2: Two-tier Storage Strategy](ADR-2.md)
- [ADR-4: Asynchronous API Pattern](ADR-4.md)
- [ADR-7: Event Types Architecture](ADR-7.md)