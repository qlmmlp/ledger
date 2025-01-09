# ADR 4: Asynchronous API Pattern

## Status
Accepted

## Context
A complex transaction processing flow with high throughput requirements (1000 transactions per minute) necessitates separation of user interaction from actual processing.

## Challenges
- Need to handle complex processing flows without impacting user experience
- High volume transaction processing requirements
- Balance between immediate feedback and reliable processing
- Management of long-running operations
- Need to minimize user-facing computation time
- Resource utilization optimization
- Maintaining transaction order guarantees within ledger
- Handling duplicate transaction detection

## Decision
An asynchronous API pattern is implemented with strict separation between synchronous validation and asynchronous processing.

### API Flow
- Request validation is performed synchronously with minimal computation
- Operation identifier is generated and returned immediately
- All substantial processing is moved to asynchronous mode
- Operation status is tracked through a dedicated endpoint
- Final results are made available through status endpoint
- Sequential processing is guaranteed within each ledger

### Status Tracking
- Operation status endpoint is provided
- Clear status transition states are defined
- Final operation result or failure reason is tracked
- Status information lifetime is managed
- Duplicate operations are detected and handled appropriately

## Consequences

### Positive
- Enhanced user experience through immediate response
- Improved system scalability via parallel processing
- Efficient handling of high-volume operations
- Retry mechanism implementation capability
- Clear operation status visibility
- Controlled resource utilization
- Separated concerns between validation and processing
- Guaranteed processing order within ledgers

### Negative
- Increased client implementation complexity
- Eventual consistency handling required
- Additional status checking endpoint needed
- Enhanced error handling complexity required
- Status cleanup management overhead
- Need for duplicate operation handling

## Implementation Notes
- Redis is utilized for operation status storage
- Clear status transition states are defined
- Detailed error information is provided
- Status cleanup mechanism is implemented with configurable retention period
- Only validation and minimal computation is allowed in synchronous flow
- All substantial processing is performed asynchronously
- Status updates are provided through event-driven mechanism
- Ledger-specific sequential processing is enforced
- Deduplication mechanism is implemented based on operation IDs

## References

### Requirements
- [NFR-1.1 Transaction Throughput](../requirements/non-functional-requirements.md#nfr-11-transaction-throughput)
- [NFR-3.1 API Style](../requirements/non-functional-requirements.md#nfr-31-api-style)
- [NFR-3.7 Operation Status Tracking](../requirements/non-functional-requirements.md#nfr-37-operation-status-tracking)

### Assumptions
- [A-8 Concurrent Transaction Processing](../requirements/assumptions.md#a-8-concurrent-transaction-processing)
- [A-9 Transaction Order Guarantee](../requirements/assumptions.md#a-9-transaction-order-guarantee)
- [A-10 Reference ID Deduplication](../requirements/assumptions.md#a-10-reference-id-deduplication)

### Related ADRs
- [ADR-1: Event Sourcing and CQRS Implementation](ADR-1.md)
- [ADR-2: Two-tier Storage Strategy](ADR-2.md)
- [ADR-5: Event Streaming Processing](ADR-5.md)