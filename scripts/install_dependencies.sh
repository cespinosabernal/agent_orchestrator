#!/usr/bin/env bash
# install_dependencies.sh
# Install Python packages for the scientific agent orchestrator using mamba.
# IMPORTANT: Never use pip install into base. Always activate a conda env first.
#
# Setup:
#   mamba create -n sci-orchestrator python=3.11
#   mamba activate sci-orchestrator
#   bash scripts/install_dependencies.sh [--agent <domain>]
#
# Usage:
#   bash scripts/install_dependencies.sh              # install all domains
#   bash scripts/install_dependencies.sh --agent bioinformatics
#   bash scripts/install_dependencies.sh --agent ml
#   bash scripts/install_dependencies.sh --agent statistics
#   bash scripts/install_dependencies.sh --agent literature
#   bash scripts/install_dependencies.sh --agent utility

set -euo pipefail

AGENT="all"

if [[ "${1:-}" == "--agent" ]]; then
    AGENT="${2:-all}"
fi

require_mamba() {
    if ! command -v mamba &>/dev/null; then
        echo "ERROR: mamba not found." >&2
        echo "Install Miniconda/Mambaforge and run: mamba create -n sci-orchestrator python=3.11" >&2
        exit 1
    fi
    # Warn if we appear to be in base
    if [[ "${CONDA_DEFAULT_ENV:-base}" == "base" ]]; then
        echo "WARNING: You appear to be in the base conda environment."
        echo "Run: mamba activate sci-orchestrator (or your environment name)"
        read -r -p "Continue anyway? [y/N] " confirm
        [[ "${confirm,,}" == "y" ]] || exit 1
    fi
}

install_bioinformatics() {
    echo "=== Installing bioinformatics packages ==="
    mamba install -y -c conda-forge -c bioconda \
        anndata \
        biopython \
        cobra \
        deeptools \
        ete3 \
        gget \
        pydeseq2 \
        pysam \
        scanpy \
        scikit-bio \
        scvelo
    # Packages best installed via pip within the activated env
    pip install arboreto flowio geniml gtars "polars-bio" "scvi-tools" tiledbvcf cellxgene-census
    echo "--- Bioinformatics packages installed ---"
}

install_ml() {
    echo "=== Installing ML/deep learning packages ==="
    mamba install -y -c conda-forge -c pytorch \
        scikit-learn \
        umap-learn \
        shap \
        pytorch
    pip install lightning transformers "torch-geometric" torchdrug timesfm aeon neurokit2 "stable-baselines3[extra]" pymoo
    echo "--- ML packages installed ---"
}

install_statistics() {
    echo "=== Installing statistics packages ==="
    mamba install -y -c conda-forge \
        pymc \
        statsmodels \
        scikit-learn \
        shap \
        sympy \
        pymoo
    pip install scikit-survival
    echo "--- Statistics packages installed ---"
}

install_visualization() {
    echo "=== Installing visualization packages ==="
    mamba install -y -c conda-forge \
        matplotlib \
        networkx \
        plotly \
        seaborn
    echo "--- Visualization packages installed ---"
}

install_literature() {
    echo "=== Installing literature/writing packages ==="
    mamba install -y -c conda-forge \
        pyzotero \
        requests \
        beautifulsoup4
    echo "--- Literature packages installed ---"
}

install_utility() {
    echo "=== Installing utility packages ==="
    mamba install -y -c conda-forge \
        psutil \
        python-docx \
        openpyxl \
        python-pptx \
        pypdf \
        pyyaml
    pip install markitdown
    echo "--- Utility packages installed ---"
}

require_mamba

case "$AGENT" in
    all)
        install_bioinformatics
        install_ml
        install_statistics
        install_visualization
        install_literature
        install_utility
        ;;
    bioinformatics)
        install_bioinformatics
        ;;
    ml)
        install_ml
        install_visualization
        ;;
    statistics)
        install_statistics
        install_visualization
        ;;
    literature)
        install_literature
        ;;
    utility)
        install_utility
        ;;
    *)
        echo "Unknown agent: $AGENT"
        echo "Valid options: all, bioinformatics, ml, statistics, literature, utility"
        exit 1
        ;;
esac

echo ""
echo "Done. Run 'python scripts/check_environment.py' to verify GPU/RAM resources."
