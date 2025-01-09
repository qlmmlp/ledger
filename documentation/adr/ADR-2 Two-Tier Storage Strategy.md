# ADR 2: Two-Tier Storage Strategy

## Status
Accepted

## Context
The system requires both high transaction processing rates and strict ACID compliance for financial operations. Implementing these requirements with a single storage solution would increase complexity and limit system extensibility. A separation of concerns in storage allows optimization of read operations while maintaining strong consistency for state-changing computations.

## Challenges
- Need to maintain ACID compliance for financial calculations
- High volume of read operations requiring optimization
- Requirement for near real-time balance information
- System state must be recoverable and verifiable
- Storage strategy must support future system extensions
- Clear transaction boundaries and isolation levels needed

## Decision
A two-tier storage strategy is implemented:
- Redis for event streams and read-optimized projections
- PostgreSQL for ACID-compliant state computations

### Redis Usage
- Store event streams with persistence enabled
- Maintain read-optimized projections
- Cache frequently accessed data
- Support near real-time query capabilities
- Maintain temporary operation states

### PostgreSQL Usage
- Execute ACID-compliant state computations with explicit transaction boundaries
- Process financial calculations under SERIALIZABLE isolation
- Handle non-critical operations under READ COMMITTED isolation
- Store system configuration and metadata
- Maintain transaction consistency guarantees

### Transaction Management
- Database transactions initiated only for state-changing computations
- Transaction boundaries explicitly defined in service layer
- Appropriate isolation levels applied based on operation type
- Minimal transaction scope to reduce lock contention
- Clear error handling and rollback procedures

## Consequences

### Positive
- High-performance read operations through Redis
- Strong consistency for financial calculations in PostgreSQL
- Ability to rebuild read projections when needed
- Scalable query performance
- Clear separation of computation and query concerns
- ACID compliance for all state-changing operations
- Explicit transaction handling

### Negative
- Increased system complexity
- Need to handle data synchronization
- Additional operational overhead
- Management of two database systems
- Need for careful transaction boundary management

## Implementation Notes
- An abstract infrastructure module provides a framework for:
  - Building and maintaining read projections
  - Managing data flow between storage tiers
  - Handling projection rebuilds
- PostgreSQL transaction management:
  - SERIALIZABLE isolation for financial operations
  - READ COMMITTED for non-critical operations
  - Explicit transaction boundaries in service layer
  - Proper error handling and rollback procedures
- Redis is configured with AOF persistence in 'always' fsync mode for event stream durability
- Projection rebuilds are supported for read models while event streams in Redis remain persistent
- Database access is limited to actual state-changing business events

## References

### Requirements
- [NFR-1.1 Transaction Throughput](../requirements/non-functional-requirements.md#nfr-11-transaction-throughput)
- [NFR-2.2 Database Transaction Management](../requirements/non-functional-requirements.md#nfr-22-database-transaction-management)
- [NFR-2.3 Transaction Isolation](../requirements/non-functional-requirements.md#nfr-23-transaction-isolation)
- [NFR-2.4 Data Storage](../requirements/non-functional-requirements.md#nfr-24-data-storage)
- [NFR-2.5 Data Consistency](../requirements/non-functional-requirements.md#nfr-25-data-consistency)

### Assumptions
- [A-11 Read/Write Operations Ratio](../requirements/assumptions.md#a-11-readwrite-operations-ratio)
- [A-12 Query Patterns](../requirements/assumptions.md#a-12-query-patterns)
- [A-13 Write Operation Distribution](../requirements/assumptions.md#a-13-write-operation-distribution)

### Related ADRs
- [ADR-1: Event Sourcing and CQRS Implementation](ADR-1.md)
- [ADR-9: Read-Optimized Projections](ADR-9.md)