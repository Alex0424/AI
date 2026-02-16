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

## Infrastructure (IaC Terraform)

### Development

#### Install & Setup GCP CLI

1. [GCP CLI](https://docs.cloud.google.com/sdk/docs/install-sdk#linux)

2. `gcloud auth application-default login`

3. `gcloud auth login`

4. `gcloud projects list`

5. `gcloud auth application-default set-quota-project <YOUR_PROJECT_ID>`

6. `gcloud config set project <YOUR_PROJECT_ID>`

7. `gcloud config get-value project`

#### Make sure file is Unix

```sh
dos2unix cloud_script_install.sh
```

#### Deploy with Terraform (IaC)

1. `terraform init`

2. `terraform plan`

3. `terraform apply`

#### Destroy with Terraform

1. `terraform destroy -target=google_compute_instance.ai_vm`


2. `terraform destroy -target=google_compute_firewall.allow_http_https`

### TF Config

[provider.tf](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/versi)

### Ansible

#### SSH key for Ansible

```sh
ssh-keygen -t rsa -b 2048 \
-f ~/.ssh/gcp-ansible \
-C ansible
```

```sh
ssh -i ~/.ssh/gcp-ansible ansible@34.51.235.121
```

#### Test

Ping machine

```sh
ansible -i inventory.ini ai -m ping
```

this means it is working:

```sh
# "ping": "pong"
```

if you get man-in-middle attack then do this to fix:

```
ssh-keygen -R 34.51.235.121
```

Run:

```sh
ansible-playbook -i inventory.ini playbook.yml
```

### Debug

#### Monitor Cloud Init script (SSH to VM required)

```sh
sudo journalctl -u google-startup-scripts.service -f
```

#### Docker compose

Container status:

```sh
docker ps
```

Restart stack:

```sh
docker compose down
docker compose up -d
```

#### Test API

```sh
curl https://api.alexanderlindholm.net/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"Who are you?","session_id":"test123"}'
```
