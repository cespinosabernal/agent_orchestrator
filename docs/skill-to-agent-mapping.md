# Skill-to-Agent Mapping

All 99 skills mapped to their primary and secondary agents. Run `python scripts/list_skills_by_agent.py` to regenerate from AGENT.md frontmatter.

## bioinformatics-analyst

### Primary Skills
| Skill | Description |
|---|---|
| scanpy | scRNA-seq analysis (QC, normalization, clustering, visualization) |
| scvi-tools | Deep generative models for single-cell omics |
| biopython | Sequence manipulation, NCBI access, file parsing |
| pysam | SAM/BAM/VCF/FASTQ handling |
| pydeseq2 | Differential gene expression (bulk RNA-seq) |
| deeptools | NGS quality control, BAM → bigWig, heatmaps |
| anndata | Annotated matrix data structure for single-cell |
| gget | Fast cross-database queries (20+ bioinformatics databases) |
| tiledbvcf | Scalable VCF/BCF storage and retrieval |
| polars-bio | High-performance genomic interval operations |
| scikit-bio | Biological data toolkit (sequences, alignments, diversity) |
| phylogenetics | Build/analyze trees with MAFFT, IQ-TREE, FastTree |
| etetoolkit | Phylogenetic tree manipulation |
| geo-database | NCBI GEO gene expression/genomics data |

### Secondary Skills
| Skill | Role |
|---|---|
| cellxgene-census | 61M+ cells for expression queries |
| scvelo | RNA velocity, trajectory inference |
| arboreto | Gene regulatory network inference |
| bioservices | Unified access to 40+ bioinformatics services |
| cobrapy | Metabolic modeling, FBA |
| flowio | Flow cytometry FCS file parsing |
| geniml | Genomic interval ML (BED files) |
| gtars | High-performance genomic interval toolkit |
| neuropixels-analysis | Neural recording analysis |
| ensembl-database | 250+ species genomic data via REST API |
| uniprot-database | Protein sequences and annotations |
| kegg-database | Pathways, genes, metabolic data |
| reactome-database | Pathway analysis and enrichment |
| hmdb-database | Human Metabolome Database |
| metabolomics-workbench-database | NIH metabolomics studies |
| pubmed-database | 35M+ citations |
| biorxiv-database | Preprints |
| bgpt-paper-search | Structured experimental data extraction |
| gene-database | NCBI Gene info |
| cbioportal-database | Cancer genomics across 1000+ studies |
| cosmic-database | Cancer somatic mutations |
| depmap | Cancer dependency map (CRISPR/RNAi) |
| opentargets-database | Target-disease associations |
| bindingdb-database | Drug-target binding affinities |
| brenda-database | Enzyme kinetic parameters |
| clinicaltrials-database | ClinicalTrials.gov |
| clinpgx-database | Pharmacogenomics (CPIC guidelines) |
| fda-database | openFDA drug/device data |
| primekg | Precision Medicine Knowledge Graph |
| pyhealth | EHR data analysis, clinical ML |

---

## ml-researcher

### Primary Skills
| Skill | Description |
|---|---|
| pytorch-lightning | Deep learning training framework |
| transformers | Pre-trained transformer models (NLP, sequences) |
| torch-geometric | Graph Neural Networks |
| torchdrug | GNNs for molecules and proteins |
| scikit-learn | Classical ML (classification, regression, clustering) |
| umap-learn | UMAP dimensionality reduction |
| shap | Model interpretability with Shapley values |
| timesfm-forecasting | Zero-shot time series forecasting (Google TimesFM) |
| aeon | Time series ML (classification, regression, forecasting) |
| neurokit2 | Physiological signal processing (ECG, EDA, EMG, PPG) |

### Secondary Skills
| Skill | Role |
|---|---|
| stable-baselines3 | RL algorithms (PPO, SAC, DQN, TD3) |
| pymoo | Multi-objective optimization |
| statsmodels | Statistical models for comparison |
| seaborn | Statistical visualization |
| matplotlib | Publication-quality figures |
| plotly | Interactive visualization |
| networkx | Network analysis |
| sympy | Symbolic mathematics |
| scvelo | RNA velocity (biological ML application) |
| scvi-tools | Deep generative models |

---

## statistics-advisor

### Primary Skills
| Skill | Description |
|---|---|
| pymc | Bayesian modeling with MCMC |
| statsmodels | OLS, GLM, mixed models, ARIMA |
| scikit-survival | Survival analysis and time-to-event modeling |
| statistical-analysis | Guided statistical analysis with test selection |
| shap | Model interpretability |
| sympy | Symbolic formula derivation |
| pymoo | Multi-objective optimization of experimental parameters |
| scikit-learn | Cross-validated model evaluation |

### Secondary Skills
| Skill | Role |
|---|---|
| matplotlib | Statistical plots |
| seaborn | Statistical visualization |
| plotly | Interactive statistical plots |
| aeon | Time-series statistical analysis |
| timesfm-forecasting | Forecasting baseline comparison |
| pydeseq2 | DEG multiple testing correction |
| neurokit2 | Physiological signal statistics |

---

## literature-synthesizer

### Primary Skills
| Skill | Description |
|---|---|
| literature-review | Systematic and narrative literature reviews |
| scientific-writing | Manuscript drafting (IMRAD structure) |
| hypothesis-generation | Structured hypothesis formulation |
| peer-review | Structured manuscript evaluation |
| research-grants | Grant writing (NSF, NIH, DOE, DARPA) |
| pubmed-database | 35M+ citations |
| openalex-database | 240M+ scholarly works |
| arxiv-database | Physics, math, CS, bio preprints |
| bgpt-paper-search | Structured experimental data from papers |
| hypogenic | Automated hypothesis testing on tabular data |

### Secondary Skills
| Skill | Role |
|---|---|
| biorxiv-database | Biology preprints |
| perplexity-search | Web search (academic focus) |
| parallel-web | Web research and extraction |
| research-lookup | General research queries |
| citation-management | Reference metadata and BibTeX |
| pyzotero | Zotero reference management |
| scholar-evaluation | Systematic scholarly evaluation |
| scientific-brainstorming | Creative research ideation |
| scientific-critical-thinking | Evaluate scientific claims |
| latex-posters | Research posters (LaTeX beamerposter) |
| scientific-slides | Slide decks for research talks |
| pptx-posters | Research posters (HTML/CSS → PDF/PPTX) |
| venue-templates | Conference/journal submission formatting |
| exploratory-data-analysis | EDA for results interpretation |
| scientific-visualization | Multi-panel publication figures |
| markdown-mermaid-writing | Markdown and Mermaid diagrams |
| writing | High-quality academic/technical prose |

---

## Orphaned Skills (not directly mapped to an agent, but available)

These skills are used by all agents as needed:

| Skill | Description |
|---|---|
| matplotlib | Plotting (used by all agents) |
| seaborn | Statistical visualization |
| plotly | Interactive visualization |
| networkx | Network/graph analysis |
| get-available-resources | Detect CPU/GPU/RAM before heavy compute |
| exploratory-data-analysis | General EDA |
| docx | Read/write Word documents |
| pdf | Read/extract PDF content |
| pptx | Read/write PowerPoint |
| xlsx | Read/write Excel |
| markitdown | Convert files to Markdown |
| matlab | MATLAB integration |
| perplexity-search | Web search |
| parallel-web | Web research |
| research-lookup | Research queries |
| simpy | Discrete-event simulation |
| sympy | Symbolic mathematics |
| citation-management | Reference management |
| pyzotero | Zotero integration |
