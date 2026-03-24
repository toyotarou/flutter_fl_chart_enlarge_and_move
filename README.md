# flutter_fl_chart_enlarge_and_move

最終更新日：2025-02-12

## 概要

`fl_chart` パッケージを使って描画した折れ線グラフを、**X 軸・Y 軸を独立して拡大／縮小**し、**上下左右へスクロール移動**できる Flutter サンプルアプリです。

状態管理には **Riverpod**、不変オブジェクトには **Freezed** を採用しています。

---

## 機能

- X 軸・Y 軸を独立して拡大・縮小（最大 10 倍）
- 上下左右へのグラフ移動（ボタン長押しで連続スクロール）
- リセットボタン（初期表示に一発で戻す）
- sin 波データ（x = 0〜100）を折れ線グラフで表示

---

## ファイル構成

```
lib/
├── main.dart                                   # アプリエントリーポイント（ProviderScope）
├── controllers/
│   └── graph_manipulator/
│       ├── graph_manipulator.dart              # Riverpod Notifier + Freezed State 定義
│       ├── graph_manipulator.freezed.dart      # 自動生成（freezed）
│       └── graph_manipulator.g.dart            # 自動生成（riverpod_generator）
├── mixin/
│   └── graph_manipulator_mixin.dart            # ConsumerState 向け Mixin
└── screens/
    ├── home_screen.dart                        # メイン画面（グラフ表示・操作ボタン）
    └── parts/
        └── hold_button.dart                   # 長押しで連続コールバックを発火するボタン
```

---

## 主要クラス

### `GraphManipulatorState` (`graph_manipulator.dart`)

Freezed で定義されたグラフ操作の状態クラスです。

| フィールド      | 型       | 初期値 | 説明                  |
|----------------|----------|--------|-----------------------|
| `offsetX`      | `double` | `0`    | X 軸の表示開始位置     |
| `offsetY`      | `double` | `0`    | Y 軸の表示開始位置     |
| `scaleX`       | `double` | `1`    | X 軸の拡大倍率         |
| `scaleY`       | `double` | `1`    | Y 軸の拡大倍率         |
| `dataRangeX`   | `double` | `0`    | データの X 軸総範囲    |
| `dataRangeY`   | `double` | `0`    | データの Y 軸総範囲    |

### `GraphManipulator` (`graph_manipulator.dart`)

`@Riverpod(keepAlive: true)` で定義された Notifier クラスです。  
各フィールドの setter メソッドを提供します。

### `GraphManipulatorMixin` (`graph_manipulator_mixin.dart`)

`ConsumerStatefulWidget` の State クラスに mixin として使用します。  
`graphState`（現在の状態）と `graphNotifier`（操作メソッド）に簡潔にアクセスできます。

### `HoldButton` (`hold_button.dart`)

ボタンを押し続けている間、一定間隔（デフォルト 100ms）でコールバックを呼び出すウィジェットです。  
グラフの連続スクロールに使用しています。

---

## 環境

| 項目         | バージョン      |
|-------------|----------------|
| Dart SDK    | `^3.5.0`       |

---

## 依存パッケージ

### dependencies

| パッケージ              | バージョン   | 用途                        |
|------------------------|-------------|---------------------------|
| `fl_chart`             | `^0.69.0`   | 折れ線グラフ描画             |
| `flutter_riverpod`     | `^2.6.1`    | 状態管理（Riverpod）         |
| `hooks_riverpod`       | `^2.6.1`    | Riverpod + Hooks           |
| `riverpod_annotation`  | `^2.6.1`    | Riverpod アノテーション      |
| `freezed_annotation`   | `^2.4.4`    | 不変オブジェクト定義          |
| `json_annotation`      | `^4.9.0`    | JSON シリアライズ            |
| `http`                 | `^1.3.0`    | HTTP 通信                  |
| `intl`                 | `^0.20.2`   | 国際化・日付フォーマット      |

### dev_dependencies

| パッケージ            | バージョン   | 用途                         |
|----------------------|-------------|------------------------------|
| `build_runner`       | `^2.4.13`   | コード生成実行                |
| `freezed`            | `^2.5.7`    | Freezed コード生成            |
| `json_serializable`  | `^6.9.0`    | JSON コード生成               |
| `riverpod_generator` | `^2.6.3`    | Riverpod コード生成           |
| `riverpod_lint`      | `^2.6.3`    | Riverpod 向け lint ルール     |

---

## セットアップ

```bash
# リポジトリのクローン
git clone https://github.com/toyotarou/flutter_fl_chart_enlarge_and_move.git
cd flutter_fl_chart_enlarge_and_move

# パッケージの取得
flutter pub get

# コード生成（freezed / riverpod_generator）
dart run build_runner build --delete-conflicting-outputs

# アプリの実行
flutter run
```

---

## 対応プラットフォーム

- Android
- iOS
- Web
- macOS
- Linux
- Windows
