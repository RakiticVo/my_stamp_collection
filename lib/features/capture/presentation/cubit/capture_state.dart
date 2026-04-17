import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';

enum CaptureStatus { initial, creating, success, error }

enum StampBorderPreset {
  classic,
  heritage,
  modern,
  victorian,
  minimal,
  dotted,
  plain,
}

enum StampImageFilter {
  normal,
  vintage,
  sepia,
  blackAndWhite,
  vivid,
  warm,
  cool,
}

enum StampOuterShape { rectangle, circle, hexagon, diamond, octagon, shield }

enum LocationFetchStatus { idle, fetching }
enum PanelExpansion { collapsed, expanded }
enum LoadingState { idle, active }
enum EditorMode { preview, adjust }
enum InteractionState { idle, active }

class CaptureCollectionOption extends Equatable {
  const CaptureCollectionOption({required this.id, required this.name});

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

extension StampBorderPresetX on StampBorderPreset {
  String get label {
    switch (this) {
      case StampBorderPreset.classic:
        return 'Archive Round';
      case StampBorderPreset.heritage:
        return 'Heritage Zigzag';
      case StampBorderPreset.modern:
        return 'Modern Square';
      case StampBorderPreset.victorian:
        return 'Victorian Elegance';
      case StampBorderPreset.minimal:
        return 'Slate Minimal';
      case StampBorderPreset.dotted:
        return 'Fine Dotted';
      case StampBorderPreset.plain:
        return 'Solid Border';
    }
  }
}

extension StampImageFilterX on StampImageFilter {
  String get label {
    switch (this) {
      case StampImageFilter.normal:
        return 'Original';
      case StampImageFilter.vintage:
        return 'Vintage';
      case StampImageFilter.sepia:
        return 'Sepia';
      case StampImageFilter.blackAndWhite:
        return 'B&W';
      case StampImageFilter.vivid:
        return 'Vivid';
      case StampImageFilter.warm:
        return 'Warm';
      case StampImageFilter.cool:
        return 'Cool';
    }
  }

  ColorFilter get getColorFilter {
    switch (this) {
      case StampImageFilter.vintage:
        return const ColorFilter.matrix([
          0.9, 0.1, 0.1, 0.0, 0.0,
          0.1, 0.8, 0.1, 0.0, 0.0,
          0.1, 0.1, 0.7, 0.0, 0.0,
          0.0, 0.0, 0.0, 1.0, 0.0,
        ]);
      case StampImageFilter.sepia:
        return const ColorFilter.matrix([
          0.393, 0.769, 0.189, 0.0, 0.0,
          0.349, 0.686, 0.168, 0.0, 0.0,
          0.272, 0.534, 0.131, 0.0, 0.0,
          0.0, 0.0, 0.0, 1.0, 0.0,
        ]);
      case StampImageFilter.blackAndWhite:
        return const ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0.0, 0.0,
          0.2126, 0.7152, 0.0722, 0.0, 0.0,
          0.2126, 0.7152, 0.0722, 0.0, 0.0,
          0.0, 0.0, 0.0, 1.0, 0.0,
        ]);
      case StampImageFilter.vivid:
        return const ColorFilter.matrix([
          1.2, 0.0, 0.0, 0.0, 0.0,
          0.0, 1.2, 0.0, 0.0, 0.0,
          0.0, 0.0, 1.2, 0.0, 0.0,
          0.0, 0.0, 0.0, 1.0, 0.0,
        ]);
      case StampImageFilter.warm:
        return const ColorFilter.matrix([
          1.1, 0.0, 0.0, 0.0, 0.0,
          0.0, 1.0, 0.0, 0.0, 0.0,
          0.0, 0.0, 0.8, 0.0, 0.0,
          0.0, 0.0, 0.0, 1.0, 0.0,
        ]);
      case StampImageFilter.cool:
        return const ColorFilter.matrix([
          0.8, 0.0, 0.0, 0.0, 0.0,
          0.0, 1.0, 0.0, 0.0, 0.0,
          0.0, 0.0, 1.2, 0.0, 0.0,
          0.0, 0.0, 0.0, 1.0, 0.0,
        ]);
      case StampImageFilter.normal:
      return const ColorFilter.mode(AppColors.transparent, BlendMode.dst);
    }
  }
}

class StampSticker extends Equatable {
  const StampSticker({
    required this.id,
    this.text,
    this.iconData,
    this.color,
    this.offset = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
  });

  final String id;
  final String? text;
  final IconData? iconData;
  final Color? color;
  final Offset offset;
  final double scale;
  final double rotation;

