#!/usr/bin/env bash

#SBATCH --job-name=fastp_genome
#SBATCH --mem=20G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pibu_el8
#SBATCH --time=02:10:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/output_fastp_genome_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/error_fastp_genome%j.e

#setting up all necessary paths
# output dir is the 2nd argument passed to by the script
ACCESSION='Ishikawa'
OUTFILE="${2}/${ACCESSION}.fq.gz"
REPORT_HTML="${2}/fastp_${ACCESSION}.html"
REPORT_JSON="${2}/fastp_${ACCESSION}.json"
CONTAINER='/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif'

# executes fastqc on each file passed to it
apptainer exec --bind /data ${CONTAINER}\
    fastp -i ${1}\
    -o ${OUTFILE}\
    -h ${REPORT_HTML}\
    -j ${REPORT_JSON}\
    -t ${SLURM_CPUS_PER_TASK}
