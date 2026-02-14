# Alexander AI (RAG Stack)

## Stack INFO

- Frontend & UI: Static HTML, CSS, and Javascript (fetch for API calls)
- Backend:
  - Edge/Gateway: Caddy (TLS termination + reverse proxy)
  - API: FastAPI
  - LLM Runtime: Ollama
  - Embeddings: Ollama (nomic-embed-text)
  - RAG Orchestration: LlamaIndex
  - Vector Store: ChromaDB

[embeddings](https://ollama.com/library/nomic-embed-text)

Tree:

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

RUN API:

```sh
docker compose up --build
```
