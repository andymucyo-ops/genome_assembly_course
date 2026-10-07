#!/usr/bin/env bash

set -Eeuo pipefail

# Input variables
PROJECT_DIR="${PROJECT_DIR:-/data/users/ankunzimana/genome_assembly_course}"
ACCESSION='Ishikawa'
REFERENCE_DIR='/data/courses/assembly-annotation-course/references'
REFERENCE_FASTA='Arabidopsis_thaliana.TAIR10.dna.toplevel.fa'
REFERENCE_FASTA_PATH="${REFERENCE_DIR}/${REFERENCE_FASTA}"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MUMMER_SCRIPT="${SCRIPT_DIR}/slurm_scripts/run_mummer.sh"

# Assembly FASTA paths
FLYE_ASSEMBLY="${PROJECT_DIR}/assemblies/flye/assembly.fasta"
HIFIASM_ASSEMBLY="${PROJECT_DIR}/assemblies/hifiasm/${ACCESSION}.fa"
LJA_ASSEMBLY="${PROJECT_DIR}/assemblies/LJA/assembly.fasta"

# Output directory paths
OUTPUT_DIR_MUMMER="${PROJECT_DIR}/assembly_assessement/mummer"
LOG_DIR="${PROJECT_DIR}/logs"

if ! command -v sbatch >/dev/null 2>&1; then
    printf '[ERROR] sbatch is not available in PATH.\n' >&2
    exit 1
fi

if [[ ! -x "${MUMMER_SCRIPT}" ]]; then
    chmod +x "${MUMMER_SCRIPT}"
fi

for input in "${REFERENCE_FASTA_PATH}" "${FLYE_ASSEMBLY}" "${HIFIASM_ASSEMBLY}" "${LJA_ASSEMBLY}"; do
    if [[ ! -f "${input}" ]]; then
        printf '[ERROR] Required FASTA file not found: %s\n' "${input}" >&2
        exit 1
    fi
done

mkdir -p "${OUTPUT_DIR_MUMMER}" "${LOG_DIR}/out" "${LOG_DIR}/err"

declare -a ASSEMBLY_NAMES=('flye' 'hifiasm' 'LJA')
declare -a ASSEMBLY_FASTAS=("${FLYE_ASSEMBLY}" "${HIFIASM_ASSEMBLY}" "${LJA_ASSEMBLY}")

for index in "${!ASSEMBLY_NAMES[@]}"; do
    name="${ASSEMBLY_NAMES[${index}]}"
    assembly="${ASSEMBLY_FASTAS[${index}]}"
    output_dir="${OUTPUT_DIR_MUMMER}/${name}"

    job_id="$(sbatch --parsable "${MUMMER_SCRIPT}" "${REFERENCE_FASTA_PATH}" "${assembly}" "${output_dir}")"
    printf 'Submitted MUMmer job %s for %s assembly.\n' "${job_id}" "${name}"
done
