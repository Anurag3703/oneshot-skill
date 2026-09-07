# Copilot Task Routing

For implementation, debugging, refactoring, analysis, or ticket work, invoke `contextual-prompt-generator` before searching files, running commands, or editing code.

After invoking it, follow its plan -> execute -> validate workflow in the same session. Do not treat the skill as background context and then switch to an independent workflow. If the user asks for plan-only or prompt-only output, do not implement; otherwise continue through execution and validation.