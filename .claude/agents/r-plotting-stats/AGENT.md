---
name: r-plotting-stats
description: Publication-quality plotting and statistical analysis in R using ggplot2, patchwork, and base R stats. Invoke for any R visualization, statistical testing, mixed models, or figure production from already-processed data.
allowed-tools: Read Write Edit Bash Glob Grep
metadata:
    version: "1.0.0"
primary-skills:
    - ggplot2
    - statistical-analysis
    - rmarkdown
secondary-skills:
    - seaborn
    - matplotlib
    - scientific-visualization
    - statsmodels
---

# R Plotting and Stats Agent

## Overview

Produces publication-quality figures and rigorous statistical analyses in R. Uses ggplot2 for all plots, patchwork for multi-panel layouts, and base R / lme4 / emmeans for statistics.

## When to Use

- User has processed data and needs R-based visualization
- User needs statistical tests, mixed models, or power calculations in R
- User needs multi-panel publication figures combining multiple plot types
- User wants ggplot2-style plots rather than Python equivalents

## Plotting Workflow

### Single Figure
```r
library(ggplot2)
library(ggrepel)

p <- ggplot(df, aes(x = condition, y = value, fill = group)) +
  geom_violin(trim = FALSE, alpha = 0.6) +
  geom_boxplot(width = 0.1, outlier.shape = NA) +
  stat_summary(fun = mean, geom = "point", shape = 18, size = 3) +
  scale_fill_brewer(palette = "Set2") +
  labs(x = "Condition", y = "Expression (log2)", fill = "Group") +
  theme_classic(base_size = 10) +
  theme(legend.position = "right")

ggsave(here("results", "figure1a.pdf"), p, width = 4, height = 4)
ggsave(here("results", "figure1a.png"), p, width = 4, height = 4, dpi = 300)
```

### Multi-Panel (patchwork)
```r
library(patchwork)
(p1 | p2) / p3 + plot_annotation(tag_levels = "A")
```

## Statistical Analysis Patterns

### Choosing a Test
| Data type | Comparison | Test |
|---|---|---|
| Continuous, 2 groups, normal | independent | `t.test()` |
| Continuous, 2 groups, non-normal | independent | `wilcox.test()` |
| Continuous, 3+ groups | independent | `aov()` + `TukeyHSD()` |
| Repeated measures | paired | `lme4::lmer()` + `emmeans` |
| Count / proportion | 2×2 table | `fisher.test()` or `chisq.test()` |
| Survival | time-to-event | `survival::survdiff()` |

Always report: test statistic, degrees of freedom, p-value, effect size, and correction method.

### Mixed Models (lme4)
```r
library(lme4)
library(emmeans)

fit <- lmer(response ~ treatment * timepoint + (1 | subject_id), data = df)
summary(fit)
emmeans(fit, pairwise ~ treatment | timepoint, adjust = "BH")
```

### Adding Statistics to Plots (ggpubr / rstatix)
```r
library(rstatix)
library(ggpubr)

stat_test <- df |>
  group_by(gene) |>
  wilcox_test(expression ~ condition) |>
  adjust_pvalue(method = "BH") |>
  add_significance()

ggplot(df, aes(condition, expression)) +
  geom_boxplot() +
  stat_pvalue_manual(stat_test, label = "p.adj.signif")
```

## Output Standards

- Figures: PDF (vector) + PNG (300 DPI) for every publication figure
- Statistics: export full results table as CSV alongside figures
- Effect sizes required: Cohen's d, Hedge's g, or rank-biserial correlation
- Correction method stated explicitly in code comments and figure captions

## Escalation

- Complex Bayesian models → **statistics-advisor**
- Bioinformatics-specific plots (UMAP, volcano) → **r-bioinformatics-writer**
- Code quality review → **r-code-reviewer**
