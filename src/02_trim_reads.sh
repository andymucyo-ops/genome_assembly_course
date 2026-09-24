#!/usr/bin/env bash

#setting all necessary paths
ACCESSION='Ishikawa'
INPUT_DIR='/data/users/ankunzimana/genome_assembly_course/raw_data/'
READ_ACCESSION='/data/users/ankunzimana/genome_assembly_course/raw_data/Ishikawa/ERR11437319.fastq.gz'
RNASEQ_READ_1='/data/users/ankunzimana/genome_assembly_course/raw_data/RNAseq_Sha/ERR754081_1.fastq.gz'
RNASEQ_READ_2='/data/users/ankunzimana/genome_assembly_course/raw_data/RNAseq_Sha/ERR754081_2.fastq.gz'
TRIMMED_DIR_GENOME="./raw_data/trimmed/${ACCESSION}/"
TRIMMED_DIR_RNASEQ="./raw_data/trimmed/RNAseq/"
OUTPUT_DIR_GENOME='./read_QC/fastp/Ishikawa'
OUTPUT_DIR_RNASEQ='./read_QC/fastp/RNAseq'
FASTP_RNASEQ_SCRIPT='./src/slurm_scripts/run_fastp_rnaseq.sh'
FASTP_GENOME_SCRIPT='./src/slurm_scripts/run_fastp_genome.sh'

#creating output dirs if it doesn't exist
if [ ! -e ${OUTPUT_DIR_GENOME} ]; then mkdir -p ${OUTPUT_DIR_GENOME}; fi
if [ ! -e ${OUTPUT_DIR_RNASEQ} ]; then mkdir -p ${OUTPUT_DIR_RNASEQ}; fi
if [ ! -e ${TRIMMED_DIR_GENOME} ]; then mkdir -p ${TRIMMED_DIR_GENOME}; fi
if [ ! -e ${TRIMMED_DIR_RNASEQ} ]; then mkdir -p ${TRIMMED_DIR_RNASEQ}; fi

#make fastqc script executable
chmod u+x ${FASTP_GENOME_SCRIPT}
chmod u+x ${FASTP_RNASEQ_SCRIPT}

#loop through fastq files from raw_data dir and run fastp according to read type
for dir in `ls -1 ${INPUT_DIR}`; do
    if [ $dir == ${ACCESSION} ];
        then sbatch ${FASTP_GENOME_SCRIPT} ${READ_ACCESSION} ${OUTPUT_DIR_GENOME} ${TRIMMED_DIR_GENOME}; fi

    if [ $dir == "RNAseq_Sha" ];
        then sbatch ${FASTP_RNASEQ_SCRIPT} ${RNASEQ_READ_1} ${RNASEQ_READ_2} ${OUTPUT_DIR_RNASEQ} ${TRIMMED_DIR_RNASEQ};
    fi
done
