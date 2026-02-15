# Server Install (Beta)

Install:

```sh
curl -fsSL https://ollama.com/install.sh | sh

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc
poetry --version
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init - bash)"' >> ~/.profile
poetry --version

curl -sSL https://install.python-poetry.org | python3 -
python3 --version
python3 -m pip install --upgrade pip setuptools wheel
pip install --upgrade pip setuptools
pip install --upgrade pip wheel
pip install packaging


cd private-gpt/
python3 -m venv .venv
source .venv/bin/activate
poetry install
```

Create Systemd config:

```sh
sudo vim /etc/systemd/system/privategpt.service
```

```sh
[Unit]
Description=PrivateGPT (Ollama)
After=network.target

[Service]
User=lindholmalex_la
WorkingDirectory=/home/lindholmalex_la/private-gpt
Environment=PGPT_PROFILES=ollama
ExecStart=/home/lindholmalex_la/private-gpt/.venv/bin/python -m private_gpt
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Apply systemd:

```sh
sudo systemctl daemon-reload
sudo systemctl enable privategpt
sudo systemctl start privategpt
sudo systemctl status privategpt
```
