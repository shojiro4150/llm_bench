# llm_bench — vLLM on Apple Silicon

このリポジトリは、**Apple Silicon (M1〜M4)** 上で **vLLM** をCPUバックエンドとして動作させ、  
**HLE（Human Last Exam）評価**をローカル実行するためのコードです。

---

## 概要

- Apple Silicon Mac（M1〜M4）で **GPUを使わずvLLMを実行**
- **HLE評価コード（eval_hle）** を用いて、ローカルLLMの性能を自動評価
- CUDA非対応環境でも、OpenAI APIを併用して性能スコアを算出可能

---

## 構成

```bash
llm_bench/
├── vllm/              # サブモジュール: vLLM本家 (https://github.com/vllm-project/vllm)
└── eval_hle/          # HLE評価コード（松尾研 llm_bridge_prod/eval_hle を一部改変）
    ├── conf/          # 評価設定 (config.yaml)
    ├── eval_hle.sh    # 推論→採点を自動実行するスクリプト
    ├── predictions/   # 生成結果（実行後に作成）
    ├── judged/        # 採点結果（実行後に作成）
    ├── vllm.log       # vLLMサーバーログ（実行後）
    ├── predict.log    # 推論ログ（実行後）
    └── judge.log      # 採点ログ（実行後）
````

---

## 主要手順

1. **環境構築**

   ```bash
   conda create -n llm_bench python=3.12 -y
   conda activate llm_bench
   pip install -r vllm/requirements/cpu.txt
   pip install -e vllm
   pip install -r eval_hle/requirements.txt
   ```

2. **vLLMの起動（CPUバックエンド）**

   ```bash
   vllm serve Qwen/Qwen2.5-0.5B-Instruct --port 8000 --dtype float16
   ```

3. **HLE評価実行**

   ```bash
   cd eval_hle
   chmod +x eval_hle.sh
   zsh eval_hle.sh
   ```

---

## 評価設定（例）

```yaml
dataset: cais/hle
provider: vllm
base_url: http://localhost:8000/v1
model: Qwen/Qwen2.5-0.5B-Instruct
judge: o3-mini-2025-01-31
max_samples: 48
num_workers: 30
```

---

## 出力例

| ファイル           | 内容                   |
| -------------- | -------------------- |
| `predictions/` | モデルの生成結果             |
| `judged/`      | 採点済み結果（OpenAI API採点） |
| `vllm.log`     | 推論サーバーログ             |

---

## ライセンス・出典

* **vLLM**
  本プロジェクトは [vLLM Project](https://github.com/vllm-project/vllm) をサブモジュールとして利用しています。
  vLLMはApache License 2.0のもとで配布されています。

* **eval_hle**
  [東京大学 松尾研究室](https://github.com/matsuolab/llm_bridge_prod/tree/master/eval_hle) の
  `eval_hle` コードを一部改変して利用しています。

---

## クレジット

本研究は、
**国立研究開発法人 新エネルギー・産業技術総合開発機構（NEDO）** による
「日本語版医療特化型LLMの社会実装に向けた安全性検証・実証」
における基盤モデル開発プロジェクトの一環として行われています。

---

## 参考記事

[【Apple Silicon対応】Mac(M1〜M4)でvLLMを動かしてLLMをベンチマークしてみた](https://example.com)

---

