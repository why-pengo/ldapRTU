.PHONY: help build up down restart logs clean certs

# Default target
help:
	@echo "GLAuth Docker Compose Makefile"
	@echo "=============================="
	@echo ""
	@echo "Available targets:"
	@echo "  help      - Show this help message"
	@echo "  build     - Build/pull the Docker image"
	@echo "  up        - Start the GLAuth service"
	@echo "  down      - Stop the GLAuth service"
	@echo "  restart   - Restart the GLAuth service"
	@echo "  logs      - Show service logs"
	@echo "  clean     - Stop and remove containers, networks"
	@echo "  certs     - Generate self-signed certificates for LDAPS"
	@echo ""

# Build/pull the Docker image
build:
	@echo "Building/pulling GLAuth image..."
	docker compose pull

# Start the service
up: certs
	@echo "Starting GLAuth service..."
	docker compose up -d
	@echo "GLAuth is running!"
	@echo "LDAP:  ldap://localhost:3893"
	@echo "LDAPS: ldaps://localhost:3894"
	@echo "API:   http://localhost:5555"

# Stop the service
down:
	@echo "Stopping GLAuth service..."
	docker compose down

# Restart the service
restart:
	@echo "Restarting GLAuth service..."
	docker compose restart

# Show logs
logs:
	docker compose logs -f glauth

# Test LDAP connectivity
test:
	@./test-ldap.sh

# Clean up everything
clean:
	@echo "Cleaning up..."
	docker compose down -v
	@echo "Cleanup complete!"

# Generate self-signed certificates
certs:
	@if [ ! -f certs/glauth.crt ] || [ ! -f certs/glauth.key ]; then \
		echo "Generating self-signed certificates..."; \
		mkdir -p certs; \
		openssl req -x509 -newkey rsa:4096 -keyout certs/glauth.key -out certs/glauth.crt -days 365 -nodes -subj '/CN=glauth'; \
		chmod 644 certs/glauth.crt; \
		chmod 600 certs/glauth.key; \
		echo "Certificates generated in ./certs/"; \
	else \
		echo "Certificates already exist in ./certs/"; \
	fi
