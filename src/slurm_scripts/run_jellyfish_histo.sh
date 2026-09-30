#!/usr/bin/env bash

#SBATCH --job-name=jellyfish_histo
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pibu_el8
#SBATCH --time=00:10:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/jellyfish_histo_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/jellyfish_histo_%j.e

#extract file name
FILE_NAME=$(basename -- "$1" .jf)

module load Jellyfish/2.3.0-GCC-10.3.0

jellyfish histo\
    -t ${SLURM_CPUS_PER_TASK}\
    ${1} > "${2}${FILE_NAME}.histo"
