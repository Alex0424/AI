# Alexander AI (RAG Stack)

## Stack

- Frontend & UI: Static HTML, CSS, and Javascript (fetch for API calls)
- Backend:
  - Edge/Gateway: Caddy (TLS termination + reverse proxy)
  - API: FastAPI
  - LLM Runtime: Ollama
  - Embeddings: Ollama (nomic-embed-text)
  - RAG Orchestration: LlamaIndex
  - Vector Store: ChromaDB

## Diagram

```sh
User → GitHub Pages (www.alexanderlindholm.net/ai) → Caddy (TLS) → FastAPI → LlamaIndex → Ollama → ChromaDB
```

## Why all tools in one VM?

I keep everything in one VM because traffic and scale do not justify distributed complexity. Docker provides isolation. The architecture is modular and can be split later.

## File Structure

```sh
.
├── backend
│   ├── chroma_db
│   ├── data
│   │   └── about.md
│   └─── main.py
├── cloud_script_install.sh
├── docker-compose.yml
├── Dockerfile
├── pyproject.toml
└── README.md
```

## Develop

Run the stack with:

```sh
docker compose up --build
```

## Monitoring

Diagram:

```sh
Docker <- cAdvisor <- Prometheus <- Grafana
```
cAdvisor & Prometheus is automatically configured while Grafana needs manual steps to chose a visualizing board.

### Setup Grafana

In Grafana UI go to: `/Home/Connections/'Data sources'`

Click: `Add data source`

- Chose: `Prometheus`
- Connection: `http://prometheus:9090`

Dashboards -> New -> Import

- Dashboard ID: `193`
- DS_PROMETHEUS: `prometheus`
