#!/usr/bin/env bash

#setting all necessary paths
INPUT_DIR='/data/users/ankunzimana/genome_assembly_course/raw_data'
OUTPUT_DIR='./read_QC/fastqc'
FASTQC_SCRIPT='./src/slurm_scripts/fastqc.sh'

rm -rf ./logs/err/* ./logs/out/*
#creating output dir if it doesn't exist
if [ ! -e ${OUTPUT_DIR} ]; then mkdir -p ${OUTPUT_DIR}; fi

#make fastqc script executable
chmod u+x ${FASTQC_SCRIPT}

#loop through fastq files from raw_data dir and run fastqc on each of them
for dir in `ls -1 ${INPUT_DIR}`; do
    for filename in `ls -1 "${INPUT_DIR}/${dir}"`; do 
        file="${INPUT_DIR}/${dir}/${filename}"
        sbatch ${FASTQC_SCRIPT} ${file}
    done
done
