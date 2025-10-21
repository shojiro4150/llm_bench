# Humanity's Last Exam 評価コード

# Notion に利用方法を記載
https://www.notion.so/HLE-240e14b94af580879e14d30e57b1a187?source=copy_link

```
評価結果が`leaderboard`フォルダに書き込まれています。`results.jsonl`と`summary.json`が出力されているかご確認ください。

## 動作確認済みモデル （vLLM対応モデルのみ動作可能です）
- Qwen3 8B

## configの仕様
`conf/config.yaml`の設定できるパラメーターの説明です。

|フィールド                 |型        |説明                            |
| ----------------------- | -------- | ------------------------------ |
|`dataset`                |string    |評価に使用するベンチマークのデータセットです。全問実施すると時間がかかるため最初は一部の問題のみを抽出して指定してください。|
|`provider`               |string    |評価に使用する推論環境です。vllmを指定した場合、base_urlが必要です。|
|`base_url`               |string    |vllmサーバーのurlです。同じサーバーで実行する場合は初期設定のままで大丈夫です。|
|`model`                  |string    |評価対象のモデルです。vllmサーバーで使われているモデル名を指定してください。|
|`max_completion_tokens`  |int > 0   |最大出力トークン数です。プロンプトが2000トークン程度あるので、vllmサーバー起動時に指定したmax-model-lenより2500ほど引いた値を設定してください。|
|`reasoning`              |boolean   |
|`num_workers`            |int > 1   |同時にリクエストする数です。外部APIを使用時は30程度に、vllmサーバーを使用時は推論効率を高めるため、大きい値に設定してください。|
|`max_samples`            |int > 0   |指定した数の問題をデータセットの前から抽出して、推論します。|
|`judge`                  |string    |LLM評価に使用するOpenAIモデルです。通常はo3-miniを使用ください。|

## Memo
1採点（2500件）に入力25万トークン、出力に2万トークン使う（GPT4.1-miniでの見積もりのためo3-miniだと異なる可能性あり）

2500件(multimodal)または2401件(text-only)の全ての問題が正常に推論または評価されない場合は、複数回実行してください。ファイルに保存されている問題は再推論されません。
