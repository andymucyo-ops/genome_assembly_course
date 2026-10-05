#!/usr/bin/env bash

#SBATCH --job-name=merqury
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=04:00:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/merqury_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/merqury_%j.e

set -Eeuo pipefail

PROJECT_DIR="/data/users/ankunzimana/genome_assembly_course"
CONTAINER="/containers/apptainer/merqury_1.3.sif"

INPUT_DIR="${PROJECT_DIR}/assemblies"
READS="${PROJECT_DIR}/raw_data/Ishikawa/ERR11437319.fastq.gz"
GENOME_SIZE=119667750

CPUS="${SLURM_CPUS_PER_TASK:-8}"
MERYL_MEMORY_GB=56

if (( $# != 1 )); then
    echo "Usage: sbatch $0 <output_directory>" >&2
    exit 2
fi

mkdir -p "$1"
OUTPUT_DIR="$(cd "$1" && pwd -P)"

if [[ ! -f "${CONTAINER}" ]]; then
    echo "[ERROR] Container not found: ${CONTAINER}" >&2
    exit 1
fi

if [[ ! -f "${READS}" ]]; then
    echo "[ERROR] HiFi reads not found: ${READS}" >&2
    exit 1
fi

declare -A ASSEMBLIES=(
    [flye]="${INPUT_DIR}/flye/assembly.fasta"
    [hifiasm]="${INPUT_DIR}/hifiasm/Ishikawa.fa"
    [lja]="${INPUT_DIR}/LJA/assembly.fasta"
    )

# Determine the Merqury-recommended k-mer size.
K="$(
    apptainer exec \
        --cleanenv \
        --bind /data \
        "${CONTAINER}" \
        sh /usr/local/share/merqury/best_k.sh "${GENOME_SIZE}" |
    tail -n 1 |
    awk '{print int($NF)}'
)"

if [[ ! "${K}" =~ ^[0-9]+$ ]]; then
    echo "[ERROR] Could not determine a valid k-mer size; got: '${K}'" >&2
    exit 1
fi

echo "[INFO] Project directory: ${PROJECT_DIR}"
echo "[INFO] Output directory: ${OUTPUT_DIR}"
echo "[INFO] k-mer size: ${K}"
echo "[INFO] CPUs allocated: ${CPUS}"
echo "[INFO] Meryl memory limit: ${MERYL_MEMORY_GB} GB"

# Shared read k-mer database: build once, reuse for all assemblies.
MERYL_DB="${OUTPUT_DIR}/reads.k${K}.meryl"
if [[ ! -d "${MERYL_DB}" ]]; then
    echo "[RUN] Building Meryl database from HiFi reads"

    apptainer exec \
        --cleanenv \
        --bind /data \
        --env OMP_NUM_THREADS="${CPUS}" \
        --env OMP_THREAD_LIMIT="${CPUS}" \
        "${CONTAINER}" \
        meryl count \
            k="${K}" \
            threads="${CPUS}" \
            memory="${MERYL_MEMORY_GB}" \
            "${READS}" \
            output "${MERYL_DB}"
else
    echo "[INFO] Reusing existing read database: ${MERYL_DB}"
fi

# Ensure that the existing/new database is valid before starting Merqury.
if ! apptainer exec \
        --cleanenv \
        --bind /data \
        "${CONTAINER}" \
        meryl statistics "${MERYL_DB}" >/dev/null
then
    echo "[ERROR] Meryl database is missing, incomplete, or invalid:" >&2
    echo "[ERROR] ${MERYL_DB}" >&2
    echo "[ERROR] Delete that directory, then rerun this job." >&2
    exit 1
fi

for name in flye hifiasm lja; do
    fasta="${ASSEMBLIES[$name]}"
    outdir="${OUTPUT_DIR}/merqury_${name}"

    if [[ ! -f "${fasta}" ]]; then
        echo "[SKIP] ${name}: assembly not found: ${fasta}" >&2
        continue
    fi

    # Do not mix outputs from a prior failed run with a new one.
    if [[ -d "${outdir}" ]] &&
       [[ -n "$(find "${outdir}" -mindepth 1 -print -quit)" ]]
    then
        echo "[ERROR] Existing nonempty result directory: ${outdir}" >&2
        echo "[ERROR] Remove it only if it belongs to a failed/incomplete run." >&2
        exit 1
    fi

    mkdir -p "${outdir}"

    echo "[RUN] Merqury evaluation: ${name}"
    echo "[INFO] Assembly: ${fasta}"

    apptainer exec \
        --cleanenv \
        --bind /data \
        --env MERQURY=/usr/local/share/merqury \
        --env OMP_NUM_THREADS="${CPUS}" \
        --env OMP_THREAD_LIMIT="${CPUS}" \
        "${CONTAINER}" \
        bash -c '
            cd "$1"
            "$MERQURY/merqury.sh" "$2" "$3" "$4"
        ' bash \
        "${outdir}" \
        "${MERYL_DB}" \
        "${fasta}" \
        "${name}"

    # Merqury can finish its outer script even when an internal stage failed.
    if [[ ! -s "${outdir}/${name}.qv" ]]; then
        echo "[ERROR] Merqury did not generate a valid QV file:" >&2
        echo "[ERROR] ${outdir}/${name}.qv" >&2
        exit 1
    fi
if [[ ! -s "${outdir}/${name}.completeness.stats" ]]; then
        echo "[ERROR] Merqury did not generate completeness statistics:" >&2
        echo "[ERROR] ${outdir}/${name}.completeness.stats" >&2
        exit 1
    fi

    echo "[DONE] ${name}"
done