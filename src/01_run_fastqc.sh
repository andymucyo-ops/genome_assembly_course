#!/usr/bin/env bash

#setting all necessary paths
WORKDIR='/data/users/ankunzimana/genome_assembly_course/raw_data'
OUTPUT_DIR='./read_QC/fastqc'
FASTQC_SCRIPT='./src/fastqc.slurm.sh'

rm -rf ./logs/err/* ./logs/out/*
#creating output dir if it doesn't exist
if [ ! -e ${OUTPUT_DIR} ]; then mkdir -p ${OUTPUT_DIR}; fi

#make fastqc script executable
chmod u+x ${FASTQC_SCRIPT}

#loop through fastq files from raw_data dir and run fastqc on each of them
for dir in `ls -1 ${WORKDIR}`; do
    for filename in `ls -1 "${WORKDIR}/${dir}"`; do 
        file="${WORKDIR}/${dir}/${filename}"
        sbatch ${FASTQC_SCRIPT} ${file}
    done
done
