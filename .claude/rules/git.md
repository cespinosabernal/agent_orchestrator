# Git Workflow Rules

## Branches
- `main` / `master`: protected. Never force-push.
- Feature branches: `feat/<short-description>`
- Bugfix branches: `fix/<short-description>`
- Analysis branches: `analysis/<project>-<description>`

## Commits
- Use conventional commits: `type(scope): message`
  - Types: `feat`, `fix`, `refactor`, `analysis`, `data`, `docs`, `test`, `chore`
  - Example: `analysis(scrna): add leiden clustering to pbmc pipeline`
- Keep commits atomic: one logical change per commit.
- Never commit: `.env`, secrets, raw data files, large binaries, `renv/library/`.

## Safety
- Never `git push --force` to `main` or `master`.
- Never `git reset --hard` without confirming no uncommitted work is lost.
- Before destructive operations, create a backup branch: `git branch backup/$(date +%Y%m%d)`

## Project Repos
- Each project cloned under `repo/<project-name>/` is an independent git repo.
- Do not `git add` files from `repo/` into the orchestrator repo.
- Each project repo should have its own `.gitignore` for data, outputs, and env files.

## Pull Requests
- PRs require a description of what changed and why.
- Tag relevant issues; request review before merging.
