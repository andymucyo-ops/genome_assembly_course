#!/usr/bin/env bash

#Input variables
GENOME_INPUT='/data/users/ankunzimana/genome_assembly_course/raw_data/Ishikawa/ERR11437319.fastq.gz'

#output directories paths
OUTPUT_DIR_KMER_COUNT='./k-mer_counting/counts/'

#scripts paths
COUNT_SCRIPT='./src/slurm_scripts/run_jellyfish_count.sh'

#make scripts exectuable
chmod +x ${COUNT_SCRIPT}

#creating output dirs if it doesn't exist
if [ ! -e ${OUTPUT_DIR_KMER_COUNT} ]; then mkdir -p ${OUTPUT_DIR_KMER_COUNT}; fi

#run both scripts on all files with according output directory
sbatch ${COUNT_SCRIPT} ${GENOME_INPUT} ${OUTPUT_DIR_KMER_COUNT}
