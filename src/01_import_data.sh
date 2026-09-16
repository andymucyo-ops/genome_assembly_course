#!/usr/bin/bash

#creat directory and create simlinks to data
ACCESSION='Ishikawa'
TRANSCRIPTOME='RNAseq_Sha'

OUTPUT_DIR='./raw_data/'
DATA_DIR='/data/courses/assembly-annotation-course/raw_data/'

ACCESSION_PATH="${DATA_DIR}${ACCESSION}"
TRANSCRIPTOME_PATH="${DATA_DIR}${TRANSCRIPTOME}"

SYMLINK_1="${OUTPUT_DIR}${ACCESSION}"
SYMLINK_2="${OUTPUT_DIR}${TRANSCRIPTOME}"

#create outdir
if [ -d ${OUTPUT_DIR} ]; then echo "${OUTPUT_DIR} already exists";
    else mkdir -p ${OUTPUT_DIR} && echo "Created dir: ${OUTPUT_DIR}";
    fi

#create symlinks to the original data
if [ -h ${SYMLINK_1} ]; then echo "Symlink to ${ACCESSION} already exists";    
    else ln -s ${ACCESSION_PATH} ${OUTPUT_DIR} && \
    echo "Created symlink 1 to Whole genome sequence of accession: ${ACCESSION} 
    -> ${SYMLINK_1}";
    fi

if [ -h ${SYMLINK_2} ]; then echo "Symlink to ${TRANSCRIPTOME} already exists";
    else ln -s ${TRANSCRIPTOME_PATH} ${OUTPUT_DIR}  && \
    echo "Created symlink 2 to whole transcriptome:${TRANSCRIPTOME} 
    -> ${SYMLINK_2}";
    fi
