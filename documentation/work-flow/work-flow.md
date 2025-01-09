# System Workflows

## WF-1: Create Ledger
```
Request received
→ Validate input
→ Persist to database
→ Create initial projections
→ Return ledger ID
```

## WF-2: Add Funds
```
Request received
→ Validate basic input
→ Generate transactionId
→ Persist to database
→ Update projections
→ Queue operation in Redis
→ Return transactionId

Worker processing:
→ Pick up from queue
→ Process ledger entry
→ Update operation status
```

## WF-3: Subtract Funds
```
Request received
→ Validate basic input
→ Generate transactionId
→ Persist to database
→ Update projections
→ Queue operation in Redis
→ Return transactionId

Worker processing:
→ Pick up from queue
→ Verify sufficient funds
→ Process ledger entry
→ Update operation status
```

## WF-4: Query Ledger
```
Request received
→ Return data from projections
```

## WF-5: Query Transaction Status
```
Request received
→ Validate transactionId
→ Return operation status from Redis
```

## System States

### Ledger Entries
- Immutable records once written

### Operation Status
- PENDING: Initial state after validation
- COMPLETED: Operation processed
- FAILED: Operation failed

## Implementation Notes

### Processing Guarantees
- Operations processed in order within each ledger
- Projections eventually consistent with database state
- Operation status available immediately after queuing

## References

### Requirements
- [FR-1 Ledger Management](../requirements/functional-requirements.md#fr-1-ledger-management)
- [FR-2 Transaction Processing](../requirements/functional-requirements.md#fr-2-transaction-processing)
- [FR-3 Balance Management](../requirements/functional-requirements.md#fr-3-balance-management)

### Related ADRs
- [ADR-1: Database State and Queue-Based Processing](ADR-1.md)
- [ADR-4: Asynchronous API Pattern](ADR-4.md)
- [ADR-7: Sync and Async Processing Patterns](../adr/ADR-7 Sync and Async Processing Patterns.md)