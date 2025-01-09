# Multi-Currency Ledger Service

## Objective
Develop a basic yet robust multi-currency ledger service using Symfony. The service should be capable of handling up to 1,000 transactions per minute, with functionality to manage multiple ledgers, process transactions (both debits and credits), and accurately report balances in real time.

---
## Core Requirements

### 1.a Symfony Framework
Use Symfony as the primary framework.

### 1.b PHP Version
Implement the application with PHP v8.3.

### 1.c Docker Implementation
Ensure the service is containerized using Docker for easy deployment and scalability.

### 2.a Ledger Management
Create a new ledger with a unique identifier and initial currency setting.

### 2.b Transaction Processing
Record a new transaction in the specified ledger. This endpoint should accept details like ledger ID, transaction type (debit/credit), amount, currency, and a unique transaction ID.

### 2.c Balance Query
Retrieve the current balance of a specified ledger. This should return all currency balances if multiple currencies are supported.

### 3.a Database Schema
Design a schema that supports multi-currency transactions. Consider using a relational database like PostgreSQL for ACID compliance.

### 3.b Transaction Safety
Implement DB level transactional integrity to ensure that all financial transactions are processed reliably.

### 4.a Performance Goals
Demonstrate the application's ability to handle up to 1,000 transactions per minute.

### 4.b Test Coverage
Include unit tests and integration tests to validate the business logic and API endpoints.

### 4.c Error Management
Use appropriate logging and error-handling mechanisms to ensure service reliability and maintainability.

### 5.a System Documentation
Provide a README file with setup instructions, API usage examples, and a brief discussion of the architecture.

### 5.b API Documentation
Document the API endpoints using OpenAPI (Swagger) for easy testing and integration.

---
## Bonus Challenges

### B.1 Research Documentation
Include a dev research document which describes the solution and can be used by QA and product team.

### B.2 Multi-Currency Features
Implement multi-currency support where transactions can be recorded in different currencies based on the ledger settings.

### B.3 Currency Exchange
Add functionality to convert between currencies using a mock external currency conversion API.

### B.4 Rate Limiting
Include rate limiting to prevent abuse of the service API.

### B.5 Cloud Operations
Deploy the application on a cloud provider.

---
## Evaluation Criteria

### E.1 Code Standards
Code quality and organisation.

### E.2 API Best Practices
Adherence to modern best practices in API design and security.

### E.3 Database Optimization
Efficiency of database use and query optimization.

### E.4 Documentation Quality
Clarity and usefulness of documentation.

### E.5 System Architecture
Scalability and robustness of the implementation.
