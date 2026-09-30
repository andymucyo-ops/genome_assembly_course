#!/usr/bin/env bash

#Input variables
INPUT_FILE='./k-mer_counting/counts/*.jf'

#output directories paths
OUTPUT_DIR_KMER_HISTO='./k-mer_counting/histo/'

#scripts paths
HISTO_SCRIPT='./src/slurm_scripts/run_jellyfish_histo.sh'

#make scripts exectuable
chmod +x ${HISTO_SCRIPT}

#creating output dirs if it doesn't exist
if [ ! -e ${OUTPUT_DIR_KMER_HISTO} ]; then mkdir -p ${OUTPUT_DIR_KMER_HISTO}; fi

sbatch ${HISTO_SCRIPT} ${INPUT_FILE} ${OUTPUT_DIR_KMER_HISTO}
