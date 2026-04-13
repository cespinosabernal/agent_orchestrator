---
name: seurat
description: Single-cell RNA-seq analysis in R with Seurat v5 — QC, normalization, clustering, annotation, and differential expression.
allowed-tools: Read Write Edit Bash
---

# Seurat v5 for Single-Cell RNA-seq

## Standard Workflow

```r
library(Seurat)
library(tidyverse)
set.seed(42)

# 1. Load and create object
counts <- Read10X("data/filtered_feature_bc_matrix/")
seu <- CreateSeuratObject(counts, min.cells = 3, min.features = 200)

# 2. QC
seu[["pct_mt"]] <- PercentageFeatureSet(seu, pattern = "^MT-")
seu <- subset(seu, nFeature_RNA > 200 & nFeature_RNA < 6000 & pct_mt < 20)
VlnPlot(seu, features = c("nFeature_RNA", "nCount_RNA", "pct_mt"), ncol = 3)

# 3. Normalize and find variable features
seu <- NormalizeData(seu)
seu <- FindVariableFeatures(seu, nfeatures = 3000)

# 4. Scale, PCA, neighbors, UMAP
seu <- ScaleData(seu)
seu <- RunPCA(seu)
ElbowPlot(seu, ndims = 30)            # choose n_dims
seu <- FindNeighbors(seu, dims = 1:20)
seu <- FindClusters(seu, resolution = 0.5)
seu <- RunUMAP(seu, dims = 1:20)

DimPlot(seu, label = TRUE)
```

## Integration (multi-sample)

```r
# Seurat v5 layer-based integration
seu <- IntegrateLayers(seu, method = HarmonyIntegration, orig.reduction = "pca")
seu <- FindNeighbors(seu, reduction = "harmony", dims = 1:20)
seu <- FindClusters(seu, resolution = 0.5)
```

## Differential Expression

```r
# All markers per cluster
markers <- FindAllMarkers(seu, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
top10 <- markers |> group_by(cluster) |> slice_max(avg_log2FC, n = 10)

# Between two conditions
Idents(seu) <- "condition"
deg <- FindMarkers(seu, ident.1 = "treated", ident.2 = "control")
```

## Save / Load

```r
saveRDS(seu, "results/seurat_clustered.rds")
seu <- readRDS("results/seurat_clustered.rds")
```

## Output Standards

- Save final objects as `.rds`.
- Export cluster markers as `.csv` in `results/`.
- UMAP colored by cluster, condition, and key markers — save at 300 DPI.
- Report cell counts per cluster/sample in the R Markdown output.
