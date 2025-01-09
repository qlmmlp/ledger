### NFR-1 Performance and Scalability

### NFR-1.1 Transaction Throughput
System shall handle 1,000 transactions per minute under normal operation.
Reference: [4.a Performance Goals](business-requirements.md#4a-performance-goals)

# NFR-2 Data Management

### NFR-2.1 Amount Handling
System shall operate only with integer values representing minimal currency nominations (e.g., cents for USD/EUR).
Reference: [3.b Transaction Safety](business-requirements.md#3b-transaction-safety)

### NFR-2.2 Database Transaction Management
System shall implement proper database transaction management:
- Ensure ACID compliance for all database operations
- Apply appropriate isolation levels based on operation type
- Handle transaction rollback scenarios
- Manage transaction boundaries explicitly
- Implement proper error handling within transactions
  Reference: [3.b Database Transactional Integrity](business-requirements.md#3b-transaction-safety)

### NFR-2.3 Transaction Isolation
System shall implement appropriate transaction isolation levels:
- Use SERIALIZABLE for financial calculations
- Use READ COMMITTED for non-critical operations
- Prevent phantom reads in financial operations
  Reference: [3.b Database Transactional Integrity](business-requirements.md#3b-transaction-safety)

### NFR-2.4 Data Storage
System shall implement two-tier storage strategy:
- Fast storage tier for event processing and current state
- Persistent storage tier for transaction processing and history

Reference: [3.a Database Schema](business-requirements.md#3a-database-schema), [ADR-2: Two-tier Storage Strategy](../adr/ADR-2.md)

### NFR-2.5 Data Consistency
System shall ensure data consistency through:
- Proper transaction boundaries
- Consistent state transitions
- Atomic operations when required
- Event stream consistency
  Reference: [3.b Database Transactional Integrity](business-requirements.md#3b-transaction-safety)

### NFR-3 System Architecture

### NFR-3.1 API Style
System shall implement asynchronous API:
- Return accepted status immediately after validation
- Provide operation identifier for status tracking
  Reference: [4.a Performance Goals](business-requirements.md#4a-performance-goals)

### NFR-3.2 Architectural Pattern
System shall implement Event Sourcing and CQRS (Command Query Responsibility Segregation) patterns:
- Commands shall be processed through event streaming
- Queries shall be served from read-optimized projections
  Reference: [3.b Transaction Safety](business-requirements.md#3b-transaction-safety)

### NFR-3.3 Event Store
System shall use Redis for:
- Storing immutable event logs
- Maintaining read-optimized projections
  Reference: [3.a Database Schema](business-requirements.md#3a-database-schema)

### NFR-3.4 Transactional Database
System shall use PostgreSQL for:
- ACID-compliant financial calculations
- Maintaining consistent transaction state
- Managing system state with ACID guarantees
  Reference: [3.a Database Schema](business-requirements.md#3a-database-schema)

### NFR-3.5 State Management
System shall maintain:
- Event log as the source of truth for all transactions
- Read models updated asynchronously based on events
- Eventual consistency between event store and read models
  Reference: [3.b Transaction Safety](business-requirements.md#3b-transaction-safety)

### NFR-3.6 Message Processing
System shall guarantee:
- Exactly-once processing of each event
- Sequential processing of events within a ledger
  Reference: [3.b Transaction Safety](business-requirements.md#3b-transaction-safety)

### NFR-3.7 Operation Status Tracking
System shall provide:
- Operation status endpoint
- Clear status transition states
- Final operation result or failure reason
  Reference: [4.c Error Management](business-requirements.md#4c-error-management)

### NFR-3.8 Application Structure
System shall be designed as a modular monolith where:
- Each module represents a bounded context
- Modules communicate through well-defined interfaces
- Public API is annotated in module facades
  Reference: [1.a Symfony Framework](business-requirements.md#1a-symfony-framework)

### NFR-3.9 Event Types
System shall support three types of events:
- Domain Events
- Async Infrastructure Events
- Sync Infrastructure Events

Reference: [ADR-7: Event Types Architecture](../adr/ADR-7.md)

Reference: [3.b Transaction Safety](business-requirements.md#3b-transaction-safety)

### NFR-3.10 Inter-Module Communication
System shall enforce communication between modules through:
- Direct Module FACADE calls (using interfaces with public API annotation)
- Defined set of global or local events
  Reference: [1.a Symfony Framework](business-requirements.md#1a-symfony-framework)

### NFR-3.11 Scaling
System shall support parallel processing where:
- Number of parallel streams is configured at deployment time
- Each stream can process transactions independently
- Ledgers are distributed across available streams
  Reference: [4.a Performance Goals](business-requirements.md#4a-performance-goals)

### NFR-4 Testing Requirements

### NFR-4.1 Test Coverage Types
System test suite shall include:
- End-to-end tests for critical business flows
- Performance tests for throughput validation
  Reference: [4.b Test Coverage](business-requirements.md#4b-test-coverage)

### NFR-4.2 Critical Test Areas
System shall maintain complete test coverage for:
- Financial calculations
- Database transactions
  Reference: [4.b Test Coverage](business-requirements.md#4b-test-coverage)

### NFR-4.3 Test Environment
System shall provide:
- Automated test environment setup
- Mock external services
- Test data generators
  Reference: [4.b Test Coverage](business-requirements.md#4b-test-coverage)

### NFR-4.4 Test Documentation
System shall maintain:
- Test scenarios documentation
- Test data specifications
- Test environment guides
  Reference: [5.a System Documentation](business-requirements.md#5a-system-documentation)