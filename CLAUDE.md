# Amazon Research OS — プロジェクト指示 & ドキュメント

> BabyGoo / fungoo｜株式会社ASAGIRI｜社内限定

Amazon市場分析・競合分析・商品開発支援のオールインワンツール。
Chrome拡張でAmazon商品情報を取得し、Claude AIで分析、HTML レポートを生成して GitHub Pages で公開するワークフローを自動化します。

---

## システム概要

```
分析依頼（Claude）
    ↓
HTMLレポート生成 → outputs/reports/[商品名]_analysis_[YYYYMM].html
    ↓
ナレッジポータル更新 → reports/index.html
    ↓
publish.bat で GitHub Pages へ公開（永久URL）
```

---

## フォルダ構成

```
amazon-research-os/
├── chrome-extension/       # Chrome拡張本体
├── prompts/                # Claude用プロンプトテンプレート
├── outputs/reports/        # 一時出力先（レポートHTML）
├── reports/                # GitHub Pages 公開用HTMLレポート（Git管理）
│   ├── index.html          # ナレッジポータル（全レポート一覧）
│   └── YYYY-MM/            # 年月別フォルダ
│       └── 商品名.html      # 個別レポート
├── products/               # 商品データ（プロファイル・競合ASIN・楽天CSV）
├── sheets/                 # Google Sheets連携（GASスクリプト・テンプレート）
├── dtoc-brand/             # ブランド戦略ドキュメント
├── docs/                   # ドキュメント
└── publish.bat             # ワンクリック公開スクリプト
```

---

## 通常の使い方

### Step 1｜データを準備する

CSVファイルをチャットに貼り付けるか、`products/own/[商品名]/` に保存する。

### Step 2｜Claudeに分析を依頼する

```
「〇〇の分析をしてください。CSVは以下です。」
[CSVを貼り付け]
```

Claude が自動で：
- データを読み込み・分析（3フェーズ制に従う）
- `outputs/reports/[商品名]_analysis_[YYYYMM].html` にレポートを生成
- `reports/YYYY-MM/[ascii名].html` にコピー
- `reports/index.html` の REPORTS 配列に1行追加

### Step 3｜公開する（30秒）

```
publish.bat をダブルクリック
```

→ GitHub Pages に自動デプロイ  
→ 永久URLが発行される

---

## GitHub Pages 公開設定

### 初回セットアップ

1. GitHubリポジトリの **Settings** タブを開く
2. 左メニューの **Pages** をクリック
3. Source で **master** ブランチ・ **/ (root)** フォルダを選択 → **Save**
4. 数分待つと `https://yukiura-code.github.io/amazon-research-os/` で公開される

> **注意**: リポジトリが Private の場合、GitHub Pages は有料プランが必要。
> Settings → General → Danger Zone → **Change repository visibility → Public** に変更すれば無料で使える。

### URLの仕組み

```
https://【GitHubユーザー名】.github.io/【リポジトリ名】/【ファイルパス】
例: https://yukiura-code.github.io/amazon-research-os/reports/2026-06/silicone-wrap-series-202606.html
```

リポジトリ内のファイルパスをそのままURLの末尾に追加すればアクセスできる。

---

## Chrome拡張の使い方

### 導入手順

1. Chrome で `chrome://extensions/` を開く
2. 右上の「**デベロッパーモード**」をON
3. 「**パッケージ化されていない拡張機能を読み込む**」→ `chrome-extension/` フォルダを選択
4. 「Amazon Research OS」が一覧に表示されればOK

### データ取得

1. Amazonの商品ページを開く
2. ツールバーの拡張機能アイコンをクリック
3. 「商品情報を取得」→「JSONコピー」または「TSVコピー」でデータを取得

---

## ナレッジポータル（reports/index.html）の使い方

| 機能 | 操作 |
|------|------|
| 全レポート一覧 | トップページに自動表示 |
| モール別絞り込み | ツールバーの「Amazon」「楽天」ボタン |
| 商品検索 | 検索バーに商品名・ASIN・タグを入力 |
| レポートを開く | カード右下の「レポートを開く →」ボタン |

---

## Claudeへの依頼テンプレート

### 新規分析依頼

```
以下のデータを分析してレポートを作成してください。
- 対象商品: 〇〇
- 分析期間: YYYY年M〜M月
- 注目ポイント: （あれば）

[CSVを貼り付け]
```

### 既存レポートの更新

