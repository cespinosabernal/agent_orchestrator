# Scientific Agent Orchestrator

## Identity and Mission

This is a scientific agent orchestrator for **computational biology, bioinformatics, statistics, and machine learning**. It provides 104 curated skills and 9 specialized sub-agents to support the full scientific workflow: data acquisition, analysis, modeling, statistical validation, and communication.

**In scope:** single-cell and bulk omics, NGS pipelines, biological sequence analysis, statistical modeling, machine learning on biological data, time-series analysis, literature synthesis, scientific writing, and translational database queries.

**Out of scope:** financial analysis, quantum hardware control, clinical decision support, drug synthesis, materials science, geospatial mapping, and medical imaging pipelines.

Skills live in `scientific-skills/<skill-name>/SKILL.md`. Agents live in `.claude/agents/<agent-name>/AGENT.md`. Before activating a skill, confirm it exists in `scientific-skills/`.

---

## Resource Check Protocol

Before any computationally intensive task (model training, large dataset processing, NGS pipeline, dimensionality reduction on >100K cells), invoke the `get-available-resources` skill to detect available CPU cores, GPU, and RAM. Adjust batch sizes, parallelization, and in-memory vs. file-backed approaches accordingly. This is mandatory, not optional.

---

## Agent Routing

Route every task to the primary agent whose domain best matches the request. When a task spans multiple domains, coordinate agents sequentially in the order listed under Multi-Agent Coordination below.

### Routing Table

| Task Description | Primary Agent | Key Skills |
|---|---|---|
| scRNA-seq, bulk RNA-seq, ATAC-seq | bioinformatics-analyst | scanpy, scvi-tools, pydeseq2, anndata |
| NGS QC, BAM/VCF/BED file handling | bioinformatics-analyst | pysam, deeptools, tiledbvcf, polars-bio |
| DNA/protein sequence analysis, BLAST | bioinformatics-analyst | biopython, gget, scikit-bio |
| Phylogenetics, evolutionary analysis | bioinformatics-analyst | etetoolkit, phylogenetics, scikit-bio |
| Gene regulatory network inference | bioinformatics-analyst | arboreto, scvi-tools |
| RNA velocity, trajectory inference | bioinformatics-analyst | scvelo, scanpy |
| Flow cytometry (FCS files) | bioinformatics-analyst | flowio |
| Metabolic modeling, FBA | bioinformatics-analyst | cobrapy |
| Genomic interval operations | bioinformatics-analyst | polars-bio, gtars, geniml |
| Neuropixels spike sorting/analysis | bioinformatics-analyst | neuropixels-analysis |
| Database queries: GEO, UniProt, KEGG, Ensembl, Reactome, HMDB | bioinformatics-analyst | geo-database, uniprot-database, kegg-database, ensembl-database |
| Database queries: COSMIC, DepMap, cBioPortal, ClinicalTrials | bioinformatics-analyst | cosmic-database, depmap, cbioportal-database, clinicaltrials-database |
| Deep learning model training/fine-tuning | ml-researcher | pytorch-lightning, transformers |
| Graph neural networks on biological data | ml-researcher | torch-geometric, torchdrug |
| Transformer models for sequences | ml-researcher | transformers, pytorch-lightning |
| Time-series classification/forecasting | ml-researcher | timesfm-forecasting, aeon |
| Dimensionality reduction, UMAP, t-SNE | ml-researcher | umap-learn, scikit-learn |
| Classical ML pipeline (RF, SVM, XGB) | ml-researcher | scikit-learn |
| Model interpretability, feature importance | ml-researcher | shap |
| Physiological signal processing (ECG, EEG) | ml-researcher | neurokit2 |
| RL for biological optimization | ml-researcher | stable-baselines3 |
| Multi-objective optimization | ml-researcher | pymoo |
| Experimental design, power analysis | statistics-advisor | statistical-analysis, statsmodels |
| Bayesian hierarchical modeling | statistics-advisor | pymc |
| Survival analysis (Kaplan-Meier, Cox) | statistics-advisor | scikit-survival |
| GLM, mixed-effects models | statistics-advisor | statsmodels |
| Multiple testing correction, FDR | statistics-advisor | statsmodels, pydeseq2 |
| Symbolic math, formula derivation | statistics-advisor | sympy |
| Statistical comparison of ML models | statistics-advisor | statsmodels, scikit-learn |
| Literature review, database search | literature-synthesizer | literature-review, pubmed-database, openalex-database |
| Hypothesis generation from data | literature-synthesizer | hypothesis-generation, hypogenic |
| Manuscript writing (any section) | literature-synthesizer | scientific-writing |
| Grant writing (NSF, NIH, DOE) | literature-synthesizer | research-grants |
| Peer review of manuscripts | literature-synthesizer | peer-review |
| Research poster creation | literature-synthesizer | latex-posters, pptx-posters |
| Slide deck for research talk | literature-synthesizer | scientific-slides |
| Citation management | literature-synthesizer | citation-management, pyzotero |
| scRNA-seq in R (Seurat), bulk RNA-seq (DESeq2/edgeR) | r-bioinformatics-writer | seurat, bioconductor, rmarkdown |
| R Markdown reproducible report writing | r-bioinformatics-writer | rmarkdown, seurat, bioconductor |
| Publication figures in R, ggplot2, multi-panel | r-plotting-stats | ggplot2, statistical-analysis |
| Statistical tests, mixed models, power analysis in R | r-plotting-stats | ggplot2, statistical-analysis |
| Review R code (style, renv, reproducibility) | r-code-reviewer | rmarkdown |
| Review Python code (types, ruff, security) | python-code-reviewer | — |
| Create or edit a skill or skill mode | skill-writer | skill-authoring |

