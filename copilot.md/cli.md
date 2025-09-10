# GitHub CLI

## [Installation](https://github.com/cli/cli?tab=readme-ov-file#installation)

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

Apply an specific alias to bypass copying and pasting:

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

Configure:

```shell
gh copilot config
```