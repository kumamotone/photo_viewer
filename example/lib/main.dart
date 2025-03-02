import 'package:flutter/material.dart';
import 'package:photo_viewer/photo_viewer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Viewer Sample'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Simplest Sample'),
            subtitle: const Text('Basic photo viewer implementation'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const SimplestSamplePage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Network Image Sample'),
            subtitle: const Text('Photo viewer with network images'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const NetworkImageSamplePage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Overlay Sample'),
            subtitle: const Text('Photo viewer with comment input overlay'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const OverlaySamplePage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('SNS Sample'),
            subtitle: const Text('Complex implementation with multiple photos'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => PostListPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Gallery Sample'),
            subtitle: const Text('Photo viewer with thumbnails'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const GallerySamplePage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Manga Sample'),
            subtitle: const Text('Photo viewer with page slider'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const MangaSamplePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SimplestSamplePage extends StatelessWidget {
  const SimplestSamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simplest Sample'),
      ),
      body: const Stack(
        children: [
          Center(
            child: PhotoViewerImage(
              imageUrl: 'assets/feed_image.jpg',
            ),
          ),
          _TapMeOverlay(),
        ],
      ),
    );
  }
}

class PostListPage extends StatelessWidget {
  PostListPage({super.key});

  final List<Post> posts = [
    Post(
      username: 'User1',
      screenName: 'user1',
      userIconPath: 'assets/profile.jpg',
      content: 'Single photo post',
      imagePaths: ['assets/feed_image.jpg'],
      postedAt: DateTime.now().subtract(const Duration(hours: 2)),
      commentCount: 12,
      retweetCount: 34,
      likeCount: 150,
      viewCount: 1200,
    ),
    Post(
      username: 'User2',
      screenName: 'user2',
      userIconPath: 'assets/profile.jpg',
      content: 'Two photos post',
      imagePaths: [
        'assets/feed_image.jpg',
        'assets/feed_image2.jpg',
      ],
      postedAt: DateTime.now().subtract(const Duration(hours: 5)),
      commentCount: 8,
      retweetCount: 22,
      likeCount: 95,
      viewCount: 800,
    ),
    Post(
      username: 'User3',
      screenName: 'user3',
      userIconPath: 'assets/profile.jpg',
      content: 'Three photos post',
      imagePaths: [
        'assets/feed_image.jpg',
        'assets/feed_image2.jpg',
        'assets/feed_image3.jpg',
      ],
      postedAt: DateTime.now().subtract(const Duration(hours: 8)),
      commentCount: 15,
      retweetCount: 45,
      likeCount: 210,
      viewCount: 1500,
    ),
    Post(
      username: 'User4',
      screenName: 'user4',
      userIconPath: 'assets/profile.jpg',
      content: 'Four photos post',
      imagePaths: [
        'assets/feed_image.jpg',
        'assets/feed_image2.jpg',
        'assets/feed_image3.jpg',
        'assets/feed_image4.jpg',
      ],
      postedAt: DateTime.now().subtract(const Duration(hours: 12)),
      commentCount: 20,
      retweetCount: 56,
      likeCount: 280,
      viewCount: 2000,
    ),
    Post(
      username: 'User5',
      screenName: 'user5',
      userIconPath: 'assets/profile.jpg',
      content: 'Here are some network images!',
      imagePaths: [
        'http://placehold.jp/24/cc9999/993333/1024x768.png',
        'http://placehold.jp/24/99cc99/333333/1024x768.png',
      ],
      postedAt: DateTime.now().subtract(const Duration(hours: 1)),
      commentCount: 25,
      retweetCount: 65,
      likeCount: 320,
      viewCount: 2500,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SNS Sample'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: posts[index]);
        },
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({required this.post, super.key});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset(post.userIconPath),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '@${post.screenName}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '· ${_getTimeAgo(post.postedAt)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(post.content),
                    if (post.imagePaths.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      PhotoGrid(
                        imagePaths: post.imagePaths,
                        postId: post.id,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _ActionButton(
                          icon: Icons.chat_bubble_outline,
                        ),
                        const _ActionButton(
                          icon: Icons.repeat,
                        ),
                        const _ActionButton(
                          icon: Icons.favorite_border,
                        ),
                        const _ActionButton(
                          icon: Icons.bar_chart,
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {},
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {},
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[200],
        ),
      ],
    );
  }

  String _getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {},
      iconSize: 18,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 30,
        minHeight: 30,
      ),
    );
  }
}

class PhotoGrid extends StatelessWidget {
  const PhotoGrid({
    required this.imagePaths,
    required this.postId,
    super.key,
  });

  final List<String> imagePaths;
  final String postId;

  @override
  Widget build(BuildContext context) {
    switch (imagePaths.length) {
      case 1:
        return _SinglePhoto(imagePath: imagePaths[0], postId: postId);
      case 2:
        return _TwoPhotos(imagePaths: imagePaths, postId: postId);
      case 3:
        return _ThreePhotos(imagePaths: imagePaths, postId: postId);
      case 4:
        return _FourPhotos(imagePaths: imagePaths, postId: postId);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _SinglePhoto extends StatelessWidget {
  const _SinglePhoto({required this.imagePath, required this.postId});
  final String imagePath;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 100,
          child: PhotoViewerMultipleImage(
            imageUrls: [imagePath],
            index: 0,
            id: postId,
          ),
        ),
      ),
    );
  }
}

