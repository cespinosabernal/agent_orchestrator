#!/usr/bin/env bash
# .claude/scripts/skills.sh
# Skill mode activation for the scientific agent orchestrator.
# Creates/removes symlinks in .claude/skills/ so skills are visible to Claude
# only when needed, keeping context lean by default.
#
# Usage:
#   bash .claude/scripts/skills.sh activate <mode>   # symlink a skill group
#   bash .claude/scripts/skills.sh deactivate [mode] # remove symlinks (all or one mode)
#   bash .claude/scripts/skills.sh status            # list currently active skills

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SKILLS_SRC="$REPO_ROOT/scientific-skills"
SKILLS_DIR="$REPO_ROOT/.claude/skills"

# ── Skill group definitions ──────────────────────────────────────────────────

SKILLS_bioinformatics=(
  scanpy scvi-tools biopython pydeseq2 anndata pysam deeptools
  polars-bio scikit-bio cellxgene-census gget scvelo
  arboreto tiledbvcf cobrapy
)

SKILLS_bioinformatics_extended=(
  etetoolkit phylogenetics flowio geniml gtars neuropixels-analysis bioservices
)

SKILLS_ml=(
  pytorch-lightning transformers torch-geometric scikit-learn
  umap-learn shap timesfm-forecasting aeon neurokit2 stable-baselines3
  pymoo torchdrug
)

SKILLS_stats=(
  pymc statsmodels scikit-survival statistical-analysis sympy
)

SKILLS_databases=(
  geo-database uniprot-database kegg-database ensembl-database
  pubmed-database biorxiv-database arxiv-database openalex-database
  gene-database reactome-database bgpt-paper-search hmdb-database
)

SKILLS_clinical_databases=(
  cbioportal-database depmap bindingdb-database brenda-database
  clinpgx-database fda-database metabolomics-workbench-database
  opentargets-database primekg pyhealth clinicaltrials-database cosmic-database
)

SKILLS_writing=(
  literature-review scientific-writing hypothesis-generation peer-review
  research-grants scientific-brainstorming scientific-visualization
  scientific-slides exploratory-data-analysis general-writing markdown-mermaid-writing
  rmarkdown scholar-evaluation scientific-critical-thinking venue-templates
)

SKILLS_publishing=(
  citation-management pyzotero latex-posters pptx-posters hypogenic
  scientific-schematics
)

SKILLS_utility=(
  docx pdf pptx xlsx markitdown matlab perplexity-search
  parallel-web research-lookup get-available-resources jupyter-notebooks simpy
  skill-authoring
)

SKILLS_visualization=(
  matplotlib networkx plotly seaborn ggplot2
)

# R mode — R-specific skills for bioinformatics, plotting, and reporting
SKILLS_r=(
  rmarkdown seurat bioconductor ggplot2
)

# ── Helpers ──────────────────────────────────────────────────────────────────

group_skills() {
  local mode="$1"
  local varname="SKILLS_${mode//-/_}[@]"
  echo "${!varname:-}"
}

all_skill_names() {
  # Skills are now nested: scientific-skills/<group>/<skill>
  find "$SKILLS_SRC" -mindepth 2 -maxdepth 2 -type d | xargs -I{} basename {}
}

activate_skill() {
  local skill="$1"
  # Skills now live in scientific-skills/<group>/<skill>; search depth 2
  local src
  src=$(find "$SKILLS_SRC" -mindepth 2 -maxdepth 2 -type d -name "$skill" | head -1)
  if [[ -z "$src" ]]; then
    echo "  SKIP $skill (not found in scientific-skills/)"
    return
  fi
  local dst="$SKILLS_DIR/$skill"
  if [[ -L "$dst" ]]; then
    return  # already linked
  fi
  ln -s "$src" "$dst"
  echo "  + $skill"
}

deactivate_skill() {
  local skill="$1"
  local dst="$SKILLS_DIR/$skill"
  if [[ -L "$dst" ]]; then
    rm "$dst"
    echo "  - $skill"
  fi
}

# ── Commands ─────────────────────────────────────────────────────────────────

cmd_activate() {
  local mode="${1:-}"
  if [[ -z "$mode" ]]; then
    echo "Usage: skills.sh activate <mode>"
    echo "Modes: bioinformatics bioinformatics-extended ml stats databases clinical-databases writing publishing utility visualization r all"
    exit 1
  fi

  echo "Activating skill mode: $mode"

  if [[ "$mode" == "all" ]]; then
    while IFS= read -r skill; do
      activate_skill "$skill"
    done < <(all_skill_names)
  else
    # Validate mode
    local varname="SKILLS_${mode//-/_}[@]"
    if [[ -z "${!varname+x}" ]]; then
      echo "Unknown mode: $mode"
      echo "Valid modes: bioinformatics bioinformatics-extended ml stats databases clinical-databases writing publishing utility visualization r all"
      exit 1
    fi
    local skills
    IFS=" " read -r -a skills <<< "$(group_skills "$mode")"
    for skill in "${skills[@]}"; do
      activate_skill "$skill"
    done
  fi

  echo "Done. Active skills: $(ls "$SKILLS_DIR" | grep -v '\.gitkeep' | wc -l | tr -d ' ')"
}

cmd_deactivate() {
  local mode="${1:-all}"

  if [[ "$mode" == "all" ]]; then
    echo "Deactivating all skills"
    while IFS= read -r link; do
      [[ "$link" == ".gitkeep" ]] && continue
      deactivate_skill "$link"
    done < <(ls "$SKILLS_DIR")
  else
    local varname="SKILLS_${mode//-/_}[@]"
    if [[ -z "${!varname+x}" ]]; then
      echo "Unknown mode: $mode"
      exit 1
    fi
    echo "Deactivating skill mode: $mode"
    local skills
    IFS=" " read -r -a skills <<< "$(group_skills "$mode")"
    for skill in "${skills[@]}"; do
      deactivate_skill "$skill"
    done
  fi

  echo "Done. Active skills: $(ls "$SKILLS_DIR" | grep -v '\.gitkeep' | wc -l | tr -d ' ')"
}

cmd_status() {
  local active
  active=$(ls "$SKILLS_DIR" | grep -v '\.gitkeep' || true)
  if [[ -z "$active" ]]; then
    echo "No skills active. Run: bash .claude/scripts/skills.sh activate <mode>"
    echo "Modes: bioinformatics bioinformatics-extended ml stats databases clinical-databases writing publishing utility visualization r all"
  else
    local count
    count=$(echo "$active" | wc -l | tr -d ' ')
    echo "Active skills ($count):"
    echo "$active" | sed 's/^/  /'
  fi
}

# ── Dispatch ─────────────────────────────────────────────────────────────────

CMD="${1:-status}"
shift || true

case "$CMD" in
  activate)   cmd_activate "$@" ;;
  deactivate) cmd_deactivate "$@" ;;
  status)     cmd_status ;;
  *)
    echo "Usage: skills.sh <activate|deactivate|status> [mode]"
    exit 1
    ;;
esac
