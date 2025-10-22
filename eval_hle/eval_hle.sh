#!/bin/bash

#--- 認証 ---------------------------------------------------------
#export OPENAI_API_KEY="your_key"
#export HF_TOKEN="your_key"

#--- GPU 監視 (mac利用不可)------------------------------------------
#nvidia-smi -i 0,1,2,3,4,5,6,7 -l 3 > nvidia-smi.log &
#pid_nvsmi=$!

#--- 必要なディレクトリを作成 -----------------------------------------
mkdir -p predictions
mkdir -p judged

#--- vLLM 起動 -----------------------------------------------------
vllm serve Qwen/Qwen2.5-0.5B-Instruct \
  --tensor-parallel-size 1 \
  --max-model-len 32768 \
  --max-num-batched-tokens 32768 \
  --override-generation-config '{"temperature": 0}' \
  > vllm.log 2>&1&
pid_vllm=$!

# --- vLLM 起動（LoRA） ---------------------------------------------
#vllm serve deepseek-ai/DeepSeek-R1-Distill-Qwen-32B \
#  --tensor-parallel-size 1 \
#  --max-model-len 32768 \
#  --max-num-batched-tokens 32768 \
#  --override-generation-config '{"temperature": 0}' \
#  --gpu-memory-utilization 0.9 \
#  --enable-lora \
#  --lora-modules \
#    r1_2nodes_final=your_path/checkpoints/r1_2nodes_final\
#  > vllm.log 2>&1 &

pid_vllm=$!
echo "vLLM PID=${pid_vllm}"

#--- ヘルスチェック -------------------------------------------------
until curl -s http://127.0.0.1:8000/health >/dev/null; do
  echo "$(date +%T) vLLM starting …"
  sleep 10
done
echo "vLLM READY"

python predict.py > predict.log 2>&1
python judge.py > judge.log 2>&1

#--- 後片付け -------------------------------------------------------
kill $pid_vllm
#kill $pid_nvsmi
wait
