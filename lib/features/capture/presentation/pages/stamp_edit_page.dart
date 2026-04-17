import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/capture_cubit.dart';
import '../cubit/capture_state.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/utils/responsive.dart';
import '../widgets/capture_preview.dart';
import '../widgets/stamp_border_frame/border_preset_panel.dart';

class StampEditPage extends StatefulWidget {
  const StampEditPage({super.key});

  @override
  State<StampEditPage> createState() => _StampEditPageState();
}

class _StampEditPageState extends State<StampEditPage> {
  late final TextEditingController _notesController;
  final GlobalKey _repaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(
      text: context.read<CaptureCubit>().state.notes,
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleArchive(BuildContext context) async {
    // Save metadata and finish
    context.read<CaptureCubit>().saveCurrentCapture();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CaptureCubit, CaptureState>(
      listener: (context, state) {
        if (state.status == CaptureStatus.success) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Stamp successfully archived to your collection!'),
              backgroundColor: AppColors.tertiaryFixed,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final imagePath = state.draftImagePath;
        if (imagePath == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

        final bool isLargeScreen = !Responsive.isMobile(context);

        return Scaffold(
          backgroundColor: AppColors.background,
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(context),
          body: SafeArea(
            top: false,
            child: isLargeScreen 
                ? _buildLargeScreenLayout(context, state)
                : _buildMobileLayout(context, state),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, CaptureState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 120),
          // Stamp Preview Area
          _buildStampPreview(state),
          const SizedBox(height: 40),
          
          // Editor Controls
          _buildEditorControls(context, state),
        ],
      ),
    );
  }

  Widget _buildLargeScreenLayout(BuildContext context, CaptureState state) {
    return Row(
      children: [
        // Left Side: Fixed Preview
        Expanded(
          flex: 1,
          child: Container(
            color: AppColors.surfaceContainerLow.withValues(alpha: 0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                _buildStampPreview(state),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Review your specimen before archiving it to the permanent collection.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.onSurface.withValues(alpha: 0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right Side: Scrollable Controls
        Expanded(
          flex: 1,
          child: Container(
            color: AppColors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(40, 140, 40, 40),
              child: _buildEditorControls(context, state, isTransparent: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditorControls(BuildContext context, CaptureState state, {bool isTransparent = false}) {
    return Container(
      padding: isTransparent ? EdgeInsets.zero : const EdgeInsets.all(24),
      decoration: isTransparent 
          ? null 
          : BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 40,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BorderPresetPanel(
            editorMode: state.editorMode,
            onToggleEditorMode: context.read<CaptureCubit>().setEditorMode,
            rotationDegrees: state.rotationDegrees,
            onRotationChanged: context.read<CaptureCubit>().setRotationDegrees,
            notchWidthScale: state.notchWidthScale,
            onNotchWidthScaleChanged: context.read<CaptureCubit>().setNotchWidthScale,
            horizontalNotchStretch: state.horizontalNotchStretch,
            onHorizontalNotchStretchChanged: context.read<CaptureCubit>().setHorizontalNotchStretch,
            selected: state.selectedBorderPreset,
            onSelected: context.read<CaptureCubit>().selectBorderPreset,
            selectedOuterShape: state.selectedOuterShape,
            onOuterShapeSelected: context.read<CaptureCubit>().selectOuterShape,
            selectedColorValue: state.selectedBorderColorValue,
            onColorSelected: context.read<CaptureCubit>().selectBorderColor,
            selectedImageFilter: state.selectedImageFilter,
            onImageFilterSelected: context.read<CaptureCubit>().selectImageFilter,
            panelExpansion: state.panelExpansion,
            onToggleExpanded: context.read<CaptureCubit>().toggleFiltersExpanded,
          ),
          const SizedBox(height: 32),
          _buildCollectionSection(context, state),
          const SizedBox(height: 32),
          _buildNotesSection(context, state),
          const SizedBox(height: 40),
          _buildActionButton(context, state),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AppBar(
            backgroundColor: AppColors.white.withValues(alpha: 0.8),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Edit Stamp',
              style: TextStyle(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.more_horiz, color: AppColors.onSurface),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStampPreview(CaptureState state) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CapturePreview(
            loadingState: LoadingState.idle,
            imagePath: state.draftImagePath,
            selectedBorderPreset: state.selectedBorderPreset,
            selectedOuterShape: state.selectedOuterShape,
            selectedBorderColorValue: state.selectedBorderColorValue,
            rotationDegrees: state.rotationDegrees,
            notchWidthScale: state.notchWidthScale,
            horizontalNotchStretch: state.horizontalNotchStretch,
            selectedImageFilter: state.selectedImageFilter,
            editorMode: state.editorMode,
            activeStickers: state.activeStickers,
            repaintBoundaryKey: _repaintKey,
            onInteractionStateChanged: context.read<CaptureCubit>().setInteractionState,
            onStickerUpdated: context.read<CaptureCubit>().updateSticker,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Column(
              children: [
                Text(
                  (state.selectedLocation.isEmpty ? 'UNKNOWN ORIGIN' : state.selectedLocation).toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1.2,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ARCHIVED ${DateTime.now().year}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface.withValues(alpha: 0.5),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // Refined check for layout
  bool get isLargeScreen => !Responsive.isMobile(context);

  Widget _buildCollectionSection(BuildContext context, CaptureState state) {
    final selectedCollection = state.availableCollections.firstWhere(
      (c) => c.id == state.selectedCollectionId,
      orElse: () => state.availableCollections.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catalog to Collection',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _showCollectionPicker(context, state),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: AppColors.onSurface),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    selectedCollection.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                const Icon(Icons.expand_more, color: AppColors.onSurface),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context, CaptureState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stamp Caption/Notes',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Record the memory of this discovery...',
              hintStyle: TextStyle(
                color: AppColors.onSurface.withValues(alpha: 0.4),
                fontSize: 15,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
            ),
            onChanged: (value) => context.read<CaptureCubit>().setNotes(value),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, CaptureState state) {
    final bool isSaving = state.status == CaptureStatus.creating;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSaving ? null : () => _handleArchive(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tertiaryFixed,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 8,
          shadowColor: AppColors.tertiaryFixed.withValues(alpha: 0.4),
        ),
        child: isSaving
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 3,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Finish & Archive',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showCollectionPicker(BuildContext context, CaptureState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (modalContext) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Select Collection',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.availableCollections.length,
                  itemBuilder: (context, index) {
                    final collection = state.availableCollections[index];
                    final isSelected = collection.id == state.selectedCollectionId;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                      title: Text(
                        collection.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? AppColors.tertiaryFixed : AppColors.onSurface,
                        ),
                      ),
                      trailing: isSelected 
                        ? const Icon(Icons.check_circle, color: AppColors.tertiaryFixed)
                        : null,
                      onTap: () {
                        context.read<CaptureCubit>().selectCollectionId(collection.id);
                        Navigator.pop(modalContext);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
