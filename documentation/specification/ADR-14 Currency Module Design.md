# ADR 14: Currency Module Design

## Status
Proposed

## Context
The system requires a dedicated Currency module to provide a consistent currency entity representation and serve as the source of truth for available currencies and their metadata. The module needs to encapsulate currency-related logic, integrate with the Storage module for currency projections, and expose a clean interface for currency management to other modules.

## Challenges
- Need for centralized currency management
- Integration with Storage module for projections
- Clear separation of concerns between currency logic and storage
- Ensuring data consistency between currency entity and projections
- Supporting currency installation and activation process
- Providing a simple interface for retrieving active currencies

## Decision
Implement a dedicated Currency module with entity representation, storage integration, and facade interface.

### Module Structure
```
Currency/
├── Dto/  
│   └── CurrencyDto.php       # Public DTO for currency data
├── Entity/
│   └── CurrencyEntity.php        # Doctrine entity representing currency
├── Exception/  
│   └── CurrencyException.php 
├── Facade/
│   ├── CurrencyFacade.php    # Implementation of CurrencyFacadeInterface
│   └── CurrencyFacadeInterface.php 
├── Projection/ 
│   ├── CurrencyProjectionWriter.php  # Responsible for writing currency projections
│   ├── CurrencyProjectionReader.php  # Responsible for reading currency projections  
│   └── CurrencyProjectionDtoMapper.php  # Maps CurrencyDto to ProjectionDto
├── Repository/
│   └── CurrencyRepository.php        # Doctrine repository for Currency entity
├── Resources/
│   └── config/
│       ├── services.yaml
│       └── doctrine/
│           └── Currency.orm.xml     # Doctrine mapping for Currency entity  
└── Tests/
    ├── Unit/
    │   └── Facade/
    │       └── CurrencyFacadeTest.php
    └── Integration/
        └── CurrencyModuleTest.php
```

### Entity Design
```php
namespace App\Currency\Entity;

/**
 * @ORM\Entity
 * @ORM\Table(name="currencies")
 */
class CurrencyEntity
{
    /**
     * @ORM\Id
     * @ORM\Column(type="string", length=3)
     */
    private string $code;

    /** @ORM\Column(type="string", length=255) */ 
    private string $name;
    
    /** @ORM\Column(type="integer") */
    private int $minorUnit;

    /** @ORM\Column(type="string", enumType=CurrencyStatusEnum::class) */
    private CurrencyStatusEnum $status;

    // Getters and setters
}
```

### Facade Interface
```php
namespace App\Currency\Facade;

interface CurrencyFacadeInterface
{
    /**
     * @return CurrencyDto[]
     */
    public function getActiveCurrencies(): array;
}
```

### Storage Integration
- `CurrencyProjectionWriter` accepts `CurrencyDto` and internally maps it to `ProjectionDto` using `CurrencyProjectionDtoMapper`
- `CurrencyProjectionWriter` depends on `StorageFacadeInterface` to interact with Storage module
- `CurrencyProjectionReader` retrieves currency projections from Storage and maps them back to `CurrencyDto`
- Both `CurrencyProjectionWriter` and `CurrencyProjectionReader` support handling collections of currencies
- `CurrencyFacade` uses `CurrencyProjectionReader` to serve active currencies from projection data as a list

### Deployment Process
1. Define supported currencies in configuration
2. Create Doctrine migration to install configured currencies into database
3. Run migration during application deployment to populate currency data
4. Currency activation process triggers projection updates in Storage

## Consequences

### Positive
- Centralized currency management
- Consistent usage of Currency entity across the system
- Storage integration for optimized read access to active currencies
- Clear interface for retrieving active currencies
- Separation of concerns between currency management and storage

### Negative
- Additional complexity in maintaining consistency between entity and projection data
- Deployment process requires currency installation step

## Required Changes in Requirements

### Add to Functional Requirements
- FR-1.6 Currency Installation: The system shall provide a mechanism to install configured currencies into the database during application deployment.

### Add to Non-Functional Requirements
- NFR-3.5 Currency Projections: The system shall maintain read-optimized currency projections in Redis storage for efficient access to active currencies.

## Implementation Notes
- Use Doctrine ORM for Currency entity persistence
- Implement CurrencyProjectionWriter to handle currency projection updates
- Implement CurrencyProjectionReader to retrieve currency projections from Storage
- Configure CurrencyFacade as public service
- Mark other services as private in the container
- Ensure comprehensive test coverage for facade, projection services, and integration with Storage

## Related ADRs
- [ADR-2: Two-tier Storage Strategy](ADR-2.md)
- [ADR-8: Integer-Only Currency Values](ADR-8.md)
- [ADR-9: Read-Optimized Projections](ADR-9.md)
- [ADR-13: Storage Module Design](ADR-13.md)

## References

### Requirements
- [FR-1.3 Currency Validation](../requirements/functional-requirements.md#fr-13-currency-validation)
- [FR-1.4 Currency Availability Management](../requirements/functional-requirements.md#fr-14-currency-availability-management)
- [FR-1.5 Currency Support Status](../requirements/functional-requirements.md#fr-15-currency-support-status)
- [NFR-3.3 Event Store](../requirements/non-functional-requirements.md#nfr-33-event-store)
- [A-1 Currency Configuration](../requirements/assumptions.md#a-1-currency-configuration)