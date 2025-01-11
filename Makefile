# Colors
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

.PHONY: help dev staging stop destroy status ps logs build up

# Default target
help: ## Show available commands
	@echo "$(CYAN)Usage:$(NC)"
	@echo "  make [target]"
	@echo ""
	@echo "$(CYAN)Environment Selection:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## Environment Selection:.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## Environment Selection: "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(CYAN)Container Operations:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## Container Operations:.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## Container Operations: "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(CYAN)Monitoring:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## Monitoring:.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## Monitoring: "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

# Environment detection
CURRENT_ENV := $(shell cat .active_env 2>/dev/null)
ENV_RUNNING := $(shell docker compose ps --quiet 2>/dev/null)

# Check no environment exists
check-no-env:
	@if [ -f .active_env ]; then \
		echo "$(RED)Environment already exists. Run make destroy first.$(NC)"; \
		exit 1; \
	fi

# Check environment exists
check-env:
	@if [ ! -f .active_env ]; then \
		echo "$(RED)No environment selected. Run make dev or make staging first.$(NC)"; \
		exit 1; \
	fi

# Copy environment file
copy-env-%:
	@if [ "$*" = "dev" ]; then \
		cat .env > .env.local && cat .env.dev >> .env.local; \
	elif [ "$*" = "staging" ]; then \
		cat .env > .env.local && cat .env.staging >> .env.local; \
	fi

# Select development environment
dev: check-no-env ## Environment Selection: Select development environment
	@echo "$(YELLOW)Selecting development environment...$(NC)"
	@echo "dev" > .active_env
	@$(MAKE) copy-env-dev
	@echo "$(GREEN)Development environment selected!$(NC)"
	@echo "$(CYAN)Run 'make build' to build containers or 'make up' to start the environment$(NC)"

# Select staging environment
staging: check-no-env ## Environment Selection: Select staging environment
	@echo "$(YELLOW)Selecting staging environment...$(NC)"
	@echo "staging" > .active_env
	@$(MAKE) copy-env-staging
	@echo "$(GREEN)Staging environment selected!$(NC)"
	@echo "$(CYAN)Run 'make build' to build containers or 'make up' to start the environment$(NC)"

# Start environment
up: check-env ## Container Operations: Start the current environment
	@echo "$(YELLOW)Starting $(CURRENT_ENV) environment...$(NC)"
	@if [ "$(CURRENT_ENV)" = "dev" ]; then \
		docker compose --env-file .env.local up -d; \
	else \
		docker compose --env-file .env.local -f docker-compose.yml -f docker-compose.staging.yml up -d; \
	fi
	@echo "$(GREEN)Environment is ready!$(NC)"

# Build current environment
build: check-env ## Container Operations: Build containers for current environment
	@echo "$(YELLOW)Building $(CURRENT_ENV) environment...$(NC)"
	@if [ "$(CURRENT_ENV)" = "dev" ]; then \
		docker compose --env-file .env.local build --no-cache; \
	else \
		docker compose --env-file .env.local -f docker-compose.yml -f docker-compose.staging.yml build --no-cache; \
	fi
	@echo "$(GREEN)Build complete! Run 'make up' to start the environment.$(NC)"

# Stop environment
stop: check-env ## Container Operations: Stop current environment (preserves resources)
	@echo "$(YELLOW)Stopping $(CURRENT_ENV) environment...$(NC)"
	@docker compose stop
	@echo "$(GREEN)Environment stopped. Run 'make up' to restart.$(NC)"

# Destroy environment
destroy: ## Container Operations: Remove all environment resources
	@if [ -f .active_env ]; then \
		echo "$(YELLOW)Destroying $(CURRENT_ENV) environment...$(NC)"; \
		docker compose down -v; \
		docker rmi $$(docker images -q ledger-*) 2>/dev/null || true; \
		rm -f .env.local .active_env; \
		echo "$(GREEN)Environment destroyed.$(NC)"; \
	else \
		echo "$(YELLOW)No environment to destroy.$(NC)"; \
	fi

# Show environment status
status: ## Monitoring: Show current environment status and containers
	@if [ -f .active_env ]; then \
		echo "$(CYAN)Current environment: $(CURRENT_ENV)$(NC)"; \
		docker compose ps; \
	else \
		echo "$(YELLOW)No active environment.$(NC)"; \
	fi

# Show running containers
ps: ## Monitoring: List running containers
	@docker compose ps

# Show container logs
logs: ## Monitoring: Show container logs in real-time
	@docker compose logs -f
