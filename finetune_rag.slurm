#!/bin/bash
#SBATCH --job-name=rag          # job name
#SBATCH -A bck@h100
#SBATCH -C h100                 # for GPU A100 80 Go
#SBATCH --nodes=1               # request one node
#SBATCH --ntasks-per-node=1     # one task per node (= number of GPUs here)
#SBATCH --gres=gpu:1            # number of GPUs per node
#SBATCH --cpus-per-task=10      # number of CPUs per task
#SBATCH --hint=nomultithread    # disable hyperthreading
#SBATCH --time=04:10:00         # maximum execution time (HH:MM:SS)
#SBATCH --output=rag%j.out      # output file name
#SBATCH --error=rag%j.err       # error file name

# Virtual environment
source /lustre/fsn1/projects/rech/fmr/uft12cr/nanotron/nanotron_py/bin/activate
 
# Echo des commandes lancees
set -x

# Chargement des modules nécessaires pour l'exécution
module load arch/h100
module load cuda/12.4.1
module load cudnn/9.2.0.82-cuda

#Cache HuggingFace to avoid issues
export HF_DATASETS_CACHE="/lustre/fsn1/projects/rech/fmr/uft12cr/nanotron/cache_huggingface"

# Configuration de l'environnement
export LD_LIBRARY_PATH=$CUDNN_HOME/lib64:$LD_LIBRARY_PATH

# Echo launched commands
set -x

# Run your script using python3
python /lustre/fswork/projects/rech/fmr/uft12cr/mattia/llama_finetune/finetune_rag.py