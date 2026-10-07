#!/usr/bin/env bash

#SBATCH --job-name=mummer
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=03:00:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/mummer_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/mummer_%j.e

set -Eeuo pipefail

if [ "$#" -ne 3 ]; then
    echo "Usage: sbatch $0 <reference_fasta> <query_assembly_fasta> <output_directory>" >&2
    exit 1
fi

REFERENCE_FASTA="$1"
QUERY_FASTA="$2"
OUTPUT_DIR="$3"

if [ ! -f "${REFERENCE_FASTA}" ]; then
    echo "[ERROR] Reference fasta not found: ${REFERENCE_FASTA}" >&2
    exit 1
fi

if [ ! -f "${QUERY_FASTA}" ]; then
    echo "[ERROR] Query assembly fasta not found: ${QUERY_FASTA}" >&2
    exit 1
fi

mkdir -p "${OUTPUT_DIR}"

QUERY_NAME="$(basename "${QUERY_FASTA}")"
QUERY_NAME="${QUERY_NAME%.*}"
PREFIX="${OUTPUT_DIR}/${QUERY_NAME}_vs_reference"

module load MUMmer/4.0.0rc1

nucmer \
    --threads "${SLURM_CPUS_PER_TASK}" \
    --prefix "${PREFIX}" \
    "${REFERENCE_FASTA}" \
    "${QUERY_FASTA}"

cd "${OUTPUT_DIR}"

delta-filter -1 "${PREFIX}.delta" > "${PREFIX}.1to1.delta"
show-coords -rclT "${PREFIX}.1to1.delta" > "${PREFIX}.1to1.coords.tsv"
show-snps -ClrT "${PREFIX}.1to1.delta" > "${PREFIX}.1to1.snps.tsv"
mummerplot \
    --png \
    --layout \
    --filter \
    --prefix "${PREFIX}.plot" \
    "${PREFIX}.1to1.delta"
