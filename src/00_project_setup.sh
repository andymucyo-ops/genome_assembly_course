#!/usr/bin/bash

#creat directory and create simlinks to data
ACCESSION='Ishikawa'
TRANSCRIPTOME='RNAseq_Sha'

WORK_DIR='./raw_data/'
DATA_DIR='/data/courses/assembly-annotation-course/raw_data/'
OUTPUT_DIR='./logs/out/'
ERROR_DIR='./logs/err/'

ACCESSION_PATH="${DATA_DIR}${ACCESSION}"
TRANSCRIPTOME_PATH="${DATA_DIR}${TRANSCRIPTOME}"

SYMLINK_1="${WORK_DIR}${ACCESSION}"
SYMLINK_2="${WORK_DIR}${TRANSCRIPTOME}"

#create workdir:
if [ -d ${WORK_DIR} ]; then echo "${WORK_DIR} already exists";
    else mkdir ${WORK_DIR} && echo "Created dir: ${WORK_DIR}";
    fi

#create logs directories out and err:
if [ -d ${OUTPUT_DIR} ]; then echo "${OUTPUT_DIR} already exists";
    else mkdir -p ${OUTPUT_DIR} && echo "Created dir: ${OUTPUT_DIR}";
    fi

if [ -d ${ERROR_DIR} ]; then echo "${ERROR_DIR} already exists";
    else mkdir -p ${ERROR_DIR} && echo "Created dir: ${ERROR_DIR}";
    fi

#create symlinks to the original data
if [ -h ${SYMLINK_1} ]; then echo "Symlink to ${ACCESSION} already exists";    
    else ln -s ${ACCESSION_PATH} ${WORK_DIR} && \
    echo "Created symlink 1 to Whole genome sequence of accession: ${ACCESSION} 
    -> ${SYMLINK_1}";
    fi

if [ -h ${SYMLINK_2} ]; then echo "Symlink to ${TRANSCRIPTOME} already exists";
    else ln -s ${TRANSCRIPTOME_PATH} ${WORK_DIR}  && \
    echo "Created symlink 2 to whole transcriptome:${TRANSCRIPTOME} 
    -> ${SYMLINK_2}";
    fi