```
reports/YYYY-MM/商品名.html を更新してください。
新しいデータ: [CSVを貼り付け]
```

---

## ファイル命名規則

| 対象 | 命名規則 | 例 |
|------|----------|-----|
| レポートHTML | `商品名-略称.html`（英数小文字） | `babyrobe.html` |
| CSVデータ | `モール日報_商品名.csv` | `Amazon日報_ベビーバスローブ.csv` |
| フォルダ | `YYYY-MM` | `2026-07` |

---

## 分析ナレッジ（KPI基準・課題別アクション）

CSVデータを分析してレポートやアクション案を作成するときは、以下の知識を判断基準として使うこと。

### 売上の分解公式（Amazon・楽天共通）

```
売上 = アクセス数 × 転換率（CTR × CVR） × 客単価
         ↑               ↑                  ↑
      SEO/広告        サムネイル/ページ     価格・セット
```

### KPI 基準値

| 指標 | Amazon | 楽天 |
|------|--------|------|
| サムネイル CTR | — | 1〜2% |
| 商品ページ CVR | — | 5〜8% |
| TACOS | 〜15%が目安（超えたら要改善） | — |
| ACOS | — | 〜50%が目安（超えたら採算割れ警戒） |

### 課題別アクション対応

| 課題 | Amazon | 楽天 |
|------|--------|------|
| CTRが低い | サムネイル改善（キャッチコピー・モデル・トンマナ） | サムネイル改善（CTR目標 1〜2%） |
| CVRが低い | 訴求文言・画像・A+・価格・クーポン見直し | 商品ページ改善（CVR目標 5〜8%） |
| アクセスが少ない | SEO強化 / SP広告 / SB・DSP活用 | SEO改善 / RPP広告強化 |
| 在庫切れ | **SEOスコアへのマイナスが最大級 → 最優先対応** | 同左 |

### Amazon SEO の特性

- SEOスコアの時系列重み: **直近1週間 ＞ 直近1ヶ月 ＞ 通算**（最近の実績ほど重要）
- 在庫切れによるマイナスが非常に大きい
- SP広告でのKW購入実績がオーガニック順位に影響する

### 楽天 SEO・広告の特性

- 売上の50〜60%がSEO自然検索を目指す（広告依存を下げるのが理想）
- 広告投資サイクル: `広告投資 → SEO上昇 → 広告比率低下 → セール参加`
- RPP入札KWは「そのKWから購入されやすいか」で優先度を決める

---

## 月次販売分析レポートのフォーマット

**販売データ（CSV）を受け取って月次分析レポートを作成するときは、必ず `prompts/monthly-analysis-report.txt` の指示に従うこと。**

### ワークフロー（3フェーズ制・厳守）

```
PHASE 1: テキスト分析レポートを出力 → ユーザーに確認を求める
PHASE 2: ユーザー承認後に HTML ファイルを生成する
PHASE 3: ユーザー承認後に GitHub Pages へ公開する
```

- **各フェーズを連続実行しないこと。** 必ず各フェーズ後に次の確認を取ること。
  - PHASE 1 末尾: 「HTMLを作成してよいですか？」
  - PHASE 2 末尾: 「GitHub Pages に公開しますか？」
- PHASE 1 出力形式: Markdown テキスト（チャット上に表示）
- PHASE 2 出力形式: HTML（`reports/2026-06/babyrobe.html` と同一のCSSデザインシステムを使用）
  - 一時出力先: `outputs/reports/[商品名]_analysis_[YYYYMM].html`
- PHASE 3（GitHub Pages 公開）の手順:
  1. `outputs/reports/[ファイル名].html` を `reports/YYYY-MM/[ascii名].html` にコピー
  2. `reports/index.html` の `REPORTS` 配列に新エントリを追加（id / createdAt / period / product / category / brand / asin / platforms / summary / kpi[] / tags[] / file）
  3. 変更をコミット＆プッシュ（`git add reports/ && git commit -m "docs: add [商品名] report [YYYYMM]" && git push origin master`）
  4. 公開 URL を案内: `https://yukiura-code.github.io/amazon-research-os/reports/`
- 構成: 月次サマリー / チャネル構成 / モール別総括 / ユニットエコノミクス / 顧客インサイト / アクション案（6セクション固定）

CSVを貼り付けられたら、分析を始める前に `prompts/monthly-analysis-report.txt` を読み込んで構成・ルールを確認すること。
