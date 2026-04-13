---
name: bioconductor
description: Bioconductor R packages for bulk RNA-seq, differential expression, pathway analysis, and genomic data structures.
allowed-tools: Read Write Edit Bash
---

# Bioconductor for Bulk Omics

## Package Management

```r
# Install via BiocManager (never install.packages for Bioc packages)
BiocManager::install("DESeq2")
BiocManager::install(c("edgeR", "limma", "clusterProfiler", "GenomicRanges"))
BiocManager::version()   # confirm version
```

Always add Bioconductor packages to `renv.lock`:
```r
renv::snapshot()
```

## DESeq2 — Bulk RNA-seq DE

```r
library(DESeq2)
dds <- DESeqDataSetFromMatrix(countData = counts, colData = metadata, design = ~condition)
dds <- dds[rowSums(counts(dds) >= 5) >= 3, ]   # filter low counts
dds <- DESeq(dds)
res <- results(dds, contrast = c("condition", "treated", "control"),
               alpha = 0.05, lfcThreshold = 0)
res <- lfcShrink(dds, coef = "condition_treated_vs_control", type = "apeglm")
```

Always report: effect size (log2FC), BH-adjusted p-value, independent filtering threshold.

## edgeR — Count-based DE (when DESeq2 underpowered)

```r
library(edgeR)
dge <- DGEList(counts = counts, group = metadata$condition)
dge <- filterByExpr(dge)
dge <- normLibSizes(dge)
design <- model.matrix(~condition, data = metadata)
dge <- estimateDisp(dge, design)
fit <- glmQLFit(dge, design)
res <- glmQLFTest(fit, coef = 2)
topTags(res, n = 20)
```

## clusterProfiler — Pathway Enrichment

```r
library(clusterProfiler)
library(org.Hs.eg.db)

# ORA (over-representation)
ego <- enrichGO(gene = sig_genes, OrgDb = org.Hs.eg.db,
                keyType = "SYMBOL", ont = "BP",
                pAdjustMethod = "BH", pvalueCutoff = 0.05)
dotplot(ego, showCategory = 20)

# GSEA
gse <- gseGO(geneList = ranked_list, OrgDb = org.Hs.eg.db,
             keyType = "SYMBOL", ont = "BP", pAdjustMethod = "BH")
```

## GenomicRanges

```r
library(GenomicRanges)
gr <- GRanges(seqnames = "chr1", ranges = IRanges(start = 1000, end = 2000), strand = "+")
findOverlaps(gr1, gr2)
```

## SummarizedExperiment (standard container)

```r
library(SummarizedExperiment)
se <- SummarizedExperiment(assays = list(counts = count_matrix), colData = sample_info)
assay(se, "counts")
colData(se)$condition
```
