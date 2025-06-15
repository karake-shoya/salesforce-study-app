# Salesforce問題データ入力ガイド 📚

## CSVファイル構造

| カラム名 | 説明 | 例 |
|---------|------|-----|
| id | 問題ID（連番） | 1, 2, 3... |
| question | 問題文 | "次のうち正しいものを選んでください。" |
| option_a | 選択肢A | "Lightning Platform" |
| option_b | 選択肢B | "Salesforce Classic" |
| option_c | 選択肢C | "Lightning Experience" |
| option_d | 選択肢D | "Developer Console" |
| option_e | 選択肢E（任意） | "Setup Menu" |
| correct_answers | 正解（複数可） | "A" または "A,C" または "A,C,E" |
| explanation | 解説 | "Lightning Platformは..." |
| category | カテゴリー | "Platformアプリケーションビルダー" |
| difficulty | 難易度 | "初級", "中級", "上級" |

## 入力ルール ✅

### 1. 問題文（question）
- 複数選択の場合は「正しいものを2つ選んでください」など明記
- 改行が必要な場合はそのまま入力（CSVで自動処理）

### 2. 選択肢（option_a〜option_e）
- option_a, option_bは必須
- option_c, option_d, option_eは任意（空白可）
- 5つの選択肢まで対応

### 3. 正解（correct_answers）
- 単一選択: "A"
- 複数選択: "A,C" （カンマ区切り、スペースなし）
- 5択3答: "A,C,E"
- 大文字で入力（A, B, C, D, E）

### 4. カテゴリー（category）
推奨値:
- "Platformアプリケーションビルダー"
- "Sales Cloud"
- "Service Cloud"
- "Marketing Cloud"
- "Commerce Cloud"

### 5. 難易度（difficulty）
- "初級" - 基本的な概念
- "中級" - 実践的な知識
- "上級" - 高度な設定・カスタマイズ

## 入力例 📝

```csv
id,question,option_a,option_b,option_c,option_d,option_e,correct_answers,explanation,category,difficulty
1,"Lightning Platformの主要コンポーネントを3つ選んでください。","Lightning App Builder","Process Builder","Flow Builder","Workflow Rules","Lightning Web Components","A,C,E","Lightning App Builder、Flow Builder、Lightning Web Componentsが主要コンポーネントです。","Platformアプリケーションビルダー","中級"
```

## Googleスプレッドシートでの作業手順 📊

1. **新しいスプレッドシートを作成**
2. **1行目にヘッダーを入力**
   ```
   id | question | option_a | option_b | option_c | option_d | option_e | correct_answers | explanation | category | difficulty
   ```

3. **データを入力**
   - ダブルクォートは手動入力不要
   - 改行はそのまま入力
   - 複数選択は "A,C,E" 形式

4. **CSVでエクスポート**
   - ファイル → ダウンロード → カンマ区切り値(.csv)
   - エンコーディング: UTF-8

## インポート方法 🚀

```bash
# CSVファイルをインポート
rails questions:import CSV_FILE=path/to/your/questions.csv

# 例
rails questions:import CSV_FILE=db/salesforce_questions.csv
```

## 注意事項 ⚠️

1. **選択肢の数**
   - 最低2つ（option_a, option_b）は必須
   - 最大5つ（option_a〜option_e）まで対応
   - 使わない選択肢は空白にする

2. **正解の指定**
   - 必ず大文字（A, B, C, D, E）
   - 複数選択はカンマ区切り、スペースなし
   - 例: "A,C,E" ✅  "A, C, E" ❌

3. **文字エンコーディング**
   - 必ずUTF-8で保存
   - 日本語文字化け防止

4. **データ検証**
   - インポート後は必ずテスト実行
   - 問題文と選択肢の整合性確認

## トラブルシューティング 🔧

### よくあるエラー
- **文字化け**: UTF-8エンコーディングで保存し直す
- **正解判定エラー**: correct_answersの形式確認（大文字、カンマ区切り）
- **選択肢表示エラー**: option_a, option_bが空白でないか確認

頑張って！✨ 