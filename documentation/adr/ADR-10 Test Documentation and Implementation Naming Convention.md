# ADR 10: Test Documentation and Implementation Naming Convention

## Status
Proposed

## Context
The system requires a consistent, clear, and maintainable approach to both test documentation and implementation. The naming convention should provide clear traceability between use cases, test case documentation, and actual test implementations while maintaining readability and searchability.

## Challenges
- Need for clear traceability between use cases and test cases
- Consistency across documentation and implementation
- Clear communication of test purpose and expectations
- Support for different types of tests (unit, integration, functional)
- Easy identification of test coverage gaps
- Clear distinction between similar test scenarios
- Maintainability of test documentation

## Decision
Implementation of a standardized test naming convention across both documentation and implementation.

### Test Case Documentation Naming
1. File Naming Pattern:
   ```
   TC-{Module}.{UseCase}.{Scenario} {Action} {Condition}
   ```
   Examples:
   - TC-LD.1.1 Create Ledger Succeeds
   - TC-LD.1.2 Create Ledger Fails When No Currency Provided
   - TC-TR.2.1 Convert Funds Succeeds With Partial Amount

2. Components:
   - Module: Two-letter module identifier (e.g., LD for Ledger, TR for Transaction)
   - UseCase: Maps directly to use case number
   - Scenario: Hierarchical index (e.g., 1.1, 1.2.1) allowing for:
      * Main scenarios (1, 2, 3)
      * Variations (1.1, 1.2, 1.3)
      * Sub-variations (1.1.1, 1.1.2)
      * Later insertions (1.2.1 can be added between 1.2 and 1.3)
   - Action: Clear verb describing the operation
   - Condition: Describes specific scenario conditions (when needed)

### Test Implementation Naming
1. Method Naming Pattern:
   ```
   test[Action][Scenario][ExpectedOutcome]
   ```
   Examples:
   ```
   testCreateLedgerSucceedsWithSingleCurrency
   testCreateLedgerThrowsExceptionWhenCurrencyListEmpty
   testConvertFundsSucceedsWithPartialAmount
   ```

2. Components:
   - Prefix: Always 'test'
   - Action: Clear verb describing the operation
   - Scenario: Specific test conditions
   - ExpectedOutcome: Expected behavior (succeeds, throwsException, etc.)

### Mapping Convention
Test implementation methods should include a reference to their corresponding test case documentation:
```php
/**
 * @testCase TC-LD.1.1
 */
public function testCreateLedgerSucceedsWithSingleCurrency()
```

## Consequences

### Positive
- Clear traceability between use cases and test cases
- Consistent naming across documentation and implementation
- Self-documenting test purposes
- Easy navigation between documentation and implementation
- Improved test coverage tracking
- Better maintainability
- Clear test organization structure

### Negative
- More detailed documentation required
- Additional maintenance overhead
- Stricter naming requirements
- Need for team training on conventions

## Implementation Notes
- Create template for test case documentation
- Implement documentation validation checks
- Add test case references to code coverage reports
- Include mapping validation in CI/CD pipeline
- Maintain index of test cases with use case mapping

## References

### Requirements
- [NFR-4.1 Test Coverage Types](../requirements/non-functional-requirements.md#nfr-41-test-coverage-types)
- [NFR-4.2 Critical Test Areas](../requirements/non-functional-requirements.md#nfr-42-critical-test-areas)
- [NFR-4.4 Test Documentation](../requirements/non-functional-requirements.md#nfr-44-test-documentation)

### Related ADRs
- [ADR-3: Modular Monolith Design](ADR-3.md)