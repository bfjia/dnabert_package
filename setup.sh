#!/bin/bash
#
#SBATCH --chdir=/scratch/jjjjia/dnabert_package_bertax/dnabert_package
#SBATCH --account=def-fiona
#SBATCH --job-name=GIBERT
#SBATCH --nodes=1
#SBATCH --mem=0
#SBATCH --gres=gpu:v100l:4
#SBATCH --time=100:00:00
#SBATCH --mail-user=<bja20@sfu.ca>
#SBATCH --mail-type=ALL

date
pwd
workingDir=`pwd`

cd $SLURM_TMPDIR
pwd

module load nixpkgs/16.09
module load gcc/7.3.0
module load python/3.7
#module load scipy-stack
module load cuda/10.1 #0.130

if [ -f "environment.complete" ]
then
	echo "seems like environment is already installed, copying over deploy package"
	rm -rf ./DNABERT/example
	cp -rf $workingDir/deploy/example ./DNABERT
	source temp_environment/bin/activate
else
	if [ -d "temp_environment" ]
	then
		echo "virtual env already exist without a complete marker, reinstalling"
		rm -rf ./temp_environment 
		rm -rf ./DNABERT
	fi
	echo "Starting environment installation"
	virtualenv --no-download temp_environment
	source temp_environment/bin/activate

	#install dnabert
	echo "setting up dnabert"
	git clone https://github.com/jerryji1993/DNABERT
	cd DNABERT
	echo "copying files"
	#rm -rf ./DNABERT/examples
	cp -rf $workingDir/deploy/* .
	python3 -m pip install --no-index --editable .
	echo "finished step 1"
	cd examples
	python3 -m pip install -r requirements.txt
	echo "finished step 2"
	#install apex - DOES NOT WORK ON CEDAR. 
	#echo "setting up apex"
	cd ../
	git clone https://github.com/NVIDIA/apex
	cd apex
	pip install -v --disable-pip-version-check --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
	#pip install -v --disable-pip-version-check --no-cache-dir ./
	echo "Finished environment installation"
	echo "complete" > $SLURM_TMPDIR/environment.complete 
	date
fi

#start:
cd $SLURM_TMPDIR

pwd
cd DNABERT/examples
./example_pretrain.sh
#./example_finetune.sh
mkdir -p $workingDir/output
cp -r ../examples $workingDir/output/

deactivate
