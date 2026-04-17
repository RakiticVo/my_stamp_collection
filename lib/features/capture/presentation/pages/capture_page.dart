import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/utils/responsive.dart';
import '../cubit/capture_cubit.dart';
import '../cubit/capture_state.dart';
import '../widgets/capture_header.dart';
import '../widgets/capture_shutter_button.dart';
import 'gallery_page.dart';
import 'stamp_edit_page.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isInitializing = false;
  int _currentCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing) return;

    debugPrint('--- Starting Camera Initialization ---');
    final cameras = context.read<CaptureCubit>().state.cameras;
    if (cameras.isEmpty) {
      debugPrint('No cameras found, attempting to re-fetch...');
      await context.read<CaptureCubit>().initializeCameras();
      if (!mounted) return;
    }

    final updatedCameras = context.read<CaptureCubit>().state.cameras;
    if (updatedCameras.isEmpty) {
      debugPrint('CRITICAL: No cameras available after re-fetch.');
      if (mounted) {
        setState(() => _isInitializing = false);
      }
      return;
    }

    if (mounted) setState(() => _isInitializing = true);

    if (_controller != null) {
      debugPrint('Disposing old controller...');
      await _controller!.dispose();
      if (!mounted) return;
    }

    _currentCameraIndex = context.read<CaptureCubit>().state.cameraIndex;
    debugPrint('Connecting to camera at index: $_currentCameraIndex');

    _controller = CameraController(
      updatedCameras[_currentCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      debugPrint('Initializing controller...');
      await _controller!.initialize();
      debugPrint('Controller initialized successfully.');

      if (!mounted) return;

      if (_controller != null) {
        await _controller!.setFlashMode(
          context.read<CaptureCubit>().state.flashMode,
        );
      }
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('CAMERA INITIALIZATION ERROR: $e');
    } finally {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
      debugPrint('--- Camera Initialization Finished ---');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;

    try {
      final XFile file = await _controller!.takePicture();
      if (mounted) {
        context.read<CaptureCubit>().setDraft(file.path, 'Camera');
      }
    } catch (e) {
      debugPrint('Take picture error: $e');
    }
  }

  void _onFlipCamera() {
    context.read<CaptureCubit>().toggleCamera();
    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CaptureCubit, CaptureState>(
      listenWhen: (previous, current) =>
          previous.draftImagePath == null && current.draftImagePath != null,
      listener: (context, state) {
        if (state.cameraIndex != _currentCameraIndex) {
          _initializeCamera();
        }
        if (_controller != null && _controller!.value.isInitialized) {
          _controller!.setFlashMode(state.flashMode);
        }

        // Navigation to Editor when a draft is ready
        if (state.draftImagePath != null &&
            state.status != CaptureStatus.success) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const StampEditPage())).then((
            _,
          ) {
            if (!context.mounted) return;
            if (context.read<CaptureCubit>().state.draftImagePath != null) {
              context.read<CaptureCubit>().resetCurrentImage();
            }
          });
        }
      },
      builder: (context, state) {
        final bool hasImage = (state.draftImagePath ?? '').isNotEmpty;

        return Scaffold(
          backgroundColor: AppColors.black, // True black for camera viewfinder
          body: Stack(
            children: [
              // 1. Camera Feed / Viewfinder
              Positioned.fill(child: _buildCameraFeed(state)),

              // 2. Overlays
              if (!hasImage) _buildViewfinderOverlay(state),

              // 3. Top App Bar (Blurred)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CaptureHeader(),
              ),

              // 4. Controls (Bottom)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: SafeArea(top: false, child: _buildCameraControls(state)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCameraFeed(CaptureState state) {
    if (state.cameras.isEmpty) {
      return Container(
        color: AppColors.black,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 24),
            const Text(
              'No cameras detected on this device.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please ensure camera permissions are granted and the device has functional cameras.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.read<CaptureCubit>().initializeCameras(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: const Text('RETRY INITIALIZATION'),
            ),
          ],
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(
        color: AppColors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              'Awakening the lens...',
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.6),
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return CameraPreview(_controller!);
  }

  Widget _buildViewfinderOverlay(CaptureState state) {
    return SafeArea(
      child: Center(
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Stack(
            children: [
              // Perforated Stamp Border Mask (Simulated)
              Container(
                margin: const EdgeInsets.all(24).copyWith(top: 16, bottom: 48),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.2),
                    width: 16,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              // Location Chip
              Positioned(
                top: 48,
                left: 48,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: AppColors.white.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.selectedLocation.isEmpty
                            ? 'Searching...'
                            : state.selectedLocation.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Focus Brackets
              Center(
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    children: [
                      _buildBracket(
                        top: 0,
                        left: 0,
                        borderTop: true,
                        borderLeft: true,
                      ),
                      _buildBracket(
                        top: 0,
                        right: 0,
                        borderTop: true,
                        borderRight: true,
                      ),
                      _buildBracket(
                        bottom: 0,
                        left: 0,
                        borderBottom: true,
                        borderLeft: true,
                      ),
                      _buildBracket(
                        bottom: 0,
                        right: 0,
                        borderBottom: true,
                        borderRight: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBracket({
    double? top,
    double? bottom,
    double? left,
    double? right,
    bool borderTop = false,
    bool borderBottom = false,
    bool borderLeft = false,
    bool borderRight = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border(
            top: borderTop
                ? const BorderSide(color: AppColors.secondary, width: 4)
                : BorderSide.none,
            bottom: borderBottom
                ? const BorderSide(color: AppColors.secondary, width: 4)
                : BorderSide.none,
            left: borderLeft
                ? const BorderSide(color: AppColors.secondary, width: 4)
                : BorderSide.none,
            right: borderRight
                ? const BorderSide(color: AppColors.secondary, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCameraControls(CaptureState state) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 32 : 64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildControlButton(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryPage()),
                ),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=100&h=100&fit=crop',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                label: 'GALLERY',
              ),
              CaptureShutterButton(onTap: _takePicture),
              _buildControlButton(
                onTap: _onFlipCamera,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.cameraswitch_rounded,
                    color: AppColors.primary,
                  ),
                ),
                label: 'FLIP',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required Widget child,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
