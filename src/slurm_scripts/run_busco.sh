#!/usr/bin/env bash

#SBATCH --job-name=busco
#SBATCH --mem-per-cpu=20G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pibu_el8
#SBATCH --time=02:00:00
#SBATCH --mail-user=andy.nkunzimana@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/ankunzimana/genome_assembly_course/logs/out/busco_%j.o
#SBATCH --error=/data/users/ankunzimana/genome_assembly_course/logs/err/busco_%j.e

#setting up container path paths
CONTAINER='/containers/apptainer/busco_5.7.1.sif'
INPUT_DIR='./assemblies/'
OUTPUT_DIR=$1

USE_AUTO_LINEAGE=false
LINEAGE='brassicales_odb10'

declare -A ASSEMBLIES=(
  [flye]="${INPUT_DIR}flye/assembly.fasta|genome"
  [hifiasm]="${INPUT_DIR}hifiasm/Ishikawa.fa|genome"
  [lja]="${INPUT_DIR}LJA/assembly.fasta|genome"
  [trinity]="${INPUT_DIR}Trinity.Trinity.fasta|transcriptome"
)

for name in "${!ASSEMBLIES[@]}"; do
  IFS='|' read -r fasta mode <<< "${ASSEMBLIES[$name]}"

  if [[ ! -f "${fasta}" ]]; then
    echo "[SKIP] ${name}: input not found at ${fasta}"
    continue
  fi

  echo "[RUN] ${name} (mode=${mode})"

  if [[ ${USE_AUTO_LINEAGE} == true ]]; then
    LINEAGE_ARGS="--auto-lineage"
  else
    LINEAGE_ARGS="-l ${LINEAGE}"
  fi

  apptainer exec --bind /data \
    ${CONTAINER} busco \
    -i "${fasta}" \
    -o "busco_${name}" \
    -m "${mode}" \
    ${LINEAGE_ARGS} \
    -c "${SLURM_CPUS_PER_TASK}" \
    --out_path ${OUTPUT_DIR} \
    -f

  echo "[DONE] ${name}"
done