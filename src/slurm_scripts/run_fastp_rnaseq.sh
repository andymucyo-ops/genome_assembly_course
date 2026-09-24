#!/usr/bin/env bash

#SBATCH --job-name=fastp_rnaseq
#SBATCH --mem=20G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pibu_el8
#SBATCH --time=02:10:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/output_fastp_rnaseq_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/error_fastp_rnaseq_%j.e

#setting up all necessary paths
# output dir is the 3rd argument passed by the script
# output dir is the 4th argument passed by the script
OUTFILE_READ_1="${4}/out_Read1.fq.gz" 
OUTFILE_READ_2="${4}/out_Read2.fq.gz"
REPORT_HTML="${3}/fastp_rnaseq.html"
REPORT_JSON="${3}/fastp_rnaseq.json"
CONTAINER='/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif'

#executes fastqc on each file passed to it
apptainer exec --bind /data ${CONTAINER}\
    fastp -i ${1} -I ${2}\
    -o ${OUTFILE_READ_1} -O ${OUTFILE_READ_2}\
    -h ${REPORT_HTML}\
    -j ${REPORT_JSON}\
    -t ${SLURM_CPUS_PER_TASK}