  StampSticker copyWith({
    String? id,
    String? text,
    IconData? iconData,
    Color? color,
    Offset? offset,
    double? scale,
    double? rotation,
  }) {
    return StampSticker(
      id: id ?? this.id,
      text: text ?? this.text,
      iconData: iconData ?? this.iconData,
      color: color ?? this.color,
      offset: offset ?? this.offset,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  @override
  List<Object?> get props => [id, text, iconData, color, offset, scale, rotation];
}

class CaptureState extends Equatable {
  const CaptureState({
    this.status = CaptureStatus.initial,
    this.draftImagePath,
    this.sourceLabel,
    this.selectedBorderPreset = StampBorderPreset.classic,
    this.selectedOuterShape = StampOuterShape.rectangle,
    this.availableCollections = const <CaptureCollectionOption>[
      CaptureCollectionOption(id: 1, name: 'My Vault'),
      CaptureCollectionOption(id: 2, name: 'Travel Diary'),
      CaptureCollectionOption(id: 3, name: 'Rare Finds'),
    ],
    this.availableCategories = const <String>[
      'General',
      'Nature',
      'Architecture',
      'Landmarks',
      'Coastal',
    ],
    this.selectedBorderColorValue,
    this.rotationDegrees = 0,
    this.notchWidthScale = 1,
    this.horizontalNotchStretch = 1,
    this.selectedImageFilter = StampImageFilter.normal,
    this.selectedCollectionId = 1,
    this.selectedCategory = 'General',
    this.selectedDate,
    this.locationFetchStatus = LocationFetchStatus.idle,
    required this.selectedLocation,
    this.selectedTitle = '',
    this.panelExpansion = PanelExpansion.collapsed,
    this.activeStickers = const <StampSticker>[],
    this.editorMode = EditorMode.preview,
    this.interactionState = InteractionState.idle,
    this.cameras = const [],
    this.cameraIndex = 0,
    this.flashMode = FlashMode.off,
    this.notes = '',
  });

  final CaptureStatus status;
  final String? draftImagePath;
  final String? sourceLabel;
  final StampBorderPreset selectedBorderPreset;
  final StampOuterShape selectedOuterShape;
  final List<CaptureCollectionOption> availableCollections;
  final List<String> availableCategories;
  final int selectedCollectionId;
  final String selectedCategory;
  final int? selectedBorderColorValue;
  final double rotationDegrees;
  final double notchWidthScale;
  final double horizontalNotchStretch;
  final StampImageFilter selectedImageFilter;
  final String selectedLocation;
  final DateTime? selectedDate;
  final LocationFetchStatus locationFetchStatus;
  final String selectedTitle;
  final PanelExpansion panelExpansion;
  final EditorMode editorMode;
  final InteractionState interactionState;
  final List<CameraDescription> cameras;
  final int cameraIndex;
  final FlashMode flashMode;
  final String notes;
  final List<StampSticker> activeStickers;

  CaptureState copyWith({
    CaptureStatus? status,
    String? draftImagePath,
    String? sourceLabel,
    StampBorderPreset? selectedBorderPreset,
    StampOuterShape? selectedOuterShape,
    List<CaptureCollectionOption>? availableCollections,
    List<String>? availableCategories,
    int? selectedCollectionId,
    String? selectedCategory,
    int? selectedBorderColorValue,
    double? rotationDegrees,
    double? notchWidthScale,
    double? horizontalNotchStretch,
    StampImageFilter? selectedImageFilter,
    String? selectedLocation,
    DateTime? selectedDate,
    LocationFetchStatus? locationFetchStatus,
    String? selectedTitle,
    PanelExpansion? panelExpansion,
    EditorMode? editorMode,
    InteractionState? interactionState,
    List<CameraDescription>? cameras,
    int? cameraIndex,
    FlashMode? flashMode,
    String? notes,
    List<StampSticker>? activeStickers,
    bool clearDraftImagePath = false,
    bool clearSourceLabel = false,
    bool clearSelectedBorderColorValue = false,
  }) {
    return CaptureState(
      status: status ?? this.status,
      draftImagePath: clearDraftImagePath
          ? null
          : (draftImagePath ?? this.draftImagePath),
      sourceLabel: clearSourceLabel ? null : (sourceLabel ?? this.sourceLabel),
      selectedBorderPreset: selectedBorderPreset ?? this.selectedBorderPreset,
      selectedOuterShape: selectedOuterShape ?? this.selectedOuterShape,
      availableCollections: availableCollections ?? this.availableCollections,
      availableCategories: availableCategories ?? this.availableCategories,
      selectedCollectionId: selectedCollectionId ?? this.selectedCollectionId,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedBorderColorValue: clearSelectedBorderColorValue
          ? null
          : (selectedBorderColorValue ?? this.selectedBorderColorValue),
      rotationDegrees: rotationDegrees ?? this.rotationDegrees,
      notchWidthScale: notchWidthScale ?? this.notchWidthScale,
      horizontalNotchStretch:
          horizontalNotchStretch ?? this.horizontalNotchStretch,
      selectedImageFilter: selectedImageFilter ?? this.selectedImageFilter,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedDate: selectedDate ?? this.selectedDate,
      locationFetchStatus: locationFetchStatus ?? this.locationFetchStatus,
      selectedTitle: selectedTitle ?? this.selectedTitle,
      panelExpansion: panelExpansion ?? this.panelExpansion,
      editorMode: editorMode ?? this.editorMode,
      interactionState: interactionState ?? this.interactionState,
      cameras: cameras ?? this.cameras,
      cameraIndex: cameraIndex ?? this.cameraIndex,
      flashMode: flashMode ?? this.flashMode,
      notes: notes ?? this.notes,
      activeStickers: activeStickers ?? this.activeStickers,
    );
  }

  @override
  List<Object?> get props => [
    status,
    draftImagePath,
    sourceLabel,
    selectedBorderPreset,
    selectedOuterShape,
    availableCollections,
    availableCategories,
    selectedCollectionId,
    selectedCategory,
    selectedBorderColorValue,
    rotationDegrees,
    notchWidthScale,
    horizontalNotchStretch,
    selectedImageFilter,
    selectedLocation,
    selectedDate,
    locationFetchStatus,
    selectedTitle,
    panelExpansion,
    editorMode,
    interactionState,
    cameras,
    cameraIndex,
    flashMode,
    notes,
    activeStickers,
  ];
}
