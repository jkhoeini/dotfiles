# Global Instructions

- Keep responses concise and to the point unless asked for detail
- Skip long explanations unless specifically requested
- Answer directly without preamble or summary

## Shell Environment

If a command in shell fails because it's not found wrap the shell command in `zsh -c '...'` because PATH and other env configs are zsh-based.

## Version Control

**If a repo is jj based use Jujutsu (jj) instead of Git.** Load the `jujutsu` skill for command reference.

- Check if the repo is using jj already. If yes,
- Use `jj` commands, not `git` commands
- Use `using-jj-workspaces` skill for isolated feature work
- Don't push unless I explicitly ask for it
