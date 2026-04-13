# Scientific Agent Orchestrator

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)
[![Skills](https://img.shields.io/badge/Skills-104-brightgreen.svg)](#skill-modes)
[![Agents](https://img.shields.io/badge/Agents-9-blueviolet.svg)](#agents)
[![Works with](https://img.shields.io/badge/Works_with-Claude_Code-blue.svg)](#getting-started)

A scientific agent orchestrator for **Claude Code**, focused on **computational biology, bioinformatics, statistics, and machine learning**. Provides 104 curated skills and 9 specialized sub-agents that route scientific tasks intelligently across domains.

**In scope:** single-cell and bulk omics, NGS pipelines, biological sequence analysis, statistical modeling, machine learning on biological data, literature synthesis, and scientific writing.

**Out of scope:** financial analysis, drug synthesis, materials science, quantum hardware, medical imaging pipelines, and clinical decision support.

---

## Agents

| Agent | Domain |
|---|---|
| [bioinformatics-analyst](.claude/agents/bioinformatics-analyst/AGENT.md) | NGS, single-cell omics, sequence analysis, genomic databases (Python) |
| [ml-researcher](.claude/agents/ml-researcher/AGENT.md) | Deep learning, GNNs, transformers, time-series, classical ML |
| [statistics-advisor](.claude/agents/statistics-advisor/AGENT.md) | Experimental design, Bayesian inference, survival analysis |
| [literature-synthesizer](.claude/agents/literature-synthesizer/AGENT.md) | Literature review, hypothesis generation, scientific writing, grants |
| [r-bioinformatics-writer](.claude/agents/r-bioinformatics-writer/AGENT.md) | R-based omics analyses as reproducible R Markdown (Seurat, DESeq2) |
| [r-plotting-stats](.claude/agents/r-plotting-stats/AGENT.md) | Publication figures and statistical tests in R (ggplot2, lme4) |
| [r-code-reviewer](.claude/agents/r-code-reviewer/AGENT.md) | R code review: tidyverse style, renv, reproducibility, statistical validity |
| [python-code-reviewer](.claude/agents/python-code-reviewer/AGENT.md) | Python code review: type hints, ruff, security, docstrings, tests |
| [skill-writer](.claude/agents/skill-writer/AGENT.md) | Create and edit skills and skill modes |

Multi-agent coordination and full routing table: [CLAUDE.md](CLAUDE.md).

---

## Getting Started

### 1. Clone and open

```bash
git clone <this-repo-url>
cd agent_orchestrator
```

Open the repo in VS Code with the Claude Code extension, or run `claude` from the repo root. `CLAUDE.md` is auto-discovered and activates the orchestrator.

### 2. Create a conda environment

All Python packages must be installed with **mamba** (miniconda). Never `pip install` into the base environment.

```bash
mamba create -n sci-orchestrator python=3.11
mamba activate sci-orchestrator
```

### 3. Activate skills

Skills are loaded on demand via a symlink system. By default no skills are active (keeps context lean).

```bash
# See available modes
bash .claude/scripts/skills.sh status

# Activate a mode
bash .claude/scripts/skills.sh activate bioinformatics

# Activate multiple modes
bash .claude/scripts/skills.sh activate ml
bash .claude/scripts/skills.sh activate stats

# Activate everything
bash .claude/scripts/skills.sh activate all

# Deactivate
bash .claude/scripts/skills.sh deactivate all
```

Three skills are always active regardless of mode: `plan`, `handoff`, and `retrospective`.

---

## Skill Modes

| Mode | Skills (≤15 per mode) |
|---|---|
| `bioinformatics` | scanpy, scvi-tools, biopython, pydeseq2, anndata, pysam, deeptools, polars-bio, scikit-bio, cellxgene-census, gget, scvelo, arboreto, tiledbvcf, cobrapy |
| `bioinformatics-extended` | etetoolkit, phylogenetics, flowio, geniml, gtars, neuropixels-analysis, bioservices |
| `ml` | pytorch-lightning, transformers, torch-geometric, scikit-learn, umap-learn, shap, timesfm-forecasting, aeon, neurokit2, stable-baselines3, pymoo, torchdrug |
| `stats` | pymc, statsmodels, scikit-survival, statistical-analysis, sympy |
| `databases` | geo-database, uniprot-database, kegg-database, ensembl-database, pubmed-database, biorxiv-database, arxiv-database, openalex-database, gene-database, reactome-database, bgpt-paper-search, hmdb-database |
| `clinical-databases` | cbioportal-database, depmap, bindingdb-database, brenda-database, clinpgx-database, fda-database, metabolomics-workbench-database, opentargets-database, primekg, pyhealth, clinicaltrials-database, cosmic-database |
| `writing` | literature-review, scientific-writing, hypothesis-generation, peer-review, research-grants, scientific-brainstorming, scientific-visualization, scientific-slides, exploratory-data-analysis, general-writing, markdown-mermaid-writing, rmarkdown, scholar-evaluation, scientific-critical-thinking, venue-templates |
| `publishing` | citation-management, pyzotero, latex-posters, pptx-posters, hypogenic, scientific-schematics |
| `utility` | docx, pdf, pptx, xlsx, markitdown, matlab, perplexity-search, parallel-web, research-lookup, get-available-resources, jupyter-notebooks, simpy, skill-authoring |
| `visualization` | matplotlib, networkx, plotly, seaborn, ggplot2 |
| `r` | rmarkdown, seurat, bioconductor, ggplot2 |
| `all` | Everything in `scientific-skills/` |

---

## What's Included

### Skills (104 total)

Skills live in `scientific-skills/<group>/<skill>/SKILL.md` and are organized into groups:

**Bioinformatics & Genomics** — scanpy, scvi-tools, biopython, pydeseq2, anndata, pysam, deeptools, polars-bio, scikit-bio, cellxgene-census, gget, scvelo, arboreto, tiledbvcf, cobrapy, etetoolkit, phylogenetics, flowio, geniml, gtars, neuropixels-analysis, bioservices, seurat, bioconductor

**Databases — Literature & Omics** — geo, uniprot, kegg, ensembl, pubmed, biorxiv, arxiv, openalex, gene, reactome, bgpt-paper-search, hmdb

**Databases — Clinical & Translational** — cbioportal, depmap, bindingdb, brenda, clinpgx, fda, metabolomics-workbench, opentargets, primekg, pyhealth, clinicaltrials, cosmic

**Machine Learning** — pytorch-lightning, transformers, torch-geometric, torchdrug, scikit-learn, umap-learn, shap, timesfm-forecasting, aeon, neurokit2, stable-baselines3, pymoo

**Statistics** — pymc, statsmodels, scikit-survival, statistical-analysis, sympy

**Visualization** — matplotlib, seaborn, plotly, networkx, ggplot2

**Writing & Communication** — literature-review, scientific-writing, general-writing, hypothesis-generation, peer-review, research-grants, scientific-brainstorming, scientific-visualization, scientific-slides, exploratory-data-analysis, markdown-mermaid-writing, rmarkdown, scholar-evaluation, scientific-critical-thinking, venue-templates

**Publishing** — citation-management, pyzotero, latex-posters, pptx-posters, hypogenic, scientific-schematics

**Utility** — docx, pdf, pptx, xlsx, markitdown, matlab, perplexity-search, parallel-web, research-lookup, get-available-resources, jupyter-notebooks, simpy, skill-authoring

### Always-active skills

| Skill | Purpose |
|---|---|
| `plan` | Enter planning mode before complex implementations |
| `handoff` | Save session context for continuity across conversations |
| `retrospective` | Reflect on a session: what worked, what didn't, next steps |

---

## Quick Examples

### Single-Cell RNA-seq Analysis

```
Activate bioinformatics skills. Load a 10X Genomics dataset with Scanpy, perform QC
and doublet removal, integrate with CellxGene Census public data, identify cell types
using marker genes from NCBI Gene, run differential expression with PyDESeq2, infer
gene regulatory networks with Arboreto, and enrich pathways via Reactome and KEGG.
```

### Multi-Omics Biomarker Discovery

```
Activate bioinformatics, stats, and databases skills. Analyze RNA-seq with PyDESeq2,
integrate metabolites from HMDB, map proteins to pathways via UniProt and KEGG,
correlate omics layers with statsmodels, build a predictive model with scikit-learn,
and search ClinicalTrials.gov for relevant trials.
```

### Deep Learning on Biological Sequences

```
Activate ml skills. Fine-tune a protein language model with PyTorch Lightning and
Transformers on a custom dataset, evaluate with scikit-learn metrics, and explain
predictions with SHAP.
```

### Bayesian Experimental Design

```
Activate stats skills. Use PyMC to fit a hierarchical model to pilot data, compute
posterior predictive distributions, and determine sample size for 80% power at the
desired effect size.
```

### R-Based Seurat Analysis

```
Use the r-bioinformatics-writer agent to perform a full Seurat v5 scRNA-seq analysis
as a reproducible R Markdown document, with DESeq2 for differential expression and
clusterProfiler for pathway enrichment.
```

---

## Repository Structure

```
agent_orchestrator/
├── CLAUDE.md                      # Master orchestrator config — routing, modes, standards
├── scientific-skills/             # All 104 skills, grouped by domain
│   ├── bioinformatics/
│   ├── databases/
│   ├── ml/
│   ├── stats/
│   ├── utility/
│   ├── visualization/
│   └── writing/
├── .claude/
│   ├── agents/                    # 9 sub-agent definitions (AGENT.md)
│   ├── hooks/                     # Auto-formatting (ruff, styler) and safety guards
│   ├── rules/                     # Path-scoped style rules (python.md, r.md, git.md)
│   ├── scripts/
│   │   └── skills.sh              # Skill activation via symlinks
│   ├── skills/                    # Active skill symlinks (git-ignored) + always-on skills
│   ├── planning/                  # Session plans (git-ignored)
│   ├── retrospectives/            # Session retrospectives (git-ignored)
│   └── handoffs/                  # Session handoffs (git-ignored)
└── repo/                          # External project repos cloned here (git-ignored)
```

---

## Hooks

Hooks run automatically on every session:

| Hook | Trigger | Action |
|---|---|---|
| `post-edit-format.sh` | After editing `.py`, `.R`, `.Rmd`, `.qmd` | Runs `ruff format` + `ruff check` (Python) or `styler` + `lintr` (R) |
| `pre-bash-safety.sh` | Before any Bash command | Blocks `pip install` to base, force-push to main, inline credentials, `rm -rf /` |

---

## Package Management

All Python packages must be installed with **mamba** (miniconda). Direct `pip install` to base is blocked by the pre-bash hook.

```bash
# Create environment
mamba create -n sci-orchestrator python=3.11
mamba activate sci-orchestrator

# Install packages
mamba install -c conda-forge scanpy pytorch-lightning

# Lock environment
conda env export > environment.yml
```

For R: use `renv` for dependency management within each project.

---

## Prerequisites

- **Claude Code** (CLI or VS Code extension)
- **Python 3.11+** with mamba/miniconda
- **R 4.3+** (optional, for R-based agents and skills)
- macOS, Linux, or Windows with WSL2

---

## Security

Skills can execute code and influence agent behavior. Review any skill before activating it. The pre-bash hook blocks the most common unsafe operations, but skills with `allowed-tools: Bash` can still run arbitrary commands within their scope.

- Never commit `.env` files, API keys, or patient data
- No PHI should be written to disk unencrypted — the orchestrator will flag suspected PHI before processing
- Credentials must be read from environment variables

---

## Contributing

To add or modify a skill, use the `skill-writer` agent or follow the format in any existing `SKILL.md`. New skills should be placed in the appropriate `scientific-skills/<group>/` directory and added to the relevant mode array in `.claude/scripts/skills.sh`.

---

## License

MIT — see [LICENSE.md](LICENSE.md).
