# AI

Host your AI locally!

## Host in TUI with Ollama

### [Download & Install](https://ollama.com/download)

```sh
curl -fsSL https://ollama.com/install.sh | sh
```

### Run Model

Chose your desired model [here](https://ollama.com/search)

```sh
ollama run <model>
```

## Host in GUI with [Privater GPT](https://docs.privategpt.dev/quickstart/getting-started/quickstart)

### Requirements

- Poetry
- Python
- [Pyenv](https://github.com/pyenv/pyenv)

### Install - BETA: not completed, dev in progress

set python environment to 3.10:

```sh
pyenv install 3.11
pyenv versions
# * 3.11.14 (set by /home/alex/.pyenv/version)

pyenv global 3.11.14
```

Clone Private-GPT:

```sh
git clone https://github.com/zylon-ai/private-gpt.git
cd private-gpt
```

Install dependencies:

```sh
poetry install
```

or

```sh
poetry install --extras "ui llms-ollama embeddings-ollama vector-stores-qdrant"
```

Run AI:

PGPT wants you to run `docker-compose up` command don't do it.
don't run `docker-compose up` up as is the old (deprecated)
instead run this command:

```sh
docker compose up
```

Run a specific profile:

```sh
cat settings-ollama.yaml
```

```sh
PGPT_PROFILES=ollama make run
```
