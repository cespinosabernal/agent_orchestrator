#!/usr/bin/env bash
# session-start-compact.sh
# SessionStart hook (matcher: compact) — re-injects critical rules
# into Claude's context after a /compact compaction event.
# Output on stdout is added to Claude's context window.

cat <<'RULES'
=== Scientific Orchestrator — Key Rules (re-injected after compaction) ===

ENVIRONMENT: Always use mamba, never pip install into base.
  mamba create -n sci-orchestrator python=3.11
  mamba activate sci-orchestrator
  mamba install -c conda-forge <package>

AGENTS: Route tasks using CLAUDE.md routing table:
  bioinformatics-analyst  → omics, NGS, sequences, databases
  ml-researcher           → deep learning, GNNs, transformers, classical ML
  statistics-advisor      → Bayesian, survival analysis, experimental design
  literature-synthesizer  → literature review, writing, grants

RESOURCES: Run `python scripts/check_environment.py` before heavy compute.

OUTPUT STANDARDS:
  - Code: Python 3.10+, type hints, Google docstrings
  - Figures: 300 DPI, labeled axes, legends
  - Stats: report effect size + p-value + correction method
  - Writing: full paragraphs only (no bullet points in final docs)

PRIVACY: No PHI to disk unencrypted. Credentials from env vars only.

Skills live in scientific-skills/<name>/SKILL.md (99 total).
=== End of re-injected rules ===
RULES

exit 0
