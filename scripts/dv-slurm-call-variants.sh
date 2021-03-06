#!/bin/bash
#SBATCH --job-name=dv-call-variants
#SBATCH --output=dv-slurm-call-variants-%j.out
#SBATCH --error=dv-slurm-call-variants-%j.err
#SBATCH --time=2:00:00
#SBATCH --partition=nvidia
#SBATCH --gres=gpu:1
#SBATCH --mem=64G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=aa5525@nyu.edu

echo ""
echo "### call_variants ###"
echo "date: $(date)"
echo "node: $(hostname)"
echo "current dir: $(pwd)"
echo "----------------------------------"
module purge
module load singularity

# Call variants based on the given model.
# --checkpoint: REQUIRED. Path to TensorFlow model checkpoint.
# --examples: REQUIRED. The tf.Example protos in TFRecord format generated by make_examples.
# --outfile: REQUIRED. Output path of candidate variants (CallVariantsOutput protos in TFRecord format).
# --num_mappers: Number of parallel mappers.
# --num_readers: Number of parallel readers.
set -x
time singularity exec ${SIMG_GPU:+--nv} --bind /scratch "${SIMG_GPU:-$SIMG}" \
  /opt/deepvariant/bin/call_variants \
    --checkpoint "$MODEL" \
    --examples "$EXAMPLES" \
    --outfile "$CALL_VARIANTS_OUTPUT"
STATUS=$?
set +x
