#!/usr/bin/env bash

#SBATCH --job-name=merqury
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pibu_el8
#SBATCH --time=02:00:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/merqury_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/merqury_%j.e

#setting up container path paths
CONTAINER='/containers/apptainer/merqury_1.3.sif'
INPUT_DIR="./assemblies/"
OUTPUT_DIR=$1
GENOME_SIZE=119667750   # same TAIR10 estimate used for QUAST --est-ref-size

# PacBioHiFi reads location
READS="./raw_data/Ishikawa/ERR11437319.fastq.gz"

# Assemblies to evaluate
declare -A ASSEMBLIES=(
  [flye]="${INPUT_DIR}flye/assembly.fasta"
  [hifiasm]="${INPUT_DIR}hifiasm/Ishikawa.fa"
  [lja]="${INPUT_DIR}LJA/assembly.fasta"
)


# Get best k for this genome size
K=$(apptainer exec --bind /data ${CONTAINER} \
      sh /usr/local/share/merqury/best_k.sh "${GENOME_SIZE}" | tail -n1 | awk '{print $NF}')
K=${K%.*}   # merqury.sh wants an integer k
echo "[INFO] using k=${K}"

# Build meryl db from reads
MERYL_DB="${OUTPUT_DIR}/reads.k${K}.meryl"
if [[ ! -d "${MERYL_DB}" ]]; then
  echo "[RUN] meryl count"
  apptainer exec --bind /data ${CONTAINER} \
    meryl count k="${K}" threads="${SLURM_CPUS_PER_TASK}" memory=55 \
      "${READS}" output "${MERYL_DB}"
fi

# Run merqury.sh per assembly
for name in "${!ASSEMBLIES[@]}"; do
  fasta="${ASSEMBLIES[$name]}"

  if [[ ! -f "${fasta}" ]]; then
    echo "[SKIP] ${name}: input not found at ${fasta}"
    continue
  fi

  outdir="${OUTPUT_DIR}merqury_${name}"
  mkdir -p "${outdir}"

  echo "[RUN] merqury ${name}"
  apptainer exec --bind "${PROJECT_DIR}" --env MERQURY=/usr/local/share/merqury "${CONTAINER}" \
    bash -c "cd '${outdir}' && merqury.sh '${MERYL_DB}' '${fasta}' '${name}'"

  echo "[DONE] ${name}"
done