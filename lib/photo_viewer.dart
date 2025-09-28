import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

bool _isNetworkUrl(String url) {
  return url.startsWith('http://') || url.startsWith('https://');
}

bool _isPathUrl(String url) {
  return url.startsWith('/data');
}

Widget _buildImageFromUrl(
  String url, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  Widget Function(BuildContext, String)? placeholder,
  Widget Function(BuildContext, String, dynamic)? errorWidget,
}) {
  if (_isNetworkUrl(url)) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      placeholder: placeholder ??
          (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: errorWidget ??
          (context, url, error) => const Icon(Icons.error, color: Colors.grey),
    );
  } else if (_isPathUrl(url)) {
    return Image.file(
      File(url),
      fit: fit,
      width: width,
      height: height,
    );
  } else {
    return Image.asset(
      url,
      fit: fit,
      width: width,
      height: height,
    );
  }
}

/// A [TransparentPageRoute] is a route that becomes transparent when navigated.
/// It allows you to see through to the previous route when this one is active.
class TransparentPageRoute<T> extends PageRoute<T> {
  TransparentPageRoute({
    required this.builder,
  }) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  bool get maintainState => true;

  @override
  Color? get barrierColor => null;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: builder(context),
    );
  }
}

/// A [VerticalSwipeDismissible] widget allows its child widget to be dismissed
/// by a vertical swipe gesture.
class VerticalSwipeDismissible extends StatefulWidget {
  const VerticalSwipeDismissible({
    required this.child,
    super.key,
    this.enabled = true,
    this.dismissThreshold = 0.2,
    this.onDismissed,
  });

  final Widget child;
  final bool enabled;
  final double dismissThreshold;
  final VoidCallback? onDismissed;

  @override
  VerticalSwipeDismissibleState createState() =>
      VerticalSwipeDismissibleState();
}

