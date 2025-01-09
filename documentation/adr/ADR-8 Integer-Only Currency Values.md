# ADR 8: Integer-Only Currency Values

## Status
Accepted

## Context
Financial calculations in the system require absolute precision, with avoidance of any floating-point arithmetic errors that could lead to monetary discrepancies.

## Challenges
- Prevention of calculation errors in financial operations
- Maintenance of precise monetary values
- Support for different currency denominations
- Protection from floating-point precision issues

## Decision
Integer-only values for currency amounts are implemented.

### Implementation Strategy
- Amounts are stored as integers in minor currency units (e.g., cents)
- Calculations are performed using integer arithmetic only
- Currency metadata is defined with minor unit information

### Calculation Rules
- All operations are performed in minor units
- Only credit and debit operations are supported
- No fractional amounts are allowed

## Consequences

### Positive
- Absolute precision in calculations is guaranteed
- Floating-point errors are eliminated
- Arithmetic operations are simplified
- Financial operations are reliable
- Audit requirements are satisfied

### Negative
- Input validation for integer constraints is needed

## Implementation Notes
- Integer arithmetic is enforced at type level

## References

### Requirements
- [NFR-2.1 Amount Handling](../requirements/non-functional-requirements.md#nfr-21-amount-handling)

### Assumptions
- [A-3 Currency Denomination](../requirements/assumptions.md#a-3-currency-denomination)
- [A-16 Currency Display Format](../requirements/assumptions.md#a-16-currency-display-format)

### Related ADRs
- [ADR-1: Event Sourcing and CQRS Implementation](ADR-1.md)
- [ADR-2: Two-tier Storage Strategy](ADR-2.md)