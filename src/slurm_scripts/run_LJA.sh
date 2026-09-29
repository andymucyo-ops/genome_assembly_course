#!/usr/bin/env bash

#SBATCH --job-name=LJA_assembly
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --time=1-00:00:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/LJA_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/LJA_%j.e

#setting up container path paths
CONTAINER='/containers/apptainer/lja-0.2.sif'

#executes hifiasm on each file passed to it
apptainer exec --bind /data \
    ${CONTAINER} lja\
    --reads ${1}\
    -o ${2}\
    -t ${SLURM_CPUS_PER_TASK}
