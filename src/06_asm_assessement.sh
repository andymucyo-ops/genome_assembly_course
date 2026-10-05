#!/usr/bin/env bash

PROJECT_DIR='/data/users/ankunzimana/genome_assembly_course'
OUT_DIR_BUSCO="${PROJECT_DIR}/assembly_assessement/busco/"
OUT_DIR_QUAST="${PROJECT_DIR}/assembly_assessement/quast/"
OUT_DIR_MERQURY="${PROJECT_DIR}/assembly_assessement/merqury/"

if [ ! -e ${OUT_DIR_BUSCO} ]; then mkdir -p ${OUT_DIR_BUSCO}; fi
if [ ! -e ${OUT_DIR_QUAST} ]; then mkdir -p ${OUT_DIR_QUAST}; fi
if [ ! -e ${OUT_DIR_MERQURY} ]; then mkdir -p ${OUT_DIR_MERQURY}; fi

BUSCO_SCRIPT='./src/slurm_scripts/run_busco.sh'
QUAST_SCRIPT='./src/slurm_scripts/run_quast.sh'
MERQURY_SCRIPT='./src/slurm_scripts/run_merqury.sh'

chmod +x $BUSCO_SCRIPT $QUAST_SCRIPT $MERQURY_SCRIPT

out_dirs=(
    "$OUT_DIR_BUSCO"
    "$OUT_DIR_QUAST"
    "$OUT_DIR_MERQURY"
    )
scripts=(
    "$BUSCO_SCRIPT"
    "$QUAST_SCRIPT"
    "$MERQURY_SCRIPT"
    )

for i in "${!scripts[@]}"; do
    script=${scripts[$i]}
    out_ditr=${out_dirs[$i]}
    sbatch ${script} ${out_dir}
done