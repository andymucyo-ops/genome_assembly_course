#!/usr/bin/env bash

#SBATCH --job-name=flye_asembly
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --time=1-00:00:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/flye_assembly_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/flye_asembly_%j.e

#setting up all necessary paths
CONTAINER='/containers/apptainer/flye_2.9.5.sif'

#executes flye on each file passed to it
apptainer exec --bind /data \
    ${CONTAINER} flye --pacbio-hifi ${1}\
    --out-dir ${2}\
    --threads ${SLURM_CPUS_PER_TASK}
