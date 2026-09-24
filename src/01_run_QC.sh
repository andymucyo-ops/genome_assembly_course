#!/usr/bin/env bash

#setting all necessary paths
ACCESSION='Ishikawa'
INPUT_DIR_ACCESSION="/data/users/ankunzimana/genome_assembly_course/raw_data/${ACCESSION}/"
INPUT_DIR_RNASEQ='/data/users/ankunzimana/genome_assembly_course/raw_data/trimmed/RNAseq/'
OUTPUT_DIR_ACCESSION="./read_QC/fastqc/${ACCESSION}/"
OUTPUT_DIR_RNASEQ='./read_QC/fastqc/RNAseq_Sha/'
FASTQC_SCRIPT='./src/slurm_scripts/fastqc.sh'

#creating output dir if it doesn't exist
if [ ! -e ${OUTPUT_DIR_ACCESSION} ]; then mkdir -p ${OUTPUT_DIR_ACCESSION}; fi
if [ ! -e ${OUTPUT_DIR_RNASEQ} ]; then mkdir -p ${OUTPUT_DIR_RNASEQ}; fi

#make fastqc script executable
chmod u+x ${FASTQC_SCRIPT}

for file in `ls -1 ${INPUT_DIR_ACCESSION}`; do
    sbatch ${FASTQC_SCRIPT} "${INPUT_DIR_ACCESSION}/${file}" ${OUTPUT_DIR_ACCESSION}
done

for file in `ls -1 ${INPUT_DIR_RNASEQ}`; do
    sbatch ${FASTQC_SCRIPT} "${INPUT_DIR_RNASEQ}/${file}" ${OUTPUT_DIR_RNASEQ}
done
