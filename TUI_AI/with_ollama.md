# Run Ollama in TUI

## [Download & Install](https://ollama.com/download)

```sh
curl -fsSL https://ollama.com/install.sh | sh
```

## Run Model

Chose your desired model [here](https://ollama.com/search)

```sh
ollama run <model>
```

## Ollama API

### Examples

specify a model:

```sh
curl http://localhost:11434/api/generate \
  -d '{
    "model": "llama3.1",
    "prompt": "Say hello in one sentence."
  }'
```

for embeddings:

```sh
curl http://localhost:11434/api/embeddings \
  -d '{
    "model": "nomic-embed-text",
    "prompt": "Hello world"
  }'
```
