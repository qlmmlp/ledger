# ADR 13: Storage Module Design

## Status
Proposed

## Context
The system requires a simple storage interface for maintaining projection data, serving as an abstraction layer over Redis for other modules. The storage module needs to provide basic key-value operations while ensuring proper key management.

## Challenges
- Need for clean and minimal interface for projection storage
- Management of Redis key structure
- Clear separation between storage concerns and domain logic
- Protection against key collisions between different modules
- Ensuring testability of the module

## Decision
Implementation of a dedicated Storage module with module-based key management.

### Module Structure
```
Storage/
├── Dto/
│   └── ProjectionDto.php      # Public DTO used by other modules
├── Exception/
│   ├── StorageException.php   # Base exception
│   └── ProjectionNotFoundException.php
├── Facade/
│   ├── StorageFacade.php     # Implementation
│   └── StorageFacadeInterface.php
├── Internal/
│   └── Service/
│       ├── StorageService.php
│       └── KeyGenerator.php   # Internal key generation
├── Resources/
│   └── config/
│       └── services.yaml
└── Tests/
├── Unit/
│   ├── Facade/
│   │   └── StorageFacadeTest.php
│   └── Internal/
│       ├── Service/
│       │   ├── StorageServiceTest.php
│       │   └── KeyGeneratorTest.php
└── Integration/
└── StorageModuleTest.php
```

### Key Structure
- Keys are constructed internally as `{module}:{projection}:{id}`
- Key format and generation is handled internally by the module
- Example: `ledger:balance:user123`

### Interface Design
```php
namespace App\Storage\Dto;

/**
 * @final
 */
class ProjectionDto
{
    public function __construct(
        public readonly string $module,
        public readonly string $projection,
        public readonly string $id,
        public readonly string $data,
    ) {}
}

namespace App\Storage\Facade;

interface StorageFacadeInterface
{
    /**
     * Store projection data
     *
     * @throws StorageException
     */
    public function set(ProjectionDto $projection): void;

    /**
     * Retrieve projection
     *
     * @throws ProjectionNotFoundException
     * @throws StorageException
     */
    public function get(ProjectionDto $projection): ProjectionDto;
}
```

### Usage Example
```php
class SomeService
{
    public function __construct(
        private readonly StorageFacadeInterface $storage
    ) {}

    public function storeProjection(): void
    {
        $projection = new ProjectionDto(
            module: 'ledger',
            projection: 'balance',
            id: 'user123',
            data: '{"amount":100}'
        );
        
        $this->storage->set($projection);
        
        $stored = $this->storage->get($projection);
        // Client handles data deserialization
        $data = json_decode($stored->data, true);
    }
}
```

## Testing Requirements

### Unit Tests
1. KeyGenerator Service
    - Generates correct key format
    - Handles special characters properly
    - Validates input components

2. Storage Service
    - Proper interaction with Redis client
    - Error handling for Redis failures
    - Key pattern validation

3. Storage Facade
    - Proper delegation to internal services
    - Exception handling and transformation
    - Input validation

### Integration Tests
1. Storage Module
    - End-to-end storage and retrieval
    - Redis connection handling
    - Exception scenarios
    - Real Redis instance interactions

### Test Data Requirements
- Test cases must cover various data formats
- Edge cases for key components
- Various projection types
- Different module combinations

### Mocking Strategy
- Redis client should be mocked in unit tests
- Internal services should be mocked in facade tests
- Real Redis instance should be used in integration tests

## Consequences

### Positive
- Clean and simple interface for projection storage
- Centralized key management prevents collisions
- Clear error handling boundaries
- Encapsulated Redis implementation details
- Module isolation
- Comprehensive test coverage

### Negative
- Additional key format restrictions
- Serialization/deserialization handled by clients

## Implementation Notes
- All services except Facade are marked as @internal
- Services are configured as private in the container
- Key generation is handled internally
- No validation of data format - treated as opaque string

## Future Considerations
- Namespace registration mechanism
- Bulk operations support
- Health checks implementation
- TTL support per key pattern
- Monitoring implementation

## References

### Requirements
- [NFR-2.4 Data Storage](../requirements/non-functional-requirements.md#nfr-24-data-storage)
- [NFR-2.5 Data Consistency](../requirements/non-functional-requirements.md#nfr-25-data-consistency)

### Related ADRs
- [ADR-2: Two-tier Storage Strategy](ADR-2.md)
- [ADR-9: Read-Optimized Projections](ADR-9.md)