#!/bin/bash

#module load python/3.6
#module load scipy-stack
#source ./dnabert/bin/activate

which python

export KMER=6
export MODEL_PATH="./6-new-12w-0"
export DATA_PATH="./data"
export OUTPUT_PATH="./finetune"

echo "starting..."
python run_finetune.py \
    --model_type dnalongcat \
    --tokenizer_name=dna$KMER \
    --model_name_or_path $MODEL_PATH \
    --task_name dnaprom \
    --do_train \
    --do_eval \
    --data_dir $DATA_PATH \
    --max_seq_length 3072 \
    --per_gpu_eval_batch_size=6   \
    --per_gpu_train_batch_size=6   \
    --learning_rate 5e-5 \
    --num_train_epochs 4.0 \
    --output_dir $OUTPUT_PATH \
    --evaluate_during_training \
    --logging_steps 100 \
    --save_steps 100 \
    --warmup_percent 0.1 \
    --hidden_dropout_prob 0.2 \
    --overwrite_output \
    --weight_decay 0.01 \
    --gradient_accumulation_steps 20\
    --n_process 8 \
    --seed 25041 #\
#    --fp16
