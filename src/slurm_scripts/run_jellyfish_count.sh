#!/usr/bin/env bash

#SBATCH --job-name=jellyfish_count
#SBATCH --mem-per-cpu=21G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pibu_el8
#SBATCH --time=02:00:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/jellyfish_count_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/jellyfish_count_%j.e


FILE_NAME=$(basename -- "$1")

module load Jellyfish/2.3.0-GCC-10.3.0

jellyfish count -C\
    -s 5G\
    -t ${SLURM_CPUS_PER_TASK}\
    -m 21\
    -o "${2}Ishikawa.jf"\
    <(zcat ${1})
