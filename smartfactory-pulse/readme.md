# SmartFactory-Pulse: Real-Time Industrial IoT & MES Analytics Engine

An end-to-end industrial telemetry platform combining containerized time-series databases, automated continuous aggregates, Python IoT streaming, and operational Grafana dashboards aligned with the ISA-95 manufacturing standard.

[dashboard_preview.png]

## Tech Stack
* **Database Engine**: PostgreSQL 16 with the TimescaleDB extension
* **Data Pipeline**: Python 3 (`psycopg2`) IoT telemetry simulator
* **Visualization**: Grafana 11+
* **Infrastructure**: Docker & Docker Compose
* **Domain Standard**: ISA-95 Equipment Hierarchy & Overall Equipment Effectiveness (OEE)

## Architecture Overview
1. **IoT Telemetry Producer (`simulator.py`)**: Simulates 3 factory assets (`CNC_01`, `CNC_02`, `ROBOT_01`) streaming continuous sensor dynamics (vibration RMS, temperature, power load) and discrete state events (`RUNNING`, `IDLE`, `FAULT`).
2. **Relational MES Layer (`schema.sql`)**: Manages equipment catalogs, target cycle times, and downtime reason codes.
3. **Time-Series Layer**: Automatically partitions incoming records into daily hypertable chunks and refreshes rolling 5-minute continuous aggregates.
4. **Grafana Observability**: Visualizes live operational state timelines, real-time quality rates, thermal wear alerts, and downtime Pareto distributions.

## Getting Started

### 1. Prerequisites
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
* [Python 3.8+](https://www.python.org/)

### 2. Launch Infrastructure
```bash
docker compose up -d