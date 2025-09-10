# GitHub CLI

## [Installation](https://docs.github.com/en/copilot/how-tos/set-up/install-copilot-in-the-cli)

Linux Ubuntu distrobution Example(10/09/2025):

```
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
```

```shell
apt update
```

```shell
gh auth login
```

```shell
gh extension install github/gh-copilot
```

## [Demo](https://learn.microsoft.com/en-us/training/modules/github-copilot-across-environments/5-git-hub-copilot-for-the-command-line?ns-enrollment-type=learningpath&ns-enrollment-id=learn.github-copilot)

Default Copilot commands:

1. Explain

```shell
gh copilot explain "sudo apt-get"
```
2. Suggest

```shell
gh copilot suggest "Undo the last commit"
```

3. Apply an specific alias to bypass copying and pasting:

Linux:

```shell
echo 'eval "$(gh copilot alias -- bash)"' >> ~/.bashrc
```

Windows (Power Shell):

```shell
$GH_COPILOT_PROFILE = Join-Path -Path $(Split-Path -Path $PROFILE -Parent) -ChildPath "gh-copilot.ps1"
gh copilot alias -- pwsh | Out-File ( New-Item -Path $GH_COPILOT_PROFILE -Force )
  echo ". `"$GH_COPILOT_PROFILE`"" >> $PROFILE
```

4. Configure Settings:

```shell
gh copilot config
```
