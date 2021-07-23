#!/bin/bash

which python
KMER=3
TRAIN_FILE="./pretrainData.tsv"
TEST_FILE="./pretrainData.tsv"
SOURCE="$SLURM_TMPDIR/DNABERT"
OUTPUT_PATH="MODEL_pretrain_$KMER"

echo "starting..."
python run_pretrain.py \
    --output_dir $OUTPUT_PATH \
    --model_type=dna \
    --tokenizer_name=dna$KMER \
    --config_name=$SOURCE/src/transformers/dnabert-config/bert-config-$KMER/config.json \
    --do_train \
    --train_data_file=$TRAIN_FILE \
    --do_eval \
    --eval_data_file=$TEST_FILE \
    --mlm \
    --gradient_accumulation_steps 25 \
    --per_gpu_train_batch_size 16 \
    --per_gpu_eval_batch_size 16 \
    --save_steps 500 \
    --save_total_limit 20 \
    --max_steps 25000 \
    --evaluate_during_training \
    --logging_steps 500 \
    --line_by_line \
    --learning_rate 4e-4 \
    --block_size 512 \
    --adam_epsilon 1e-6 \
    --weight_decay 0.01 \
    --beta1 0.9 \
    --beta2 0.98 \
    --mlm_probability 0.025 \
    --warmup_steps 10000 \
    --overwrite_output_dir \
    --n_process 32 \
    --seed 25041 #\
#    --fp16

conda deactivate
