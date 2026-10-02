#!/usr/bin/env bash

#SBATCH --job-name=quast
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pibu_el8
#SBATCH --time=02:00:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/quast_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/quast_%j.e

#setting up container path paths
CONTAINER='/containers/apptainer/quast_5.2.0.sif'
INPUT_DIR='./assemblies/'
OUTPUT_DIR=$1
REF_DIR="/data/courses/assembly-annotation-course/references"


REFERENCE="${REF_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
ANNOTATION="${REF_DIR}/TAIR10_GFF3_genes.gff"
EST_REF_SIZE=119667750 # extrected with: grep -v '^>' /data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa | tr -d '\n' | wc -c

ASSEMBLIES=(
	"${INPUT_DIR}flye/assembly.fasta"
	"${INPUT_DIR}hifiasm/Ishikawa.fa"
	"${INPUT_DIR}LJA/assembly.fasta"
)
LABELS="flye,hifiasm,lja"

apptainer exec --bind /data \
	${CONTAINER} quast.py \
	${ASSEMBLIES[@]}\
	-r ${REFERENCE} \
	--features ${ANNOTATION} \
	--labels "${LABELS}"\
	--eukaryote \
	--threads "${SLURM_CPUS_PER_TASK}" \
	-o "${OUTPUT_DIR}/with_ref"

apptainer exec --bind /data \
	${CONTAINER} quast.py \
	${ASSEMBLIES[@]}\
	--labels "${LABELS}"\
	--est-ref-size ${EST_REF_SIZE} \
	--eukaryote \
	--no-sv \
	--threads "${SLURM_CPUS_PER_TASK}" \
	-o "${OUTPUT_DIR}/no_ref"
