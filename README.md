# photo_viewer

[![pub package](https://img.shields.io/pub/v/photo_viewer.svg)](https://pub.dev/packages/photo_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/kumamotone/photo_viewer/blob/main/LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A51.17.0-02569B?logo=flutter)](https://flutter.dev)

A lightweight Flutter library for displaying and interacting with images. Supports pinch-to-zoom, double-tap zoom, swipe-to-dismiss, multi-image pagination, and custom overlays — with minimal setup.

<p align="center">
  <img src="https://github.com/kumamotone/photo_viewer/raw/main/example.gif" alt="photo_viewer demo" width="300" />
</p>

## Features

| Feature | Description |
|---|---|
| Pinch-to-zoom | Smooth zoom with configurable min/max scale |
| Double-tap zoom | Tap to zoom in/out at the tapped position |
| Swipe to dismiss | Vertical swipe to close the viewer |
| Multi-image pagination | Swipe between multiple images with `PageView` |
| Custom overlays | Add any widget on top of the viewer |
| Hero animations | Seamless open/close transitions |
| Multiple sources | Asset, network, and file images |

### Platform Support

| Android | iOS | macOS | Windows | Linux |
|:---:|:---:|:---:|:---:|:---:|
| ✅ | ✅ | ✅ | ✅ | ✅ |

## Getting Started

Add `photo_viewer` to your `pubspec.yaml`:

```yaml
dependencies:
  photo_viewer: ^0.1.0
```

Then run:

```sh
flutter pub get
```

## Usage

### Single Image

```dart
PhotoViewerImage(
  imageUrl: 'assets/your_image.jpg',
)
```

Tap the image to open a full-screen viewer. Works with asset, network, and file paths.

```dart
// Network image
PhotoViewerImage(
  imageUrl: 'https://example.com/photo.jpg',
)
```

### Multiple Images

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

### Custom Overlays

Add your own UI on top of the viewer:

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

### Gallery with Thumbnails

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

### Advanced: Direct `showPhotoViewer`

For full control, call `showPhotoViewer` directly:

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

This is useful for cases like a manga/book reader where you need fine-grained control over page building, dismiss behavior, and overlays.

## Customization

| Property | Type | Default | Description |
|---|---|---|---|
| `minScale` | `double` | `1.0` | Minimum zoom scale |
| `maxScale` | `double` | `3.0` | Maximum zoom scale |
| `showDefaultCloseButton` | `bool` | `true` | Show/hide the default close button |
| `enableVerticalDismiss` | `bool` | `true` | Enable/disable swipe to dismiss |
| `fit` | `BoxFit` | `BoxFit.cover` | Image fit mode |
| `overlayBuilder` | `WidgetBuilder?` | `null` | Custom overlay widget |
| `onPageChanged` | `ValueChanged<int>?` | `null` | Page change callback |
| `onJumpToPage` | `Function?` | `null` | Provides a function to jump to a specific page |

## Example

Check out the [example](https://github.com/kumamotone/photo_viewer/tree/main/example) project for complete samples:

- Basic image viewer
- Social media feed with image grids
- Gallery with thumbnails
- Comment overlay
- Manga/book reader
- Custom gesture handling

## License

MIT License — see [LICENSE](https://github.com/kumamotone/photo_viewer/blob/main/LICENSE) for details.
