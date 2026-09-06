# Install into Copilot

Users should **not** copy folders by hand. After publishing to GitHub Enterprise, testers run **one command**.

## 1. Testers: One-line install

```bash
GH_HOST=bmw.ghe.com gh api /repos/Anurag-TA-Tiwari/contextual-prompt-generator/contents/scripts/install-remote.sh -H "Accept: application/vnd.github.raw" | bash
```

Or if using `curl`:

```bash
curl -fsSL https://bmw.ghe.com/raw/Anurag-TA-Tiwari/contextual-prompt-generator/main/scripts/install-remote.sh | bash
```

That downloads the skill and installs it directly into Copilot paths (`~/.github/skills` and `~/.copilot/skills`).

### Also install org profile (optional)
```bash
GH_HOST=bmw.ghe.com gh api /repos/Anurag-TA-Tiwari/contextual-prompt-generator/contents/scripts/install-remote.sh -H "Accept: application/vnd.github.raw" | WITH_ORG=1 bash
```

## 2. After install — what testers do

1. Reload Copilot Chat or start a **new chat session**.
2. Type any request or paste a Jira ticket, for example:
   ```text
   Add retries to the payment client
   ```
   No special slash command needed — Copilot automatically invokes the skill.

## 3. Local install (without network)

```bash
bash scripts/install.sh
```

## 4. Uninstall

```bash
rm -rf .github/skills/contextual-prompt-generator
rm -rf ~/.github/skills/contextual-prompt-generator
rm -rf ~/.copilot/skills/contextual-prompt-generator
rm -rf ~/.grok/skills/contextual-prompt-generator
```
