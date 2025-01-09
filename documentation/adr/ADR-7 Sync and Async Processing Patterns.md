# ADR 7: Sync and Async Processing Patterns

## Status
Proposed (Supersedes Event Types Architecture)

## Context
System operations can be categorized into two fundamental types based on their processing requirements: synchronous operations that must be processed immediately within the request scope, and asynchronous operations that can be queued for later processing.

## Challenges
- Need to separate immediate processing from background tasks
- Clear criteria for sync vs async processing
- Maintaining system responsiveness
- Managing operation state transitions
- Appropriate error handling for each pattern
- Clear processing guarantees per type

## Decision
Implementation of two distinct processing patterns:

### Synchronous Processing
- Executed immediately within request scope
- Used for validation and immediate state checks
- Provides direct response to client
- Maintains transactional consistency where required

### Asynchronous Processing
- Operations queued in Redis for background processing
- Processed by dedicated workers
- Eventually consistent
- Allows for retries and failure handling
- State tracking only for composite operations (like exchange)

## Consequences

### Positive
- Clear separation of processing patterns
- Improved system responsiveness
- Simplified error handling strategies
- Better resource utilization
- Clear operation state management
- Easy to monitor and debug

### Negative
- Must handle eventual consistency
- More complex testing scenarios
- Additional complexity for composite operations tracking

## Implementation Notes
- Redis used for async operation queues
- Database tracks operation status
- Clear state transitions defined
- Proper error handling for each pattern
- Monitoring and health checks implemented

## References

### Requirements
- [NFR-3.2 Architectural Pattern](../requirements/non-functional-requirements.md#nfr-32-architectural-pattern)
- [NFR-3.10 Inter-Module Communication](../requirements/non-functional-requirements.md#nfr-310-inter-module-communication)

### Related ADRs
- [ADR-1: Database State and Queue-Based Processing](ADR-1%20Database%20State%20and%20Queue-Based%20Processing.md)
- [ADR-3: Modular Monolith Design](ADR-3%20Modular%20Monolith%20Design.md)
- [ADR-4: Asynchronous API Pattern](ADR-4%20Asynchronous%20API%20Pattern.md)