# MCP Hosting and Development INFO (BETA)

## Docs

- [MCP - FastMCP](https://modelcontextprotocol.io/docs/getting-started/intro)


## Development

### Setup systemd

```sh
sudo systemctl status ollama
```

```sh
Loaded: loaded (/etc/systemd/system/ollama.service; enabled; preset: disabled
```

create `override.conf`:

```sh
sudo mkdir -p /etc/systemd/system/ollama.service.d
sudo nvim /etc/systemd/system/ollama.service.d/override.conf
```

Add configuration to `override.conf` file:

```sh
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
# Bind all network interfaces on this machine:
# Example A: 127.0.0.1 (localhost)
# Example B: 168.10.x.x (LAN IP)
# VPN, 'Docker bridge'...
```

Restart service:

```sh
sudo systemctl daemon-reload
sudo systemctl restart ollama
```

Test connection:

```sh
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.1:8b",
  "prompt": "What is a port scan?",
  "stream": false
}'
```

Validate IP again:

```sh
sudo systemctl show ollama | grep OLLAMA_HOST
# validate the output: OLLAMA_HOST=0.0.0.0:11434
```

## Install dependencies in VENV

```sh
python -m venv .venv
source .venv/bin/activate
```

```sh
pip install mcp ollama
```

## Run MCP

```sh
chmod +x ./mcp_server.py
python ./mcp_server.py
```
