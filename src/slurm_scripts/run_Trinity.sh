#!/usr/bin/env bash

#SBATCH --job-name=Trinity_assembly
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --time=06:00:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/Trinity_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/Trinity_%j.e

module add Trinity/2.15.1-foss-2021a

Trinity --seqType fq\
   --max_memory ${SLURM_MEM_PER_NODE}\
   --CPU ${SLURM_CPUS_PER_TASK}\
   --left ${1}\
   --right ${2}\
   --output ${3}