class _TwoPhotos extends StatelessWidget {
  const _TwoPhotos({required this.imagePaths, required this.postId});
  final List<String> imagePaths;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Row(
        children: [
          for (var i = 0; i < imagePaths.length; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: i == 0 ? const Radius.circular(12) : Radius.zero,
                    right: i == 1 ? const Radius.circular(12) : Radius.zero,
                  ),
                  child: SizedBox.expand(
                    child: PhotoViewerMultipleImage(
                      imageUrls: imagePaths,
                      index: i,
                      id: postId,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThreePhotos extends StatelessWidget {
  const _ThreePhotos({required this.imagePaths, required this.postId});
  final List<String> imagePaths;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: SizedBox.expand(
                child: PhotoViewerMultipleImage(
                  imageUrls: imagePaths,
                  index: 0,
                  id: postId,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                for (var i = 1; i < imagePaths.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: i == 1 ? 4 : 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight:
                              i == 1 ? const Radius.circular(12) : Radius.zero,
                          bottomRight:
                              i == 2 ? const Radius.circular(12) : Radius.zero,
                        ),
                        child: SizedBox.expand(
                          child: PhotoViewerMultipleImage(
                            imageUrls: imagePaths,
                            index: i,
                            id: postId,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FourPhotos extends StatelessWidget {
  const _FourPhotos({required this.imagePaths, required this.postId});
  final List<String> imagePaths;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                for (var i = 0; i < 2; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: i == 0 ? 0 : 4,
                        bottom: 4,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft:
                              i == 0 ? const Radius.circular(12) : Radius.zero,
                          topRight:
                              i == 1 ? const Radius.circular(12) : Radius.zero,
                        ),
                        child: SizedBox.expand(
                          child: PhotoViewerMultipleImage(
                            imageUrls: imagePaths,
                            index: i,
                            id: postId,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                for (var i = 2; i < 4; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: i == 2 ? 0 : 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft:
                              i == 2 ? const Radius.circular(12) : Radius.zero,
                          bottomRight:
                              i == 3 ? const Radius.circular(12) : Radius.zero,
                        ),
                        child: SizedBox.expand(
                          child: PhotoViewerMultipleImage(
                            imageUrls: imagePaths,
                            index: i,
                            id: postId,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Post {
  Post({
    required this.username,
    required this.userIconPath,
    required this.screenName,
    required this.content,
    required this.imagePaths,
    this.postedAt,
    this.commentCount = 0,
    this.retweetCount = 0,
    this.likeCount = 0,
    this.viewCount = 0,
    String? id,
  }) : id = id ?? UniqueKey().toString();

  final String username;
  final String userIconPath;
  final String screenName;
  final String content;
  final List<String> imagePaths;
  final DateTime? postedAt;
  final int commentCount;
  final int retweetCount;
  final int likeCount;
  final int viewCount;
  final String id;
}

class OverlaySamplePage extends StatelessWidget {
  const OverlaySamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overlay Sample'),
      ),
      body: Stack(
        children: [
          Center(
            child: PhotoViewerImage(
              imageUrl: 'assets/feed_image.jpg',
              showDefaultCloseButton: false,
              overlayBuilder: (context) => const Stack(
                children: [
                  _CommentInputOverlay(),
                  _CustomCloseButton(),
                ],
              ),
            ),
          ),
          const _TapMeOverlay(),
        ],
      ),
    );
  }
}

class _CommentInputOverlay extends StatefulWidget {
  const _CommentInputOverlay();

  @override
  State<_CommentInputOverlay> createState() => _CommentInputOverlayState();
}

class _CommentInputOverlayState extends State<_CommentInputOverlay> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSending = false;

  Future<void> _handleSubmit() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isSending = false;
      _controller.clear();
    });
    _focusNode.unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Comment sent!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 80,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _focusNode.unfocus,
      behavior: HitTestBehavior.translucent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.black.withAlpha(128),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SafeArea(
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            style: const TextStyle(color: Colors.white),
                            onSubmitted: (_) => _handleSubmit(),
                            decoration: InputDecoration(
                              hintText: "I'm a custom comment input...",
                              hintStyle:
                                  TextStyle(color: Colors.white.withAlpha(153)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white.withAlpha(51),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: value.text.isEmpty || _isSending
                              ? () {}
                              : _handleSubmit,
                          icon: _isSending
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send),
                          color: Colors.white,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomCloseButton extends StatelessWidget {
  const _CustomCloseButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: SafeArea(
        child: IconButton.filled(
          onPressed: () => Navigator.of(context).pop(),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black.withValues(alpha: 0.8),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(48, 48),
          ),
          icon: const Icon(Icons.arrow_back, size: 24),
        ),
      ),
    );
  }
}

class _TapMeOverlay extends StatelessWidget {
  const _TapMeOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(128),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Tap Me!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GallerySamplePage extends StatefulWidget {
  const GallerySamplePage({super.key});

  static const _imagePaths = [
    'assets/feed_image.jpg',
    'assets/feed_image.jpg',
    'assets/feed_image.jpg',
    'assets/feed_image.jpg',
  ];

  @override
  State<GallerySamplePage> createState() => _GallerySamplePageState();
}

class _GallerySamplePageState extends State<GallerySamplePage> {
  int _currentIndex = 0;
  void Function(int page)? _jumpToPage;

  void _handlePageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _handleThumbnailTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _jumpToPage?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery Sample'),
      ),
      body: Stack(
        children: [
          Center(
            child: PhotoViewerMultipleImage(
              imageUrls: GallerySamplePage._imagePaths,
              index: _currentIndex,
              id: 'gallery',
              onPageChanged: _handlePageChanged,
              onJumpToPage: (jump) {
                _jumpToPage = jump;
              },
              overlayBuilder: (context) => Stack(
                children: [
                  _GalleryThumbnails(
                    imagePaths: GallerySamplePage._imagePaths,
                    selectedIndex: _currentIndex,
                    onTap: _handleThumbnailTap,
                  ),
                ],
              ),
            ),
          ),
          const _TapMeOverlay(),
        ],
      ),
    );
  }
}

class _GalleryThumbnails extends StatelessWidget {
  const _GalleryThumbnails({
    required this.imagePaths,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<String> imagePaths;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 128,
        color: Colors.black.withAlpha(128),
        child: SafeArea(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              final isSelected = index == selectedIndex;
              return Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: Container(
                    width: 64,
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: Image.asset(
                      imagePaths[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MangaSamplePage extends StatefulWidget {
  const MangaSamplePage({super.key});

  static const _imagePaths = [
    'assets/feed_image.jpg',
    'assets/feed_image.jpg',
    'assets/feed_image.jpg',
    'assets/feed_image.jpg',
  ];

  @override
  State<MangaSamplePage> createState() => _MangaSamplePageState();
}

class _MangaSamplePageState extends State<MangaSamplePage> {
  int _currentPage = MangaSamplePage._imagePaths.length - 1;
  void Function(int page)? _jumpToPage;

  void _handlePageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reversedPaths = MangaSamplePage._imagePaths.reversed.toList();
    final totalPages = MangaSamplePage._imagePaths.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manga Sample'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              showPhotoViewer(
                context: context,
                builders: reversedPaths.map<WidgetBuilder>((url) {
                  return (BuildContext context) => Image.asset(
                        url,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                      );
                }).toList(),
                showDefaultCloseButton: false,
                enableVerticalDismiss: false,
                initialPage: _currentPage,
                onPageChanged: _handlePageChanged,
                onJumpToPage: (jump) {
                  _jumpToPage = jump;
                },
                overlayBuilder: (context) => Stack(
                  children: [
                    const _CustomCloseButton(),
                    _MangaPageControl(
                      currentPage: totalPages - _currentPage,
                      totalPages: totalPages,
                      onChanged: (index) {
                        _jumpToPage?.call(totalPages - index - 1);
                      },
                    ),
                  ],
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        reversedPaths[0],
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.8),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            stops: const [0.0, 0.2, 0.8, 1.0],
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 16,
                        left: 16,
                        child: Text(
                          'Sample Manga Title',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${MangaSamplePage._imagePaths.length} pages',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.menu_book,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Start Reading',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MangaPageControl extends StatelessWidget {
  const _MangaPageControl({
    required this.currentPage,
    required this.totalPages,
    required this.onChanged,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.black.withAlpha(128),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white.withAlpha(77),
                    thumbColor: Colors.white,
                    overlayColor: Colors.white.withAlpha(32),
                  ),
                  child: Transform(
                    transform: Matrix4.identity()..scale(-1.0, 1, 1),
                    alignment: Alignment.center,
                    child: Slider(
                      value: currentPage.toDouble(),
                      min: 1,
                      max: totalPages.toDouble(),
                      divisions: totalPages - 1,
                      onChanged: (value) {
                        onChanged(value.toInt() - 1);
                      },
                    ),
                  ),
                ),
              ),
              Text(
                '$currentPage / $totalPages',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkImageSamplePage extends StatelessWidget {
  const NetworkImageSamplePage({super.key});

  static const List<String> networkImages = [
    'http://placehold.jp/24/cc9999/993333/1024x768.png',
    'https://wrongpath',
    'http://placehold.jp/24/9999cc/993333/1024x768.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Image Sample'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: networkImages.length,
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: PhotoViewerMultipleImage(
              imageUrls: networkImages,
              index: index,
              id: 'network_images',
            ),
          );
        },
      ),
    );
  }
}
