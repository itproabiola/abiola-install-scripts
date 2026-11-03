#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"

command -v docker >/dev/null || { echo "Docker is required."; exit 1; }
docker compose version >/dev/null || { echo "Docker Compose v2 is required."; exit 1; }
[[ -f .env ]] || { echo "Create .env from .env.example first."; exit 1; }

case "${1:-start}" in
  start) docker compose up -d ;;
  stop) docker compose stop ;;
  restart) docker compose restart ;;
  status) docker compose ps -a ;;
  logs) docker compose logs -f --tail=100 ;;
  pull) docker compose pull ;;
  update) docker compose pull && docker compose up -d ;;
  *) echo "Usage: $0 {start|stop|restart|status|logs|pull|update}"; exit 1 ;;
esac
