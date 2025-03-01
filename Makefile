# Environment variables
ENV_FILE := .active_env
ENV_DEV := dev
ENV_STAGING := staging
ENV_DEFAULT := .env
ENV_LOCAL := .env.local

# Set up docker compose env file arguments
DOCKER_ENV_FILES := --env-file $(ENV_DEFAULT)
ifneq ("$(wildcard $(ENV_LOCAL))","")
    DOCKER_ENV_FILES += --env-file $(ENV_LOCAL)
endif

# Colors for output
INFO := \033[0;36m
SUCCESS := \033[0;32m
WARNING := \033[0;33m
ERROR := \033[0;31m
NC := \033[0m # No Color

.PHONY: help dev staging stop destroy status ps logs build up shell xshell

# Default target
help: ## Show available commands
	@echo "$(INFO)Usage:$(NC)"
	@echo "  make [target]"
	@echo ""
	@echo "$(INFO)Environment Selection:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## Environment Selection:.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## Environment Selection: "}; {printf "  $(SUCCESS)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(INFO)Container Operations:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## Container Operations:.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## Container Operations: "}; {printf "  $(SUCCESS)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(INFO)Development Tools:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## Development Tools:.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## Development Tools: "}; {printf "  $(SUCCESS)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(INFO)Monitoring:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## Monitoring:.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## Monitoring: "}; {printf "  $(SUCCESS)%-15s$(NC) %s\n", $$1, $$2}'

# Environment detection
CURRENT_ENV := $(shell cat $(ENV_FILE) 2>/dev/null)
ENV_RUNNING := $(shell docker compose ps --quiet 2>/dev/null)

# Check no environment exists
setup-env:
	@if [ ! -f $(ENV_DEFAULT) ]; then \
		echo "$(WARNING)Creating default .env file...$(NC)"; \
		echo "POSTGRES_USER=postgres" > $(ENV_DEFAULT); \
		echo "POSTGRES_PASSWORD=postgres" >> $(ENV_DEFAULT); \
		echo "POSTGRES_DB=app" >> $(ENV_DEFAULT); \
		echo "$(SUCCESS).env file created with default values.$(NC)"; \
	fi

check-no-env: setup-env
	@if [ -f $(ENV_FILE) ]; then \
		echo "$(ERROR)Environment already exists. Run make destroy first.$(NC)"; \
		exit 1; \
	fi

# Check environment exists
check-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(ERROR)No environment selected. Run make $(ENV_DEV) or make $(ENV_STAGING) first.$(NC)"; \
		exit 1; \
	fi

# Select development environment
dev: check-no-env ## Environment Selection: Select development environment
	@echo "$(WARNING)Selecting development environment...$(NC)"
	@echo "$(ENV_DEV)" > $(ENV_FILE)
	@echo "$(SUCCESS)Development environment selected!$(NC)"
	@echo "$(INFO)Run 'make build' to build containers or 'make up' to start the environment$(NC)"

# Select staging environment
staging: check-no-env ## Environment Selection: Select staging environment
	@echo "$(WARNING)Selecting staging environment...$(NC)"
	@echo "$(ENV_STAGING)" > $(ENV_FILE)
	@echo "$(SUCCESS)Staging environment selected!$(NC)"
	@echo "$(INFO)Run 'make build' to build containers or 'make up' to start the environment$(NC)"

install: check-env ## Development Tools: Run installation script
	@echo "$(INFO)Running installation for $(CURRENT_ENV) environment...$(NC)"
	@docker compose exec app ./bin/install

# Start environment
up: check-env ## Container Operations: Start the current environment
	@echo "$(WARNING)Starting $(CURRENT_ENV) environment...$(NC)"
	@if [ "$(CURRENT_ENV)" = "$(ENV_DEV)" ]; then \
		docker compose $(DOCKER_ENV_FILES) up -d; \
	else \
		docker compose $(DOCKER_ENV_FILES) -f docker-compose.yml -f docker-compose.staging.yml up -d; \
	fi
	@echo "$(SUCCESS)Environment is ready!$(NC)"

# Build current environment
build: check-env ## Container Operations: Build containers for current environment
	@echo "$(WARNING)Building $(CURRENT_ENV) environment...$(NC)"
	@if [ "$(CURRENT_ENV)" = "$(ENV_DEV)" ]; then \
		docker compose $(DOCKER_ENV_FILES) build --no-cache; \
	else \
		docker compose $(DOCKER_ENV_FILES) -f docker-compose.yml -f docker-compose.staging.yml build --no-cache; \
	fi
	@echo "$(SUCCESS)Build complete! Run 'make up' to start the environment.$(NC)"

# Stop environment
stop: check-env ## Container Operations: Stop current environment (preserves resources)
	@echo "$(WARNING)Stopping $(CURRENT_ENV) environment...$(NC)"
	@docker compose stop
	@echo "$(SUCCESS)Environment stopped. Run 'make up' to restart.$(NC)"

# Destroy environment
destroy: ## Container Operations: Remove all environment resources
	@if [ -f $(ENV_FILE) ]; then \
		echo "$(WARNING)Destroying $(CURRENT_ENV) environment...$(NC)"; \
		docker compose down -v; \
		docker rmi $$(docker images -q ledger-*) 2>/dev/null || true; \
		rm -f $(ENV_FILE); \
		rm -rf vendor; \
		rm -rf var/cache; \
		echo "$(SUCCESS)Environment destroyed.$(NC)"; \
	else \
		echo "$(WARNING)No environment to destroy.$(NC)"; \
	fi

# Interactive shell without Xdebug
shell: check-env ## Development Tools: Start shell without Xdebug
	@echo "$(INFO)Starting shell without Xdebug...$(NC)"
	@docker compose exec -e XDEBUG_MODE=off app bash

# Interactive shell with Xdebug
xshell: check-env ## Development Tools: Start shell with Xdebug enabled
	@echo "$(INFO)Starting shell with Xdebug...$(NC)"
	@docker compose exec -e XDEBUG_MODE=debug app bash

# Show environment status
status: ## Monitoring: Show current environment status and containers
	@if [ -f $(ENV_FILE) ]; then \
		echo "$(INFO)Current environment: $(CURRENT_ENV)$(NC)"; \
		docker compose ps; \
	else \
		echo "$(WARNING)No active environment.$(NC)"; \
	fi

# Show running containers
ps: ## Monitoring: List running containers
	@docker compose ps

# Show container logs
logs: ## Monitoring: Show container logs in real-time
	@docker compose logs -f