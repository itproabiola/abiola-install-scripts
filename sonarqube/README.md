# Abiola DevOps - SonarQube Local Deployment

Local SonarQube Community Build with PostgreSQL using Docker Compose.

## Requirements
- Linux or WSL2
- Docker Engine and Docker Compose v2
- Port 9000 available

## Installation
1. Copy `.env.example` to `.env`.
2. Set a unique, strong database password in `.env`.
3. Run `chmod 600 .env`.
4. Start with `./install-sonarqube.sh start`.
5. Open http://localhost:9000.

## Management
- Start: `./install-sonarqube.sh start`
- Stop: `./install-sonarqube.sh stop`
- Restart: `./install-sonarqube.sh restart`
- Status: `./install-sonarqube.sh status`
- Logs: `./install-sonarqube.sh logs`
- Update: `./install-sonarqube.sh update`

## Persistence
PostgreSQL and SonarQube data are stored in named Docker volumes.
Stopping containers preserves data. Do not use `docker compose down -v`
unless you intentionally want to delete persistent data.

## Security
Never commit `.env`. Change the default SonarQube administrator
password on first login. Do not expose port 9000 publicly without
appropriate security controls.

Maintainer: Abiola DevOps
https://github.com/itproabiola
