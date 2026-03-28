# Agent Routing Guide

This guide explains when to use each of the four agents and provides examples of how tasks are routed.

---

## Quick Reference

| If the task involves... | Use this agent |
|---|---|
| Sequencing data, omics files, genomic databases | bioinformatics-analyst |
| Training models, GNNs, transformers, dimensionality reduction | ml-researcher |
| Statistical tests, Bayesian models, experimental design | statistics-advisor |
| Literature search, writing, grants, hypothesis generation | literature-synthesizer |

---

## bioinformatics-analyst

**Trigger phrases:** scRNA-seq, bulk RNA-seq, ATAC-seq, BAM, VCF, FASTQ, FASTA, biopython, scanpy, anndata, pysam, phylogenetics, GEO, UniProt, KEGG, gene expression, variant annotation, NGS, single-cell, trajectory, RNA velocity, flow cytometry, Neuropixels, metabolic model

**Example queries → skills activated:**

- "Analyze this 10X scRNA-seq dataset and identify cell types"
  → scanpy, anndata, scvi-tools

- "Run differential expression on bulk RNA-seq between treated and control"
  → pydeseq2, statsmodels (→ statistics-advisor for interpretation)

- "Build a phylogenetic tree from these 16S rRNA sequences"
  → biopython, phylogenetics, etetoolkit

- "Query GEO for lung cancer RNA-seq datasets"
  → geo-database, gget

- "Perform genomic interval overlap analysis on these BED files"
  → polars-bio, gtars

- "Run flux balance analysis on this metabolic model"
  → cobrapy, kegg-database

---

## ml-researcher

**Trigger phrases:** train, fine-tune, GNN, graph neural network, transformer, BERT, model, PyTorch, deep learning, UMAP, t-SNE, dimensionality reduction, time series forecast, classification, regression, reinforcement learning, SHAP, feature importance, epoch, batch size, loss function

**Example queries → skills activated:**

- "Train a GNN to predict gene-gene interactions from this network"
  → torch-geometric, pytorch-lightning

- "Fine-tune a protein language model on these sequences"
  → transformers, pytorch-lightning

- "Build a UMAP visualization of this single-cell embedding"
  → umap-learn, matplotlib

- "Forecast gene expression time series using TimesFM"
  → timesfm-forecasting, aeon

- "Train a random forest classifier and compute SHAP values"
  → scikit-learn, shap, matplotlib

- "Process ECG signals and extract HRV features"
  → neurokit2

---

## statistics-advisor

**Trigger phrases:** p-value, significance, power analysis, sample size, Bayesian, prior, posterior, MCMC, survival analysis, Kaplan-Meier, Cox regression, GLM, mixed model, ANOVA, t-test, FDR, multiple testing, confidence interval, effect size

**Example queries → skills activated:**

- "How many samples do I need to detect a 20% difference in expression?"
  → statistical-analysis, statsmodels

- "Build a Bayesian hierarchical model for this dose-response data"
  → pymc

- "Run survival analysis on this clinical cohort"
  → scikit-survival, matplotlib

- "Fit a negative binomial GLM to these count data"
  → statsmodels

- "Apply Benjamini-Hochberg correction to these 10,000 p-values"
  → statsmodels, pydeseq2

- "Symbolically derive the Fisher information for this likelihood"
  → sympy

---

## literature-synthesizer

**Trigger phrases:** literature review, search papers, PubMed, hypothesis, write, draft, manuscript, grant, peer review, poster, slides, citations, what is known about, summarize findings, introduction section, methods section, discussion

**Example queries → skills activated:**

- "Find all papers on CRISPR base editing published in 2023-2024"
  → pubmed-database, openalex-database, literature-review

- "Generate three testable hypotheses from these scRNA-seq findings"
  → hypothesis-generation, hypogenic, scientific-brainstorming

- "Write the Methods section for this scRNA-seq analysis"
  → scientific-writing

- "Write a NIH R01 Significance section for this project"
  → research-grants

- "Peer review this draft manuscript on spatial transcriptomics"
  → peer-review, scientific-critical-thinking

- "Create a conference poster for these results"
  → latex-posters, scientific-visualization

---

## Multi-Agent Examples

### "Analyze single-cell drug screen data, train a prediction model, and write the methods"

1. **bioinformatics-analyst** — Load H5AD, QC, normalize, cluster, identify drug-response signatures
2. **ml-researcher** — Train GNN or classifier on cell embeddings; evaluate with cross-validation
3. **statistics-advisor** — Run paired significance tests comparing model variants; confirm FDR correction
4. **literature-synthesizer** — Write Methods section covering all three phases

### "Do a meta-analysis of published GWAS for Type 2 Diabetes"

1. **literature-synthesizer** — Search pubmed-database + openalex-database for GWAS studies
2. **bioinformatics-analyst** — Pull summary statistics, annotate variants with ensembl-database
3. **statistics-advisor** — Run fixed/random effects meta-analysis with statsmodels
4. **literature-synthesizer** — Write results and discussion sections

### "Build a time-series classifier for longitudinal microbiome data and report statistics"

1. **bioinformatics-analyst** — Load OTU table, QC, normalize
2. **ml-researcher** — Train aeon time-series classifier, tune with pymoo
3. **statistics-advisor** — Statistical comparison of classifier vs. baseline
4. **literature-synthesizer** — Contextualize findings against prior microbiome literature
