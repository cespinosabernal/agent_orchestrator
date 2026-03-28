#!/usr/bin/env bash
# prune_skills.sh
# Removes out-of-scope skill directories from scientific-skills/.
# Run once, from the repo root, after confirming the keep list.
# Usage: bash scripts/prune_skills.sh [--dry-run]

set -euo pipefail

SKILLS_DIR="$(dirname "$0")/../scientific-skills"
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

REMOVE=(
  adaptyv
  alpha-vantage
  alphafold-database
  astropy
  benchling-integration
  chembl-database
  cirq
  clinical-decision-support
  clinical-reports
  clinvar-database
  consciousness-council
  dask
  datacommons-client
  datamol
  deepchem
  denario
  dhdna-profiler
  diffdock
  dnanexus-integration
  drugbank-database
  edgartools
  ena-database
  esm
  fluidsim
  fred-economic-data
  generate-image
  geomaster
  geopandas
  ginkgo-cloud-lab
  glycoengineering
  gnomad-database
  gtex-database
  gwas-database
  hedgefundmonitor
  histolab
  imaging-data-commons
  infographics
  interpro-database
  iso-13485-certification
  jaspar-database
  labarchive-integration
  lamindb
  latchbio-integration
  market-research-reports
  matchms
  medchem
  modal
  molecular-dynamics
  molfeat
  monarch-database
  offer-k-dense-web
  omero-integration
  open-notebook
  opentrons-integration
  paper-2-web
  pathml
  pdb-database
  pennylane
  polars
  protocolsio-integration
  pubchem-database
  pufferlib
  pydicom
  pylabrobot
  pymatgen
  pyopenms
  pytdc
  qiskit
  qutip
  rdkit
  rowan
  string-database
  treatment-plans
  uspto-database
  vaex
  what-if-oracle
  zarr-python
  zinc-database
)

removed=0
skipped=0

for skill in "${REMOVE[@]}"; do
  path="$SKILLS_DIR/$skill"
  if [[ -d "$path" ]]; then
    if $DRY_RUN; then
      echo "[dry-run] would remove: $skill"
    else
      rm -rf "$path"
      echo "removed: $skill"
    fi
    ((removed++))
  else
    echo "not found (already removed?): $skill"
    ((skipped++))
  fi
done

remaining=$(ls "$SKILLS_DIR" | wc -l | tr -d ' ')
echo ""
echo "Done. Removed=$removed  Skipped(not found)=$skipped  Remaining skills=$remaining"
