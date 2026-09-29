#!/usr/bin/env bash

#SBATCH --job-name=hifiasm_assambly
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --time=02:00:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/hifiasm_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/hifiasm_%j.e

#setting up all necessary paths
ACCESSION='Ishikawa'
OUTPUT_FILE="${2}${ACCESSION}"
CONTAINER='/containers/apptainer/hifiasm_0.25.0.sif'

#executes hifiasm on each file passed to it
apptainer exec --bind /data \
    ${CONTAINER} hifiasm\
    -o ${OUTPUT_FILE}\
    -t ${SLURM_CPUS_PER_TASK}\
    ${1}

#convert .gfa output to fasta format
awk '/^S/{print ">"$2;print $3}' "${2}${ACCESSION}.bp.p_ctg.gfa" > "${2}${ACCESSION}.fa"