### Agent Definitions

- `.claude/agents/bioinformatics-analyst/AGENT.md` — NGS, omics, sequences, genomic databases (Python)
- `.claude/agents/ml-researcher/AGENT.md` — deep learning, GNNs, transformers, classical ML
- `.claude/agents/statistics-advisor/AGENT.md` — experimental design, Bayesian, survival analysis
- `.claude/agents/literature-synthesizer/AGENT.md` — literature search, writing, grants, peer review
- `.claude/agents/r-bioinformatics-writer/AGENT.md` — R-based omics analyses in R Markdown (Seurat, DESeq2)
- `.claude/agents/r-plotting-stats/AGENT.md` — publication figures and statistical tests in R (ggplot2)
- `.claude/agents/r-code-reviewer/AGENT.md` — R code review: style, renv, reproducibility, statistics
- `.claude/agents/python-code-reviewer/AGENT.md` — Python code review: types, ruff, security, docstrings
- `.claude/agents/skill-writer/AGENT.md` — create and edit skills and skill modes

---

## Multi-Agent Coordination

When a task spans multiple domains, coordinate agents in this order:

1. **bioinformatics-analyst** — acquire and preprocess data, run domain-specific analysis
2. **ml-researcher** — train/evaluate models on processed data
3. **statistics-advisor** — validate results, run significance tests, confirm assumptions
4. **literature-synthesizer** — contextualize findings, write outputs

Example: "Analyze single-cell drug screen data, train a response prediction model, and write a methods section."
→ bioinformatics-analyst (QC + dimensionality reduction) → ml-researcher (train model) → statistics-advisor (cross-validation significance) → literature-synthesizer (write methods)

Declare sub-agent handoffs explicitly: state which agent is being invoked and why before switching context.

---

## Skill Activation

When a skill is needed, it loads from `scientific-skills/<skill-name>/SKILL.md`. Acknowledge each activated skill at the start of the response. Skills with `allowed-tools: Read Write Edit Bash` in their frontmatter have elevated permissions; others are reference-only documentation.

