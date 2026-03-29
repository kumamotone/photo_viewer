[English](README.md) | [日本語](README.ja.md) | **中文简体** | [한국어](README.ko.md) | [Español](README.es.md)

# photo_viewer

[![pub package](https://img.shields.io/pub/v/photo_viewer.svg)](https://pub.dev/packages/photo_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/kumamotone/photo_viewer/blob/main/LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A51.17.0-02569B?logo=flutter)](https://flutter.dev)

一个轻量级的 Flutter 图片查看库。支持双指缩放、双击缩放、滑动关闭、多图分页和自定义覆盖层 — 配置简单。

<p align="center">
  <img src="https://github.com/kumamotone/photo_viewer/raw/main/example.gif" alt="photo_viewer 演示" width="300" />
</p>

## 功能

| 功能 | 描述 |
|---|---|
| 双指缩放 | 可配置最小/最大缩放比例的平滑缩放 |
| 双击缩放 | 在点击位置进行放大/缩小 |
| 滑动关闭 | 垂直滑动关闭查看器 |
| 多图分页 | 使用 `PageView` 在多张图片间滑动切换 |
| 自定义覆盖层 | 在查看器上添加任意组件 |
| Hero 动画 | 无缝的打开/关闭过渡效果 |
| 多来源支持 | 支持资源文件、网络和本地文件图片 |

### 平台支持

| Android | iOS | macOS | Windows | Linux |
|:---:|:---:|:---:|:---:|:---:|
| ✅ | ✅ | ✅ | ✅ | ✅ |

## 开始使用

在 `pubspec.yaml` 中添加 `photo_viewer`：

```yaml
dependencies:
  photo_viewer: ^1.0.0
```

然后运行：

```sh
flutter pub get
```

## 用法

### 单张图片

```dart
PhotoViewerImage(
  imageUrl: 'assets/your_image.jpg',
)
```

点击图片将打开全屏查看器。支持资源文件、网络和本地文件路径。

```dart
// 网络图片
PhotoViewerImage(
  imageUrl: 'https://example.com/photo.jpg',
)
```

### 多张图片

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

### 自定义覆盖层

在查看器上添加自定义 UI：

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

### 缩略图画廊

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

### 进阶：直接调用 `showPhotoViewer`

需要完全控制时，可以直接调用 `showPhotoViewer`：

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

适用于漫画阅读器等需要精细控制页面构建、关闭行为和覆盖层的场景。

## 自定义选项

| 属性 | 类型 | 默认值 | 描述 |
|---|---|---|---|
| `minScale` | `double` | `1.0` | 最小缩放比例 |
| `maxScale` | `double` | `3.0` | 最大缩放比例 |
| `showDefaultCloseButton` | `bool` | `true` | 显示/隐藏默认关闭按钮 |
| `enableVerticalDismiss` | `bool` | `true` | 启用/禁用滑动关闭 |
| `fit` | `BoxFit` | `BoxFit.cover` | 图片填充模式 |
| `overlayBuilder` | `WidgetBuilder?` | `null` | 自定义覆盖层组件 |
| `onPageChanged` | `ValueChanged<int>?` | `null` | 页面变更回调 |
| `onJumpToPage` | `Function?` | `null` | 提供跳转到指定页面的函数 |

## 示例

查看 [example](https://github.com/kumamotone/photo_viewer/tree/main/example) 项目获取完整示例：

- 基础图片查看器
- 社交媒体动态图片网格
- 缩略图画廊
- 评论覆盖层
- 漫画/书籍阅读器
- 自定义手势处理

## 许可证

MIT 许可证 — 详见 [LICENSE](https://github.com/kumamotone/photo_viewer/blob/main/LICENSE)。