class VerticalSwipeDismissibleState extends State<VerticalSwipeDismissible>
    with SingleTickerProviderStateMixin {
  late final AnimationController animateController;
  late Animation<Offset> moveAnimation;

  double dragAmount = 0;
  bool isDragging = false;
  int pointersCount = 0;
  PointerDownEvent? initialPointerEvent;
  bool isHorizontalSwipeDetected = false;

  @override
  void initState() {
    super.initState();
    animateController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _updateAnimations();
  }

  void _updateAnimations() {
    final end = dragAmount.sign;
    moveAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, end),
    ).animate(animateController);
  }

  void handleDragStart(PointerDownEvent event) {
    initialPointerEvent = event;
    isHorizontalSwipeDetected = false;
    isDragging = true;
    if (animateController.isAnimating) {
      dragAmount =
          animateController.value * context.size!.height * dragAmount.sign;
      animateController.stop();
    } else {
      dragAmount = 0.0;
      animateController.value = 0.0;
    }
  }

  void handleDragUpdate(PointerMoveEvent event) {
    final isActive = isDragging || animateController.isAnimating;
    if (!isActive || animateController.isAnimating) {
      return;
    }

    if (event.delta.dx.abs() > event.delta.dy.abs()) {
      return;
    }

    final delta = event.delta.dy * 0.6;
    final oldDragExtent = dragAmount;
    setState(() {
      dragAmount += delta;
    });
    if (oldDragExtent.sign != dragAmount.sign) {
      _updateAnimations();
    }
    if (!animateController.isAnimating) {
      animateController.value = dragAmount.abs() / context.size!.height;
    }
  }

  void handleDragEnd() {
    final isActive = isDragging || animateController.isAnimating;
    if (!isActive || animateController.isAnimating) {
      return;
    }
    isDragging = false;
    isHorizontalSwipeDetected = false;
    initialPointerEvent = null;
    if (animateController.isCompleted) {
      return;
    }
    if (!animateController.isDismissed) {
      if (animateController.value > widget.dismissThreshold) {
        widget.onDismissed?.call();
      } else {
        animateController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        pointersCount++;
        if (pointersCount == 1) {
          handleDragStart(event);
        }
      },
      onPointerUp: (event) {
        pointersCount--;
        if (pointersCount == 0) {
          handleDragEnd();
        }
      },
      onPointerCancel: widget.enabled
          ? (event) {
              pointersCount--;
            }
          : null,
      onPointerMove: widget.enabled
          ? (event) {
              if (pointersCount < 2) {
                if (!isHorizontalSwipeDetected && initialPointerEvent != null) {
                  final dx =
                      event.position.dx - initialPointerEvent!.position.dx;
                  final dy =
                      event.position.dy - initialPointerEvent!.position.dy;

                  if (dx.abs() > dy.abs() && dx.abs() > 10) {
                    isHorizontalSwipeDetected = true;
                    isDragging = false;
                    dragAmount = 0;
                    animateController.value = 0.0;
                    return;
                  }
                }

                if (!isHorizontalSwipeDetected) {
                  handleDragUpdate(event);
                }
              } else {
                handleDragEnd();
                dragAmount = 0;
                animateController.value = 0.0;
              }
            }
          : null,
      child: ColoredBox(
        color: Colors.black,
        child: SlideTransition(
          position: moveAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}

class PhotoViewerCloseButton extends StatelessWidget {
  const PhotoViewerCloseButton({
    required this.closeButtonVisibilityController,
    required this.onDismiss,
    super.key,
  });
  final AnimationController closeButtonVisibilityController;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.4),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: closeButtonVisibilityController,
            curve: Curves.easeOut,
          ),
        ),
        child: FadeTransition(
          opacity: closeButtonVisibilityController,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: onDismiss,
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget to display a single photo viewer image
class PhotoViewerImage extends StatelessWidget {
  const PhotoViewerImage({
    required this.imageUrl,
    this.overlayBuilder,
    this.minScale,
    this.maxScale,
    this.borderRadius = 16,
    this.showDefaultCloseButton = true,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.onLongPress,
    this.onDoubleTap,
    super.key,
  });

  final String imageUrl;
  final WidgetBuilder? overlayBuilder;
  final double? minScale;
  final double? maxScale;
  final double borderRadius;
  final bool showDefaultCloseButton;
  final BoxFit fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return PhotoViewerMultipleImage(
      imageUrls: [imageUrl],
      index: 0,
      id: 'photo_viewer_$imageUrl',
      overlayBuilder: overlayBuilder,
      minScale: minScale,
      maxScale: maxScale,
      borderRadius: borderRadius,
      showDefaultCloseButton: showDefaultCloseButton,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
    );
  }
}

/// A widget to display multiple photo viewer images
class PhotoViewerMultipleImage extends StatelessWidget {
  const PhotoViewerMultipleImage({
    required this.imageUrls,
    required this.index,
    required this.id,
    this.overlayBuilder,
    this.minScale,
    this.maxScale,
    this.borderRadius = 16,
    this.showDefaultCloseButton = true,
    this.onPageChanged,
    this.onJumpToPage,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.onLongPress,
    this.onDoubleTap,
    super.key,
  });

  final List<String> imageUrls;
  final int index;
  final String id;
  final WidgetBuilder? overlayBuilder;
  final double? minScale;
  final double? maxScale;
  final double borderRadius;
  final bool showDefaultCloseButton;
  final ValueChanged<int>? onPageChanged;
  final void Function(void Function(int page) jump)? onJumpToPage;
  final BoxFit fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  final VoidCallback? onLongPress;

  final VoidCallback? onDoubleTap;

  String _heroTag(int index) =>
      'photo_viewer_${id}_${index}_${imageUrls[index]}';

  @override
  Widget build(BuildContext context) {
    void defaultOnTap() {
      showPhotoViewer(
        context: context,
        builders: imageUrls.map<WidgetBuilder>((url) {
          return (BuildContext context) => _buildImageFromUrl(
                url,
                fit: fit,
                placeholder: placeholder,
                errorWidget: errorWidget,
              );
        }).toList(),
        heroTagBuilder: _heroTag,
        initialPage: index,
        overlayBuilder: overlayBuilder,
        minScale: minScale,
        maxScale: maxScale,
        showDefaultCloseButton: showDefaultCloseButton,
        onPageChanged: onPageChanged,
        onJumpToPage: onJumpToPage,
      );
    }

    final child = Hero(
      tag: _heroTag(index),
      child: _buildImageFromUrl(
        imageUrls[index],
        fit: fit,
        placeholder: placeholder,
        errorWidget: errorWidget,
      ),
    );

    return GestureDetector(
      onTap: defaultOnTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      child: child,
    );
  }
}

/// [PhotoViewerScreen] can display either a single photo or multiple photos
/// (via [builders]) using a [PageView].
class PhotoViewerScreen extends StatefulWidget {
  const PhotoViewerScreen({
    this.builder,
    this.builders,
    this.overlayBuilder,
    this.minScale = 1.0,
    this.maxScale = 3.0,
    this.heroTagBuilder,
    this.initialPage = 0,
    this.showDefaultCloseButton = true,
    this.onPageChanged,
    this.onJumpToPage,
    this.enableVerticalDismiss = true,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    super.key,
  });

  /// Single-photo builder (if multiple are not provided).
  final WidgetBuilder? builder;

  /// Multiple-photo builders. If provided and not empty, a PageView is used.
  final List<WidgetBuilder>? builders;

  final WidgetBuilder? overlayBuilder;
  final double minScale;
  final double maxScale;
  final String Function(int index)? heroTagBuilder;
  final int initialPage;
  final bool showDefaultCloseButton;
  final ValueChanged<int>? onPageChanged;
  final void Function(void Function(int page) jump)? onJumpToPage;
  final bool enableVerticalDismiss;
  final BoxFit fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  @override
  PhotoViewerScreenState createState() => PhotoViewerScreenState();
}

class PhotoViewerScreenState extends State<PhotoViewerScreen>
    with TickerProviderStateMixin {
  late final AnimationController controlsVisibilityController;
  late final PageController pageController;
  late final List<TransformationController> transformControllers;
  late final List<AnimationController> animationControllers;
  late int currentPage;

  bool isScrolling = false;
  ValueNotifier<bool> isZoomed = ValueNotifier(false);

  List<WidgetBuilder> get effectiveBuilders =>
      widget.builders ?? [widget.builder!];

  @override
  void initState() {
    super.initState();

    controlsVisibilityController = AnimationController(
      value: 1,
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    final length = effectiveBuilders.length;
    transformControllers = List.generate(
      length,
      (_) => TransformationController(),
    );
    animationControllers = List.generate(
      length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    pageController = PageController(initialPage: widget.initialPage);

    currentPage = widget.initialPage;

    widget.onJumpToPage?.call(jumpToPage);

    pageController.addListener(() {
      final page = pageController.page?.round() ?? currentPage;
      if (page != currentPage) {
        setState(() {
          currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    controlsVisibilityController.dispose();
    for (final controller in animationControllers) {
      controller.dispose();
    }
    for (final controller in transformControllers) {
      controller.dispose();
    }
    isZoomed.dispose();
    pageController.dispose();
    super.dispose();
  }

  void onDismiss() {
    Navigator.of(context).pop();
  }

  void jumpToPage(int page) {
    if (page >= 0 && page < effectiveBuilders.length) {
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          VerticalSwipeDismissible(
            onDismissed: onDismiss,
            enabled:
                widget.enableVerticalDismiss && !isZoomed.value && !isScrolling,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (notification is ScrollStartNotification) {
                    setState(() {
                      isScrolling = true;
                    });
                  } else if (notification is ScrollEndNotification) {
                    setState(() {
                      isScrolling = false;
                    });
                  }
                });
                return true;
              },
              child: ValueListenableBuilder<bool>(
                valueListenable: isZoomed,
                builder: (context, zoomed, child) {
                  return PageView.builder(
                    physics: zoomed
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    controller: pageController,
                    itemCount: effectiveBuilders.length,
                    itemBuilder: buildPageItem,
                    onPageChanged: widget.onPageChanged,
                  );
                },
              ),
            ),
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(controlsVisibilityController),
            child: FadeTransition(
              opacity: controlsVisibilityController,
              child: widget.overlayBuilder?.call(context) ??
                  const SizedBox.shrink(),
            ),
          ),
          if (widget.showDefaultCloseButton)
            PhotoViewerCloseButton(
              closeButtonVisibilityController: controlsVisibilityController,
              onDismiss: onDismiss,
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget buildPageItem(BuildContext context, int index) {
    final Widget child = InteractivePhotoPage(
      isScrolling: isScrolling,
      transformationController: transformControllers[index],
      animationController: animationControllers[index],
      minScale: widget.minScale,
      maxScale: widget.maxScale,
      builder: effectiveBuilders[index],
      controlsVisibilityController: controlsVisibilityController,
      onDismiss: onDismiss,
      heroTag: currentPage == index
          ? (widget.heroTagBuilder?.call(index) ?? '')
          : '',
      useHero: currentPage == index,
      onScaleChanged: (scale) {
        final zoomed = scale > widget.minScale;
        if (isZoomed.value != zoomed) {
          isZoomed.value = zoomed;
        }
      },
      fit: widget.fit,
      placeholder: widget.placeholder,
      errorWidget: widget.errorWidget,
    );

    return child;
  }
}

/// A single photo page with pinch-to-zoom, double-tap zoom, and vertical swipe
/// dismiss.
class InteractivePhotoPage extends StatefulWidget {
  const InteractivePhotoPage({
    required this.transformationController,
    required this.animationController,
    required this.builder,
    required this.minScale,
    required this.maxScale,
    required this.controlsVisibilityController,
    required this.onDismiss,
    required this.isScrolling,
    required this.heroTag,
    required this.useHero,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.onScaleChanged,
    super.key,
  });

  final TransformationController transformationController;
  final AnimationController animationController;
  final WidgetBuilder builder;
  final double minScale;
  final double maxScale;
  final AnimationController controlsVisibilityController;
  final VoidCallback onDismiss;
  final bool isScrolling;
  final void Function(double scale)? onScaleChanged;
  final String heroTag;
  final bool useHero;
  final BoxFit fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  @override
  State<InteractivePhotoPage> createState() => _InteractivePhotoPageState();
}

class _InteractivePhotoPageState extends State<InteractivePhotoPage> {
  Animation<Matrix4>? animation;
  Offset doubleTapPosition = Offset.zero;
  bool isDismissEnabled = true;
  bool isDismissed = false;
  bool isZoomed = false;
  int _pointerCount = 0;

  @override
  void initState() {
    super.initState();
    widget.animationController.addListener(() {
      widget.transformationController.value =
          animation?.value ?? Matrix4.identity();
    });
  }

  void onScaleChanged(double scale) {
    if (isDismissed) return;
    final zoomed = scale > widget.minScale;
    widget.onScaleChanged?.call(scale);
    isZoomed = zoomed;

    if (!zoomed) {
      widget.controlsVisibilityController.forward();
      if (!isDismissEnabled) {
        setState(() {
          isDismissEnabled = true;
        });
      }
    } else {
      if (isDismissEnabled) {
        setState(() {
          isDismissEnabled = false;
        });
      }
    }
  }

  void changeVisibility() {
    if (widget.controlsVisibilityController.status ==
        AnimationStatus.completed) {
      widget.controlsVisibilityController.reverse();
    } else {
      widget.controlsVisibilityController.forward();
    }
  }

  void doubleTap() {
    final currentScale = widget.transformationController.value.row0.x;
    final isZoomed = currentScale > widget.minScale;
    Matrix4 end;
    if (isZoomed) {
      end = Matrix4.identity();
      widget.onScaleChanged?.call(widget.minScale);
    } else {
      end = Matrix4.identity()
        ..translateByDouble(
          -doubleTapPosition.dx * (widget.maxScale / 2),
          -doubleTapPosition.dy * (widget.maxScale / 2),
          0,
          1,
        )
        ..scaleByDouble(widget.maxScale, widget.maxScale, 1, 1);
      widget.onScaleChanged?.call(widget.maxScale);
    }
    animation = Matrix4Tween(
      begin: widget.transformationController.value,
      end: end,
    ).animate(
      CurveTween(curve: Curves.easeOut).animate(widget.animationController),
    );
    widget.animationController.forward(from: 0).whenComplete(() {
      onScaleChanged(isZoomed ? widget.minScale : widget.maxScale);
    });
  }

  void onDismiss() {
    setState(() {
      isDismissed = true;
    });
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) {
        changeVisibility();
        _pointerCount--;
      },
      onPointerDown: (_) {
        _pointerCount++;
        if (_pointerCount >= 2) {
          widget.onScaleChanged?.call(widget.maxScale);
        }
      },
      onPointerCancel: (_) {
        _pointerCount--;
      },
      child: GestureDetector(
        onDoubleTap: doubleTap,
        onDoubleTapDown: (details) {
          doubleTapPosition = details.localPosition;
        },
        child: InteractiveViewer(
          onInteractionStart: (details) {
            widget.controlsVisibilityController.reverse();
            if (details.pointerCount >= 2) {
              widget.onScaleChanged?.call(widget.maxScale);
            }
          },
          onInteractionEnd: (_) {
            onScaleChanged(widget.transformationController.value.row0.x);
          },
          transformationController: widget.transformationController,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          scaleFactor: 100,
          child: Center(
            child: widget.useHero
                ? Hero(
                    tag: widget.heroTag,
                    child: widget.builder(context),
                  )
                : widget.builder(context),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// Displays a photo viewer on top of the current screen.
/// If [builders] is provided, multiple photos are shown in a PageView.
Future<void> showPhotoViewer({
  required BuildContext context,
  WidgetBuilder? builder,
  List<WidgetBuilder>? builders,
  WidgetBuilder? overlayBuilder,
  double? minScale,
  double? maxScale,
  String Function(int index)? heroTagBuilder,
  int initialPage = 0,
  bool showDefaultCloseButton = true,
  bool enableVerticalDismiss = true,
  ValueChanged<int>? onPageChanged,
  void Function(void Function(int page) jump)? onJumpToPage,
  BoxFit fit = BoxFit.cover,
  Widget Function(BuildContext, String)? placeholder,
  Widget Function(BuildContext, String, dynamic)? errorWidget,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    TransparentPageRoute<dynamic>(
      builder: (ctx) {
        return PhotoViewerScreen(
          builder: builder,
          builders: builders,
          overlayBuilder: overlayBuilder,
          minScale: minScale ?? 1.0,
          maxScale: maxScale ?? 2.0,
          heroTagBuilder: heroTagBuilder,
          initialPage: initialPage,
          showDefaultCloseButton: showDefaultCloseButton,
          enableVerticalDismiss: enableVerticalDismiss,
          onPageChanged: onPageChanged,
          onJumpToPage: onJumpToPage,
          fit: fit,
          placeholder: placeholder,
          errorWidget: errorWidget,
        );
      },
    ),
  );
}
