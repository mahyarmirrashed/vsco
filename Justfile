# Remove all services and volumes
down:
    docker compose down -v

# Start all services in the background
up:
    docker compose up -d --build --wait
