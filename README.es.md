[English](README.md) | [日本語](README.ja.md) | [中文简体](README.zh-CN.md) | [한국어](README.ko.md) | **Español**

# photo_viewer

[![pub package](https://img.shields.io/pub/v/photo_viewer.svg)](https://pub.dev/packages/photo_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/kumamotone/photo_viewer/blob/main/LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A51.17.0-02569B?logo=flutter)](https://flutter.dev)

Una biblioteca ligera de Flutter para mostrar e interactuar con imágenes. Soporta zoom con pellizco, zoom con doble toque, deslizar para cerrar, paginación de múltiples imágenes y superposiciones personalizadas — con una configuración mínima.

<p align="center">
  <img src="https://github.com/kumamotone/photo_viewer/raw/main/example.gif" alt="demo de photo_viewer" width="300" />
</p>

## Características

| Característica | Descripción |
|---|---|
| Zoom con pellizco | Zoom suave con escala mínima/máxima configurable |
| Zoom con doble toque | Ampliar/reducir en la posición tocada |
| Deslizar para cerrar | Deslizamiento vertical para cerrar el visor |
| Paginación múltiple | Deslizar entre múltiples imágenes con `PageView` |
| Superposiciones personalizadas | Agregar cualquier widget sobre el visor |
| Animaciones Hero | Transiciones de apertura/cierre fluidas |
| Múltiples fuentes | Imágenes de assets, red y archivos locales |

### Soporte de plataformas

| Android | iOS | macOS | Windows | Linux |
|:---:|:---:|:---:|:---:|:---:|
| ✅ | ✅ | ✅ | ✅ | ✅ |

## Primeros pasos

Agrega `photo_viewer` a tu `pubspec.yaml`:

```yaml
dependencies:
  photo_viewer: ^1.0.0
```

Luego ejecuta:

```sh
flutter pub get
```

## Uso

### Imagen individual

```dart
PhotoViewerImage(
  imageUrl: 'assets/your_image.jpg',
)
```

Toca la imagen para abrir un visor a pantalla completa. Funciona con assets, URLs de red y rutas de archivos.

```dart
// Imagen de red
PhotoViewerImage(
  imageUrl: 'https://example.com/photo.jpg',
)
```

### Múltiples imágenes

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

### Superposiciones personalizadas

Agrega tu propia interfaz sobre el visor:

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

### Galería con miniaturas

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

### Avanzado: Llamar directamente a `showPhotoViewer`

Para un control total, llama directamente a `showPhotoViewer`:

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

Útil para casos como un lector de manga/libros donde necesitas control detallado sobre la construcción de páginas, el comportamiento de cierre y las superposiciones.

## Personalización

| Propiedad | Tipo | Valor por defecto | Descripción |
|---|---|---|---|
| `minScale` | `double` | `1.0` | Escala mínima de zoom |
| `maxScale` | `double` | `3.0` | Escala máxima de zoom |
| `showDefaultCloseButton` | `bool` | `true` | Mostrar/ocultar el botón de cerrar predeterminado |
| `enableVerticalDismiss` | `bool` | `true` | Activar/desactivar deslizar para cerrar |
| `fit` | `BoxFit` | `BoxFit.cover` | Modo de ajuste de imagen |
| `overlayBuilder` | `WidgetBuilder?` | `null` | Widget de superposición personalizado |
| `onPageChanged` | `ValueChanged<int>?` | `null` | Callback de cambio de página |
| `onJumpToPage` | `Function?` | `null` | Proporciona una función para saltar a una página específica |

## Ejemplo

Consulta el proyecto [example](https://github.com/kumamotone/photo_viewer/tree/main/example) para ejemplos completos:

- Visor de imágenes básico
- Cuadrícula de imágenes estilo red social
- Galería con miniaturas
- Superposición de comentarios
- Lector de manga/libros
- Manejo de gestos personalizados

## Licencia

Licencia MIT — consulta [LICENSE](https://github.com/kumamotone/photo_viewer/blob/main/LICENSE) para más detalles.
