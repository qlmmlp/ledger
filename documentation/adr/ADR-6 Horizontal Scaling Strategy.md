# ADR 6: Horizontal Scaling Strategy

## Status
Pending

## Context
Transaction volume growth beyond initial requirement of 1000 transactions per minute must be supported while maintaining system performance under load. Processing capacity must be adjustable without architectural changes.

## Challenges
- Need to maintain processing order within ledgers while scaling
- Optimal resource utilization across processing units
- Processing capacity adjustment without downtime
- Recovery from processing unit failures
- Monitoring of distributed processing
- Balance between processing throughput and operational complexity

## Decision
Horizontal scaling is implemented through stream-based distribution of processing.

### Scaling Strategy
- Processing is distributed across parallel streams
- Number of processing units is configurable at deployment
- Processing capacity is adjusted through stream count
- Each stream operates independently

### Distribution Approach
- Transactions are distributed to streams using deterministic hashing of ledger identifiers
- Processing order is guaranteed within each stream
- Processing units are assigned to streams
- Load is balanced through consistent hashing algorithm

## Consequences

### Positive
- Linear scalability is achieved
- Resource utilization is optimized
- System throughput is improved
- Processing capacity is adjusted flexibly
- Fault isolation is maintained
- Transaction order is preserved within ledgers
- No cross-stream coordination is required

### Negative
- Operational complexity is increased
- Deployment complexity is introduced
- Additional monitoring is required
- Resource overhead is added
- Stream re-balancing must be managed

## Implementation Notes
- Stream count is configured at deployment time
- Stream health monitoring is implemented
- Stream failures are handled gracefully
- Transaction distribution is managed through consistent hashing
- Processing metrics are maintained per stream
- Automated recovery procedures are implemented
- Stream re-balancing is performed during scaling operations

## References

### Requirements
- [NFR-1.1 Transaction Throughput](../requirements/non-functional-requirements.md#nfr-11-transaction-throughput)
- [NFR-3.11 Scaling](../requirements/non-functional-requirements.md#nfr-311-scaling)

### Assumptions
- [A-8 Concurrent Transaction Processing](../requirements/assumptions.md#a-8-concurrent-transaction-processing)
- [A-9 Transaction Order Guarantee](../requirements/assumptions.md#a-9-transaction-order-guarantee)

### Related ADRs
- [ADR-1: Database State and Queue-Based Processing](ADR-1%20Database%20State%20and%20Queue-Based%20Processing.md)
- [ADR-4: Asynchronous API Pattern](ADR-4.md)
- [ADR-5: Event Streaming Processing](ADR-5.md)