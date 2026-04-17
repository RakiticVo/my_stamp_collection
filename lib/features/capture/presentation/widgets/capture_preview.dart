import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../cubit/capture_state.dart';
import 'stamp_border_frame/stamp_border_frame.dart';

class CapturePreview extends StatefulWidget {
  const CapturePreview({
    super.key,
    required this.loadingState,
    required this.selectedBorderPreset,
    required this.selectedOuterShape,
    required this.selectedBorderColorValue,
    required this.rotationDegrees,
    required this.notchWidthScale,
    required this.horizontalNotchStretch,
    required this.selectedImageFilter,
    required this.editorMode,
    required this.activeStickers,
    required this.repaintBoundaryKey,
    required this.onInteractionStateChanged,
    required this.onStickerUpdated,
    this.imagePath,
  });

  final LoadingState loadingState;
  final String? imagePath;
  final StampBorderPreset selectedBorderPreset;
  final StampOuterShape selectedOuterShape;
  final int? selectedBorderColorValue;
  final double rotationDegrees;
  final double notchWidthScale;
  final double horizontalNotchStretch;
  final StampImageFilter selectedImageFilter;
  final EditorMode editorMode;
  final List<StampSticker> activeStickers;
  final GlobalKey repaintBoundaryKey;
  final ValueChanged<InteractionState> onInteractionStateChanged;
  final ValueChanged<StampSticker> onStickerUpdated;

  @override
  State<CapturePreview> createState() => _CapturePreviewState();
}

class _CapturePreviewState extends State<CapturePreview> {
  static const double _baseScale = 1.0;
  static const double _minScale = 0.55;
  late final TransformationController _transformController;
  String? _lastImagePath;
  
  // Local state for smooth sticker dragging
  String? _draggingId;
  Offset? _draggingOffset;

  Matrix4 _initialTransform() {
    return Matrix4.diagonal3Values(_baseScale, _baseScale, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _lastImagePath = widget.imagePath;
    _transformController = TransformationController(_initialTransform());
  }

  @override
  void didUpdateWidget(covariant CapturePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_lastImagePath != widget.imagePath) {
      _lastImagePath = widget.imagePath;
      _transformController.value = _initialTransform();
      widget.onInteractionStateChanged(InteractionState.idle);
    }
  }

  @override
  void dispose() {
    widget.onInteractionStateChanged(InteractionState.idle);
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          // Dark "Collector's Felt" theme using standardized dark tokens
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surfaceContainerHighest, AppColors.surfaceContainerHigh],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16.0),
            AspectRatio(
              aspectRatio: 3 / 4,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return RepaintBoundary(
                    key: widget.repaintBoundaryKey,
                    child: StampBorderFrame(
                      preset: widget.selectedBorderPreset,
                      outerShape: widget.selectedOuterShape,
                      colorOverride: widget.selectedBorderColorValue == null
                        ? null
                        : Color(widget.selectedBorderColorValue!),
                      notchWidthScale: widget.notchWidthScale,
                      horizontalNotchStretch: widget.horizontalNotchStretch,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: widget.imagePath == null
                                ? Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [AppColors.surfaceContainerLow, AppColors.surfaceContainerLowest],
                                      ),
                                    ),
                                  )
                                : InteractiveViewer(
                                    transformationController: _transformController,
                                    minScale: _minScale,
                                    maxScale: 4.0,
                                    panEnabled: widget.editorMode == EditorMode.adjust,
                                    scaleEnabled: widget.editorMode == EditorMode.adjust,
                                    constrained: false,
                                    boundaryMargin: const EdgeInsets.all(140),
                                    onInteractionStart: widget.editorMode == EditorMode.adjust
                                        ? (_) => widget.onInteractionStateChanged(InteractionState.active)
                                        : null,
                                    onInteractionEnd: widget.editorMode == EditorMode.adjust
                                        ? (_) => widget.onInteractionStateChanged(InteractionState.idle)
                                        : null,
                                    child: SizedBox(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight,
                                      child: Transform.rotate(
                                        angle: widget.rotationDegrees * (math.pi / 180),
                                        child: ColorFiltered(
                                          colorFilter: widget.selectedImageFilter.getColorFilter,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: FileImage(File(widget.imagePath!)),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          ...widget.activeStickers.map((sticker) {
                            final bool isDragging = _draggingId == sticker.id;
                            final Offset position = isDragging ? _draggingOffset! : sticker.offset;
                            
                            return Positioned(
                              left: position.dx,
                              top: position.dy,
                              child: GestureDetector(
                                onPanStart: widget.editorMode == EditorMode.preview 
                                  ? (_) {
                                      setState(() {
                                        _draggingId = sticker.id;
                                        _draggingOffset = sticker.offset;
                                      });
                                    }
                                  : null,
                                onPanUpdate: widget.editorMode == EditorMode.preview
                                    ? (details) {
                                        setState(() {
                                          _draggingOffset = _draggingOffset! + details.delta;
                                        });
                                      }
                                    : null,
                                onPanEnd: widget.editorMode == EditorMode.preview
                                    ? (_) {
                                        if (_draggingId != null && _draggingOffset != null) {
                                          widget.onStickerUpdated(
                                            sticker.copyWith(offset: _draggingOffset),
                                          );
                                        }
                                        setState(() {
                                          _draggingId = null;
                                          _draggingOffset = null;
                                        });
                                      }
                                    : null,
                                child: Transform.scale(
                                  scale: sticker.scale,
                                  child: Transform.rotate(
                                    angle: sticker.rotation,
                                    child: sticker.text != null
                                      ? Text(
                                          sticker.text!,
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            color: sticker.color ?? Colors.black.withValues(alpha: 0.7),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Icon(
                                          sticker.iconData ?? Icons.star,
                                          color: sticker.color ?? Colors.black54,
                                          size: 40,
                                        ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: RepaintBoundary(
                child: Text(
                  widget.loadingState == LoadingState.active ? 'MINTING...' : 'STAMP PREVIEW',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
