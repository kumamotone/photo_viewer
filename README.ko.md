[English](README.md) | [日本語](README.ja.md) | [中文简体](README.zh-CN.md) | **한국어** | [Español](README.es.md)

# photo_viewer

[![pub package](https://img.shields.io/pub/v/photo_viewer.svg)](https://pub.dev/packages/photo_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/kumamotone/photo_viewer/blob/main/LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A51.17.0-02569B?logo=flutter)](https://flutter.dev)

이미지를 간편하게 표시하고 조작할 수 있는 가벼운 Flutter 라이브러리입니다. 핀치 줌, 더블 탭 줌, 스와이프로 닫기, 다중 이미지 페이지네이션, 커스텀 오버레이를 지원합니다.

<p align="center">
  <img src="https://github.com/kumamotone/photo_viewer/raw/main/example.gif" alt="photo_viewer 데모" width="300" />
</p>

## 기능

| 기능 | 설명 |
|---|---|
| 핀치 줌 | 최소/최대 배율 설정 가능한 부드러운 줌 |
| 더블 탭 줌 | 탭한 위치를 중심으로 확대/축소 |
| 스와이프로 닫기 | 세로 스와이프로 뷰어 닫기 |
| 다중 이미지 페이지네이션 | `PageView`를 사용한 이미지 간 스와이프 전환 |
| 커스텀 오버레이 | 뷰어 위에 원하는 위젯 배치 |
| Hero 애니메이션 | 매끄러운 열기/닫기 트랜지션 |
| 다중 소스 지원 | 에셋, 네트워크, 파일 이미지 |

### 플랫폼 지원

| Android | iOS | macOS | Windows | Linux |
|:---:|:---:|:---:|:---:|:---:|
| ✅ | ✅ | ✅ | ✅ | ✅ |

## 시작하기

`pubspec.yaml`에 `photo_viewer`를 추가하세요:

```yaml
dependencies:
  photo_viewer: ^1.0.0
```

그런 다음 실행합니다:

```sh
flutter pub get
```

## 사용법

### 단일 이미지

```dart
PhotoViewerImage(
  imageUrl: 'assets/your_image.jpg',
)
```

이미지를 탭하면 전체 화면 뷰어가 열립니다. 에셋, 네트워크, 파일 경로를 지원합니다.

```dart
// 네트워크 이미지
PhotoViewerImage(
  imageUrl: 'https://example.com/photo.jpg',
)
```

### 다중 이미지

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

### 커스텀 오버레이

뷰어 위에 커스텀 UI를 추가할 수 있습니다:

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

### 썸네일 갤러리

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

### 고급: `showPhotoViewer` 직접 호출

완전한 제어가 필요한 경우 `showPhotoViewer`를 직접 호출할 수 있습니다:

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

만화 리더 등 페이지 구성, 닫기 동작, 오버레이를 세밀하게 제어해야 하는 경우에 유용합니다.

## 커스터마이징

| 속성 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `minScale` | `double` | `1.0` | 최소 줌 배율 |
| `maxScale` | `double` | `3.0` | 최대 줌 배율 |
| `showDefaultCloseButton` | `bool` | `true` | 기본 닫기 버튼 표시/숨기기 |
| `enableVerticalDismiss` | `bool` | `true` | 스와이프로 닫기 활성화/비활성화 |
| `fit` | `BoxFit` | `BoxFit.cover` | 이미지 맞춤 모드 |
| `overlayBuilder` | `WidgetBuilder?` | `null` | 커스텀 오버레이 위젯 |
| `onPageChanged` | `ValueChanged<int>?` | `null` | 페이지 변경 콜백 |
| `onJumpToPage` | `Function?` | `null` | 특정 페이지로 이동하는 함수 제공 |

## 예제

완전한 구현 예제는 [example](https://github.com/kumamotone/photo_viewer/tree/main/example) 프로젝트를 확인하세요:

- 기본 이미지 뷰어
- SNS 피드 이미지 그리드
- 썸네일 갤러리
- 댓글 오버레이
- 만화/도서 리더
- 커스텀 제스처 처리

## 라이선스

MIT License — 자세한 내용은 [LICENSE](https://github.com/kumamotone/photo_viewer/blob/main/LICENSE)를 참조하세요.
