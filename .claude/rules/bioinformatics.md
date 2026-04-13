# Bioinformatics Standards

## Resource Check
Before any compute-intensive task (training, >100K cells, NGS pipeline), run:
```
python .claude/scripts/check_environment.py --quick
```
Adjust batch sizes and in-memory vs. file-backed strategies based on available RAM/GPU.

## Output Standards

### Figures
- Minimum 300 DPI for publication-quality exports.
- All axes labeled with units; legends included.
- Multi-panel figures use consistent font sizes (8-10pt for labels).
- Use `matplotlib` for static publication figures, `plotly` for interactive exploration.

### Statistical Results
- Always report effect sizes alongside p-values (Cohen's d, OR, HR, etc.).
- Specify multiple testing correction method (default: Benjamini-Hochberg FDR).
- For Bayesian analyses: posterior median + 94% HDI (not just point estimates).
- Include sample sizes (n) for all groups in figures or captions.

### Scientific Writing
- Methods written at sufficient detail for reproduction by a competent researcher.
- All quantitative claims backed by inline statistics.
- Full paragraphs in final documents — no bullet points.

## File Formats
- Single-cell: use `.h5ad` (AnnData) as primary format.
- Genomics: prefer compressed formats (`.bam`, `.bcf`, `.vcf.gz`).
- Large matrices: use `.zarr` or HDF5-backed formats, not CSV.
- Figures: `.pdf` for vector, `.png` (300 DPI) for raster.

## Data Privacy
- No PHI (patient IDs, DOBs, clinical notes) unencrypted on disk.
- De-identify data before any analysis. Flag suspected PHI immediately.
- API keys and credentials: environment variables only, never hardcoded.
