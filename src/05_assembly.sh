#!/usr/bin/env bash

#Input variables
GENOME_INPUT='./raw_data/Ishikawa/ERR11437319.fastq.gz'
TRANSCRIPTOME_INPUT_1='./raw_data/trimmed/RNAseq/Transcriptome_Read1.fq.gz'
TRANSCRIPTOME_INPUT_2='./raw_data/trimmed/RNAseq/Transcriptome_Read2.fq.gz'

#output directories paths
OUTPUT_DIR_FLYE='./assemblies/flye/'
OUTPUT_DIR_HIFIASM='./assemblies/hifiasm/'
OUTPUT_DIR_LJA='./assemblies/LJA/'
OUTPUT_DIR_TINITY='./assemblies/Trinity/'

#scripts paths
FLYE_SCRIPT='./src/slurm_scripts/run_flye.sh'
HIFIASM_SCRIPT='./src/slurm_scripts/run_hifiasm.sh'
LJA_SCRIPT='./src/slurm_scripts/run_LJA.sh'
TRINITY_SCRIPT='./src/slurm_scripts/run_Trinity.sh'

#make all scripts executable
chmod +x ${FLYE_SCRIPT} ${HIFIASM_SCRIPT} ${LJA_SCRIPT} ${TRINITY_SCRIPT}

#creating output dirs if it doesn't exist
if [ ! -e ${OUTPUT_DIR_FLYE} ]; then mkdir -p ${OUTPUT_DIR_FLYE}; fi
if [ ! -e ${OUTPUT_DIR_HIFIASM} ]; then mkdir -p ${OUTPUT_DIR_HIFIASM}; fi
if [ ! -e ${OUTPUT_DIR_LJA} ]; then mkdir -p ${OUTPUT_DIR_LJA}; fi
if [ ! -e ${OUTPUT_DIR_TINITY} ]; then mkdir -p ${OUTPUT_DIR_TINITY}; fi


#run genome assembly (flye, hifiasm, LJA)
sbatch ${FLYE_SCRIPT} ${GENOME_INPUT} ${OUTPUT_DIR_FLYE}
sbatch ${HIFIASM_SCRIPT} ${GENOME_INPUT} ${OUTPUT_DIR_HIFIASM}
sbatch ${LJA_SCRIPT} ${GENOME_INPUT} ${OUTPUT_DIR_LJA}

#run transcriptome assembly (Trinity)
sbatch ${TRINITY_SCRIPT} ${TRANSCRIPTOME_INPUT_1} ${TRANSCRIPTOME_INPUT_2} ${OUTPUT_DIR_TINITY}