Available skill categories:
- **Bioinformatics / Genomics Packages:** anndata, arboreto, biopython, bioservices, cobrapy, deeptools, etetoolkit, flowio, geniml, gget, gtars, neuropixels-analysis, phylogenetics, polars-bio, pydeseq2, pysam, scanpy, scikit-bio, scvelo, scvi-tools, tiledbvcf
- **Single-Cell / Spatial Biology:** cellxgene-census (plus scanpy, scvi-tools, anndata, scvelo above)
- **Databases (Biology + Literature):** arxiv-database, bgpt-paper-search, biorxiv-database, ensembl-database, gene-database, geo-database, hmdb-database, kegg-database, metabolomics-workbench-database, openalex-database, pubmed-database, reactome-database, uniprot-database
- **Clinical / Translational Databases:** bindingdb-database, brenda-database, cbioportal-database, clinpgx-database, clinicaltrials-database, cosmic-database, depmap, fda-database, opentargets-database, primekg, pyhealth
- **Statistics & ML:** aeon, neurokit2, pymc, pymoo, scikit-learn, scikit-survival, shap, stable-baselines3, statsmodels, sympy, timesfm-forecasting, umap-learn
- **Deep Learning Frameworks:** pytorch-lightning, torch-geometric, torchdrug, transformers
- **Visualization:** matplotlib, networkx, plotly, seaborn
- **Scientific Communication / Writing:** citation-management, exploratory-data-analysis, hypothesis-generation, hypogenic, latex-posters, literature-review, markdown-mermaid-writing, peer-review, pptx-posters, research-grants, scholar-evaluation, scientific-brainstorming, scientific-critical-thinking, scientific-slides, scientific-visualization, scientific-writing, statistical-analysis, venue-templates, writing
- **File Handling / Utility:** docx, get-available-resources, markitdown, matlab, parallel-web, pdf, perplexity-search, pptx, pyzotero, research-lookup, simpy, xlsx

---

## Output Standards

**Code:**
- Python 3.10+; include type hints for function signatures
- Docstrings for all functions (Google style)
- Inline comments for non-obvious logic
- No hardcoded credentials; read from environment variables

**Figures:**
- Publication quality: 300 DPI minimum, labeled axes with units, legends
- Use matplotlib for static publication figures, plotly for interactive exploration
- Multi-panel figures via scientific-visualization skill

**Statistical results:**
- Always report effect sizes alongside p-values
- Specify multiple testing correction method (e.g., Benjamini-Hochberg FDR)
- For Bayesian analyses, report posterior median + 94% HDI
- Include sample sizes for all groups

**Scientific writing:**
- Full paragraphs in final documents — no bullet points
- Methods written to enable reproduction by a competent researcher
- All claims referenced to primary literature

---

## Environment and Package Management

All Python packages must be installed using **mamba** (miniconda). Never run `pip install` directly into the base environment. Always create and activate a dedicated conda environment before installing packages.

```bash
# Create a new environment
mamba create -n sci-orchestrator python=3.11
mamba activate sci-orchestrator

# Install packages (use mamba, not pip)
mamba install -c conda-forge scanpy pytorch-lightning
```

When running scripts or advising on installation, always use `mamba install` syntax and specify the target environment. Direct `pip install` to base is forbidden.

---

## Skill Modes

Skills are symlinked into `.claude/skills/` on demand to keep context lean. By default no skills are active.

```bash
bash .claude/scripts/skills.sh activate <mode>   # enable a skill group
bash .claude/scripts/skills.sh deactivate [mode] # remove symlinks (all or one)
bash .claude/scripts/skills.sh status            # list currently active skills
```

| Mode | Contents |
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

## Project Repos

External project repositories are cloned into `repo/<project-name>/`. Each is an independent git repo — never `git add` files from `repo/` into this orchestrator repo.

```bash
git clone <url> repo/<project-name>
```

If a project has its own `CLAUDE.md`, it auto-loads when Claude works in that directory and overrides defaults for that project. Each project repo should have its own `.gitignore` covering data files, outputs, and environment directories.

---

## Data Privacy

No patient-identifiable data (PHI) should be written to disk unencrypted. If the user provides data that appears to contain PHI (patient IDs, dates of birth, clinical notes), flag it before processing and recommend de-identification. Credentials and API keys must be read from environment variables; never hardcode them in scripts.
