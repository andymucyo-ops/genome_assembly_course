#!/usr/bin/bash

#creat directory and create simlinks to data
ACCESSION='Ishikawa'
TRANSCRIPTOME='RNAseq_Sha'

OUTPUT_DIR='./raw_data'
DATA_DIR='/data/courses/assembly-annotation-course/raw_data/'

#create outdir
mkdir -p ${OUTPUT_DIR} && echo "Created dir: ${OUTPUT_DIR}"

#create symlinks to the original data
ln -s "${DATA_DIR}${ACCESSION}" "${OUTPUT_DIR}" && \
    echo "Created symlink 1: ${DATA_DIR}${ACCESSION}"
ln -s "${DATA_DIR}${TRANSCRIPTOME}" "${OUTPUT_DIR}"  && \
    echo "Created symlink 2: ${DATA_DIR}${TRANSCRIPTOME}"
