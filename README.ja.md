[English](README.md) | **日本語** | [中文简体](README.zh-CN.md) | [한국어](README.ko.md) | [Español](README.es.md)

# photo_viewer

[![pub package](https://img.shields.io/pub/v/photo_viewer.svg)](https://pub.dev/packages/photo_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/kumamotone/photo_viewer/blob/main/LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A51.17.0-02569B?logo=flutter)](https://flutter.dev)

画像の表示・操作を簡単に実装できる軽量な Flutter ライブラリです。ピンチズーム、ダブルタップズーム、スワイプで閉じる、複数画像のページ送り、カスタムオーバーレイに対応しています。

<p align="center">
  <img src="https://github.com/kumamotone/photo_viewer/raw/main/example.gif" alt="photo_viewer デモ" width="300" />
</p>

## 特徴

| 機能 | 説明 |
|---|---|
| ピンチズーム | 最小・最大倍率を設定可能なスムーズなズーム |
| ダブルタップズーム | タップした位置を中心にズームイン・アウト |
| スワイプで閉じる | 縦方向のスワイプでビューアを閉じる |
| 複数画像ページ送り | `PageView` による画像間のスワイプ切り替え |
| カスタムオーバーレイ | ビューア上に任意のウィジェットを配置 |
| Hero アニメーション | シームレスな開閉トランジション |
| 複数ソース対応 | アセット、ネットワーク、ファイル画像 |

### プラットフォーム対応

| Android | iOS | macOS | Windows | Linux |
|:---:|:---:|:---:|:---:|:---:|
| ✅ | ✅ | ✅ | ✅ | ✅ |

## はじめかた

`pubspec.yaml` に `photo_viewer` を追加してください：

```yaml
dependencies:
  photo_viewer: ^1.0.0
```

その後、以下を実行します：

```sh
flutter pub get
```

## 使い方

### 単一画像

```dart
PhotoViewerImage(
  imageUrl: 'assets/your_image.jpg',
)
```

画像をタップするとフルスクリーンビューアが開きます。アセット、ネットワーク、ファイルパスに対応しています。

```dart
// ネットワーク画像
PhotoViewerImage(
  imageUrl: 'https://example.com/photo.jpg',
)
```

### 複数画像

```dart
PhotoViewerMultipleImage(
  imageUrls: [
    'assets/image1.jpg',
    'https://example.com/image2.jpg',
    'assets/image3.jpg',
  ],
  index: 0,
  id: 'gallery',
)
```

### カスタムオーバーレイ

ビューア上に独自の UI を追加できます：

```dart
PhotoViewerImage(
  imageUrl: 'assets/photo.jpg',
  overlayBuilder: (context) => Stack(
    children: [
      YourCustomCommentInput(),
      YourCustomCloseButton(),
    ],
  ),
  showDefaultCloseButton: false,
)
```

### サムネイル付きギャラリー

```dart
PhotoViewerMultipleImage(
  imageUrls: imagePaths,
  index: currentIndex,
  id: 'gallery',
  onPageChanged: (index) {
    setState(() => currentIndex = index);
  },
  onJumpToPage: (jump) {
    jumpToPage = jump;
  },
  overlayBuilder: (context) => YourCustomThumbnails(
    imagePaths: imagePaths,
    selectedIndex: currentIndex,
    onTap: (index) => jumpToPage(index),
  ),
)
```

### 上級: `showPhotoViewer` を直接呼び出す

完全な制御が必要な場合は `showPhotoViewer` を直接呼び出せます：

```dart
showPhotoViewer(
  context: context,
  builders: imageUrls.map<WidgetBuilder>((url) {
    return (BuildContext context) => Image.asset(
          url,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.contain,
        );
  }).toList(),
  initialPage: 0,
);
```

漫画リーダーなど、ページ構築やスワイプ挙動、オーバーレイを細かく制御したい場合に便利です。

## カスタマイズ

| プロパティ | 型 | デフォルト | 説明 |
|---|---|---|---|
| `minScale` | `double` | `1.0` | 最小ズーム倍率 |
| `maxScale` | `double` | `3.0` | 最大ズーム倍率 |
| `showDefaultCloseButton` | `bool` | `true` | デフォルトの閉じるボタンの表示/非表示 |
| `enableVerticalDismiss` | `bool` | `true` | スワイプで閉じる機能の有効/無効 |
| `fit` | `BoxFit` | `BoxFit.cover` | 画像のフィットモード |
| `overlayBuilder` | `WidgetBuilder?` | `null` | カスタムオーバーレイウィジェット |
| `onPageChanged` | `ValueChanged<int>?` | `null` | ページ変更コールバック |
| `onJumpToPage` | `Function?` | `null` | 指定ページへのジャンプ関数を提供 |

## サンプル

完全な実装例については [example](https://github.com/kumamotone/photo_viewer/tree/main/example) プロジェクトをご覧ください：

- 基本的な画像ビューア
- SNS フィード風の画像グリッド
- サムネイル付きギャラリー
- コメントオーバーレイ
- 漫画/書籍リーダー
- カスタムジェスチャー

## ライセンス

MIT License — 詳細は [LICENSE](https://github.com/kumamotone/photo_viewer/blob/main/LICENSE) を参照してください。
