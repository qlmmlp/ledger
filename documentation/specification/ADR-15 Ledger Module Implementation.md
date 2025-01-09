# ADR 15: Ledger Module Implementation

## Status
Proposed

## Context
The Ledger module serves as the core component for financial transaction processing, requiring both synchronous API endpoints and asynchronous processing with proper event emission and projection maintenance.

## Challenges
- Need to maintain ACID compliance for financial transactions
- Proper event emission using Symfony remote events
- Management of ledger projections and currency mappings
- Clear idempotency guarantees
- Minimal worker logic with proper service delegation
- Efficient projection updates

## Decision
Implementation of a Ledger module with flat structure, nested API endpoints, and clear separation of concerns.

### A-20 Transaction Listing
System does not provide transaction listing functionality. Paginated transaction history and scanning capabilities are out of scope for the current implementation.

### Module Structure
```
Ledger/
├── Entity/
│   ├── Ledger.php
│   ├── Transaction.php
│   └── LedgerCurrencyMapping.php
├── Event/
│   ├── LedgerCreatedEvent.php
│   ├── TransactionCreatedEvent.php
│   └── TransactionCompletedEvent.php
├── Repository/
│   ├── LedgerRepository.php
│   └── TransactionRepository.php
├── Service/
│   ├── LedgerService.php        # Core business logic
│   ├── TransactionService.php   # Transaction processing logic
│   ├── EventDispatchService.php # Event mapping and dispatch
│   └── ProjectionService.php    # Projection management
├── Controller/
│   └── LedgerController.php     # All endpoints in single controller
├── Dto/
│   ├── Request/
│   │   ├── CreateLedgerRequest.php
│   │   └── CreateTransactionRequest.php
│   └── Response/
│       ├── LedgerResponse.php
│       └── TransactionResponse.php
├── Command/
│   └── ProcessTransactionCommand.php  # Minimal worker logic
└── Resources/
    └── config/
        ├── services.yaml
        └── doctrine/
            ├── Ledger.orm.xml
            └── Transaction.orm.xml
```

### Entity Structure

#### Ledger Entity
```php
class Ledger
{
    private string $id;
    private string $status;
    private Collection $currencies;  // ManyToMany with Currency
    private Collection $transactions;
    private \DateTimeImmutable $createdAt;
    private \DateTimeImmutable $updatedAt;
}
```

#### LedgerCurrencyMapping Entity
```php
class LedgerCurrencyMapping
{
    private Ledger $ledger;
    private Currency $currency;
    private \DateTimeImmutable $createdAt;
}
```

#### Transaction Entity
```php
class Transaction
{
    private string $id;
    private string $referenceId;  // For idempotency
    private Ledger $ledger;
    private Currency $currency;   // Must be one of ledger's currencies
    private TransactionType $type;
    private int $amount;
    private string $status;
    private array $error;
    private \DateTimeImmutable $createdAt;
    private \DateTimeImmutable $completedAt;
}
```

### API Endpoints Structure
```
POST   /ledgers                    # Create ledger
GET    /ledgers/{ledgerId}        # Get ledger state
POST   /ledgers/{ledgerId}/transactions    # Create transaction
GET    /ledgers/{ledgerId}/transactions/{transactionId}  # Get transaction
```

### Event Dispatching Service
```php
class EventDispatchService
{
    public function __construct(
        private RemoteEventDispatcherInterface $dispatcher,
        private ProjectionService $projectionService
    ) {}

    public function dispatchTransactionCompleted(Transaction $transaction): void
    {
        // Create and dispatch remote event
        $event = new TransactionCompletedEvent(
            $transaction->getId(),
            $transaction->getLedger()->getId(),
            $transaction->getStatus(),
            $transaction->getError()
        );
        
        $this->dispatcher->dispatch($event, 'ledger.transaction.completed');
        
        // Update projections after event dispatch
        $this->projectionService->updateTransactionProjection($transaction);
    }
}
```

### Projection Management
```php
class ProjectionService
{
    public function __construct(
        private StorageFacadeInterface $storage
    ) {}

    public function createLedgerProjection(Ledger $ledger): void
    {
        // Initialize projection for each currency with zero balance
        foreach ($ledger->getCurrencies() as $currency) {
            $projection = new ProjectionDto(
                module: 'ledger',
                projection: 'balance',
                id: sprintf('%s:%s', $ledger->getId(), $currency->getCode()),
                data: json_encode(['amount' => 0])
            );
            $this->storage->set($projection);
        }
    }

    public function updateTransactionProjection(Transaction $transaction): void
    {
        $projectionId = sprintf(
            '%s:%s',
            $transaction->getLedger()->getId(),
            $transaction->getCurrency()->getCode()
        );
        
        $projection = $this->storage->get(new ProjectionDto(
            module: 'ledger',
            projection: 'balance',
            id: $projectionId
        ));
        
        $data = json_decode($projection->data, true);
        $data['amount'] += $transaction->getType()->isDebit() 
            ? -$transaction->getAmount() 
            : $transaction->getAmount();
            
        $this->storage->set(new ProjectionDto(
            module: 'ledger',
            projection: 'balance',
            id: $projectionId,
            data: json_encode($data)
        ));
    }
}
```

### Worker Implementation
```php
class ProcessTransactionCommand extends Command
{
    public function __construct(
        private TransactionService $transactionService,
        private EventDispatchService $eventDispatcher
    ) {}

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $transactionId = $input->getArgument('transactionId');
        
        // Delegate all processing logic to service
        $result = $this->transactionService->process($transactionId);
        
        // Dispatch events based on result
        $this->eventDispatcher->dispatchTransactionCompleted($result);
        
        return Command::SUCCESS;
    }
}
```

### Idempotency Implementation
1. Use unique referenceId provided by client
2. Add unique constraint on (ledger_id, reference_id) in transaction table
3. Handle duplicate key violation in TransactionService:
```php
public function createTransaction(CreateTransactionRequest $request): Transaction
{
    try {
        // Try to insert new transaction
        return $this->repository->add($transaction);
    } catch (UniqueConstraintViolationException $e) {
        // Return existing transaction if reference_id exists
        return $this->repository->findByReference(
            $request->getLedgerId(),
            $request->getReferenceId()
        );
    }
}
```

## Consequences

### Positive
- Clear, flat module structure
- Proper isolation of ledger transactions through nested endpoints
- Minimal worker logic with clear service delegation
- Reliable projection updates
- Clear idempotency guarantees
- Proper currency constraints through entity relations

### Negative
- Need to maintain projection consistency
- More complex transaction validation with currency mapping
- Additional DB constraints for idempotency
- More complex projection update logic

## Implementation Notes
- Use Symfony Messenger for async processing with Redis transport
- Workers are configured as Messenger consumers that handle ProcessTransactionCommand
- Remote events use Symfony's Remote Event Dispatcher
- Projections are stored in Redis through Storage module
- Transaction processing uses SERIALIZABLE isolation
- Clear idempotency through database constraints
- Currency mappings enforced at database level

## References

### Requirements
- [FR-2 Transaction Processing](../requirements/functional-requirements.md#fr-2-transaction-processing)
- [NFR-2.2 Database Transaction Management](../requirements/non-functional-requirements.md#nfr-22-database-transaction-management)
- [NFR-3.1 API Style](../requirements/non-functional-requirements.md#nfr-31-api-style)

### Related ADRs
- [ADR-12: Ledger Module Database Structure](ADR-12.md)
- [ADR-13: Storage Module Design](ADR-13.md)