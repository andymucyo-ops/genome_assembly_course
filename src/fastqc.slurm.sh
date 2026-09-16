#!/usr/bin/env bash

#SBATCH --job-name=fastqc
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pibu_el8
#SBATCH --time=02:10:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/output_fastqc_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/error_fastqc_%j.e

#setting up all necessary paths
WORKDIR='/data/users/ankunzimana/genome_assembly_course/raw_data'
OUTPUT_DIR='./read_QC/fastqc'
CONTAINER='/containers/apptainer/fastqc-0.12.1.sif'

#executes fastqc on each file passed to it
apptainer exec\
    ${CONTAINER} fastqc ${1}\
    -o ${OUTPUT_DIR}\
    -t ${SLURM_CPUS_PER_TASK}
