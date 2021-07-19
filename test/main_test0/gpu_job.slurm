#!/bin/bash
#SBATCH --job-name=test          # create a short name for your job
#SBATCH --nodes=3                # node count
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem=40G                 # memory per cpu-core (4G is default)
#SBATCH --gres=gpu:2             # number of gpus per node
#SBATCH --time=24:00:00          # total run time limit (HH:MM:SS)
#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=cy15@princeton.edu

module purge
###module load pgi/19.5/64
###module load openmpi/pgi-19.5/3.1.4/64
###module load cudatoolkit
module load nvhpc/21.5   
module load cudatoolkit/11.1
#module load  hdf5/nvhpc-21.5/1.10.6
module load openmpi/nvhpc-21.5/4.1.1
module load hdf5/nvhpc-21.5/openmpi-4.1.1/1.10.6
module li

mpirun -np 5 ./a.out
