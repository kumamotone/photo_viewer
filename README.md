# photo_viewer

<img src="./example.gif" width=300>

A versatile Flutter library for displaying and interacting with images in your app.

## Features

- Image zoom with pinch gestures
- Double-tap zoom functionality
- Vertical swipe to dismiss
- Multiple image viewing with pagination
- Custom overlay support
- Hero animation support

## Installation

To use this plugin, add install_plugin as a dependency in your pubspec.yaml file. For example:

```
dependencies:
  photo_viewer: '^0.0.1'
```

## Basic Usage

### Single Image Display

The simplest way to use PhotoViewer is to display a single image:

```dart
PhotoViewerImage(
  imageUrl: 'assets/your_image.jpg',
)
```

This creates a tappable image that opens a full-screen viewer when tapped.

### Multiple Images Display

To display multiple images with swipe navigation:

```dart
PhotoViewerMultipleImage(
  imageUrls: ['assets/image1.jpg', 'assets/image2.jpg', 'assets/image3.jpg'],
  index: 0, // Initial image index
  id: 'unique_id', // Unique identifier for Hero animation
)
```

### Direct Display Function

For more control, use the `showPhotoViewer` function:

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

## Advanced Usage

### Custom Overlays

Add custom UI elements on top of the image viewer:

```dart
PhotoViewerImage(
  imageUrl: 'assets/your_image.jpg',
  overlayBuilder: (context) => Stack(
    children: [
      YourCustomCommentInput(),
      YourCustomCloseButton(),
    ],
  ),
  showDefaultCloseButton: false, // Hide the default close button
)
```

### Gallery with Thumbnails

Create a gallery-style image viewer with thumbnails:

```dart
PhotoViewerMultipleImage(
  imageUrls: imagePaths,
  index: currentIndex,
  id: 'gallery',
  onPageChanged: (index) {
    // Update your state with the current index
    setState(() {
      currentIndex = index;
    });
  },
  onJumpToPage: (jump) {
    // Store the jump function to programmatically change pages
    jumpToPage = jump;
  },
  overlayBuilder: (context) => YourCustomThumbnails(
    imagePaths: imagePaths,
    selectedIndex: currentIndex,
    onTap: (index) {
      // Use the stored jump function to navigate to the selected thumbnail
      jumpToPage(index);
    },
  ),
)
```

### Manga/Book Reader Implementation

Create a comic book or manga reader with custom page controls:

```dart
showPhotoViewer(
  context: context,
  builders: pages.map<WidgetBuilder>((page) {
    return (BuildContext context) => Image.asset(
          page,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.contain,
        );
  }).toList(),
  showDefaultCloseButton: false,
  enableVerticalDismiss: false, // Disable vertical swipe to dismiss
  initialPage: currentPage,
  onPageChanged: (index) {
    // Update your state with the current page
  },
  onJumpToPage: (jump) {
    // Store the jump function for page navigation
  },
  overlayBuilder: (context) => Stack(
    children: [
      YourCustomCloseButton(),
      YourCustomPageControls(
        currentPage: currentPage,
        totalPages: totalPages,
        onPageChanged: (index) {
          // Use the stored jump function to navigate to the selected page
        },
      ),
    ],
  ),
)
```

## Customization Options

PhotoViewer provides various customization options:

- `minScale`/`maxScale`: Set the minimum and maximum zoom scale
- `showDefaultCloseButton`: Toggle the default close button visibility
- `enableVerticalDismiss`: Enable or disable vertical swipe to dismiss
- `borderRadius`: Set corner radius for images

This automatically arranges 1-4 images in an attractive grid layout that opens the PhotoViewer when tapped.

## Example

Check out the example project in the `example` folder for complete implementation samples including:

- Basic image viewer
- Social media feed with image grids
- Gallery with thumbnails
- Comment overlay
- Manga/book reader

## License

This project is licensed under the MIT License - see the LICENSE file for details.
