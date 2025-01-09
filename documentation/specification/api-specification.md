# Multi-Currency Ledger API Documentation

## Create Ledger
`POST /ledgers`

Creates a new ledger with specified supported currencies.

### Rate Limit
10 requests per minute

### Request
```json
{
  "currencies": ["USD", "EUR", "GBP"]  // List of currency codes
}
```

### Responses

#### 201 Created
Ledger created successfully.
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "status": "ACTIVE",
  "balances": [
    {
      "currency": "USD",
      "amount": 0,
      "lastUpdated": "2024-01-05T12:00:00Z"
    }
  ],
  "lastUpdated": "2024-01-05T12:00:00Z"
}
```

#### 400 Bad Request
Input validation failed:
- EMPTY_CURRENCY_LIST: Currency list is empty
- UNSUPPORTED_CURRENCY: One or more currencies are not supported
- DUPLICATE_CURRENCY: Currency list contains duplicates
- INVALID_CURRENCY_FORMAT: Currency code doesn't match ISO 4217 format

#### 429 Too Many Requests
Rate limit exceeded.
```json
{
  "code": "RATE_LIMIT_EXCEEDED",
  "message": "Rate limit exceeded. Please try again in {N} seconds",
  "details": {
    "limitType": "requests_per_minute",
    "currentLimit": 10,
    "resetTime": "2024-01-05T12:01:00Z"
  }
}
```

#### 500 Internal Server Error
System error occurred:
- LEDGER_CREATION_FAILED: System unable to create ledger
- INITIALIZATION_TIMEOUT: Timeout during ledger initialization

## Get Ledger State
`GET /ledgers/{ledgerId}`

Retrieves current state and balances of a ledger.

### Rate Limit
3,000 requests per minute

### Responses

#### 200 OK
Ledger state retrieved successfully.
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "status": "ACTIVE",
  "balances": [
    {
      "currency": "USD",
      "amount": 1000,
      "lastUpdated": "2024-01-05T12:00:00Z"
    }
  ],
  "lastUpdated": "2024-01-05T12:00:00Z"
}
```

#### 404 Not Found
- LEDGER_NOT_FOUND: Specified ledger doesn't exist

#### 429 Too Many Requests
Rate limit exceeded (same format as above)

#### 500 Internal Server Error
- STATE_RETRIEVAL_FAILED: System unable to retrieve ledger state

## Create Transaction
`POST /ledgers/{ledgerId}/transactions`

Initiates a new financial transaction.

### Rate Limit
1,000 requests per minute

### Request

For Credit/Debit:
```json
{
  "type": "CREDIT",           // or "DEBIT"
  "referenceId": "order_payment_123",  // Globally unique identifier
  "amount": 1000,            // Amount in minor currency units
  "currency": "USD"
}
```

For Currency Conversion:
```json
{
  "type": "CONVERT",
  "referenceId": "currency_exchange_456",  // Globally unique identifier
  "sourceCurrency": "USD",
  "targetCurrency": "EUR",
  "amount": 1000            // Amount in source currency minor units
}
```

### Responses

#### 202 Accepted
Transaction accepted for processing.
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",  // System-generated transaction ID
  "referenceId": "order_payment_123",             // Original client reference
  "type": "CREDIT",
  "status": "PENDING",
  "ledgerId": "550e8400-e29b-41d4-a716-446655440000",
  "createdAt": "2024-01-05T12:00:00Z"
}
```

#### 400 Bad Request
Common validations:
- INVALID_AMOUNT: Amount is zero or negative
- INVALID_CURRENCY_FORMAT: Currency code doesn't match ISO 4217 format
- MISSING_REQUIRED_FIELDS: Required fields are not provided
- INVALID_CURRENCY: Specified currency not enabled for this ledger
- INVALID_REFERENCE_ID: The provided referenceId format is invalid

Additional validations for Convert:
- SAME_CURRENCY: Source and target currencies are the same
- INVALID_SOURCE_CURRENCY: Source currency not enabled for this ledger
- INVALID_TARGET_CURRENCY: Target currency not enabled for this ledger

#### 409 Conflict
Duplicate referenceId:
```json
{
  "code": "DUPLICATE_REFERENCE_ID",
  "message": "Transaction with this reference ID already exists",
  "details": {
    "existingTransactionId": "123e4567-e89b-12d3-a456-426614174000",
    "status": "COMPLETED|PENDING|ERROR",
    "submittedAt": "2024-01-05T12:00:00Z",
    "ledgerId": "550e8400-e29b-41d4-a716-446655440000"
  }
}
```

Business rule violations:
- INSUFFICIENT_FUNDS: Not enough balance for debit/convert operation

#### 429 Too Many Requests
Rate limit exceeded (same format as above)

#### 503 Service Unavailable
For Convert transactions:
- EXCHANGE_RATE_UNAVAILABLE: Exchange rate service is temporarily unavailable
- EXCHANGE_RATE_SERVICE_ERROR: Error while communicating with exchange rate service

## Get Transaction Status
`GET /ledgers/{ledgerId}/transactions/{transactionId}`

Retrieves the current status of a transaction.

### Rate Limit
3,000 requests per minute

### Responses

#### 200 OK
Successful transaction:
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "referenceId": "order_payment_123",
  "type": "CREDIT",
  "status": "COMPLETED",
  "ledgerId": "550e8400-e29b-41d4-a716-446655440000",
  "createdAt": "2024-01-05T12:00:00Z",
  "completedAt": "2024-01-05T12:00:01Z"
}
```

Failed transaction:
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "referenceId": "order_payment_123",
  "type": "DEBIT",
  "status": "ERROR",
  "ledgerId": "550e8400-e29b-41d4-a716-446655440000",
  "createdAt": "2024-01-05T12:00:00Z",
  "completedAt": "2024-01-05T12:00:01Z",
  "error": {
    "code": "INSUFFICIENT_FUNDS",
    "message": "Insufficient funds for debit operation",
    "details": {
      "availableAmount": 500,
      "requestedAmount": 1000,
      "currency": "USD"
    }
  }
}
```

#### 404 Not Found
- TRANSACTION_NOT_FOUND: Specified transaction doesn't exist
- LEDGER_NOT_FOUND: Specified ledger doesn't exist

#### 429 Too Many Requests
Rate limit exceeded (same format as above)

#### 500 Internal Server Error
- STATUS_RETRIEVAL_FAILED: System unable to retrieve transaction status

## Common Headers
All responses include rate limit headers:
```
X-RateLimit-Limit: [requests per minute limit]
X-RateLimit-Remaining: [remaining requests]
X-RateLimit-Reset: [UTC timestamp when limit resets]
```