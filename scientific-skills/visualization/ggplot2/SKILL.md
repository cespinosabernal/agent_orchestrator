---
name: ggplot2
description: Publication-quality plotting in R with ggplot2 — grammar of graphics, themes, multi-panel figures, and export.
allowed-tools: Read Write Edit Bash
---

# ggplot2 for Publication Figures

## Core Grammar

```r
library(ggplot2)
library(patchwork)   # multi-panel
library(scales)      # axis formatting
library(ggrepel)     # non-overlapping labels

p <- ggplot(df, aes(x = condition, y = expression, fill = group)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.2, alpha = 0.4, size = 1) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title  = "Gene Expression by Condition",
    x      = "Condition",
    y      = "Normalized expression (log2)",
    fill   = "Group"
  ) +
  theme_classic(base_size = 10)
```

## Publication Theme

```r
theme_pub <- theme_classic(base_size = 10) +
  theme(
    axis.text        = element_text(size = 8),
    axis.title       = element_text(size = 9),
    legend.text      = element_text(size = 8),
    legend.title     = element_text(size = 9),
    strip.background = element_blank(),
    strip.text       = element_text(size = 9, face = "bold"),
    plot.title       = element_text(size = 10, face = "bold")
  )
```

## Multi-Panel Figures (patchwork)

```r
p1 <- ggplot(df, aes(x, y)) + geom_point() + theme_pub
p2 <- ggplot(df, aes(group, value)) + geom_boxplot() + theme_pub

# Combine with labels
(p1 | p2) + plot_annotation(tag_levels = "A")
```

## Common Plot Types

| Plot type | Geom |
|---|---|
| Scatter | `geom_point()` |
| Box/violin | `geom_violin() + geom_boxplot(width=0.1)` |
| Bar + error | `geom_col() + geom_errorbar()` |
| Heatmap | `geom_tile() + scale_fill_viridis_c()` |
| Volcano | `geom_point() + ggrepel::geom_label_repel()` |
| Survival | `survminer::ggsurvplot()` |

## Export (300 DPI minimum)

```r
ggsave("figure1.pdf", plot = p, width = 6, height = 4, units = "in")
ggsave("figure1.png", plot = p, width = 6, height = 4, dpi = 300)
```

## Color Palettes

```r
scale_fill_brewer(palette = "Set2")        # categorical, colorblind-safe
scale_color_viridis_c()                    # continuous, perceptually uniform
scale_fill_manual(values = c("#E41A1C", "#377EB8", "#4DAF4A"))  # custom
```
