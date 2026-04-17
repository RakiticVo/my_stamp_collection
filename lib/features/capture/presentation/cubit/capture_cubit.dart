import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../collection/data/datasources/collection_local_datasource.dart';
import '../../../collection/domain/entities/stamp_item.dart';
import '../../../collection/domain/usecases/add_stamp.dart';
import '../../../../core/services/location_service.dart';
import 'capture_media_helper.dart';
import 'capture_state.dart';

class CaptureCubit extends Cubit<CaptureState> {
  CaptureCubit(
    this._addStamp,
    this._collectionDataSource, {
    List<CameraDescription> cameras = const [],
  }) : super(CaptureState(selectedLocation: '', cameras: cameras)) {
    loadCaptureMetadata();
  }

  final AddStamp _addStamp;
  final CollectionLocalDataSource _collectionDataSource;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> initializeCameras() async {
    try {
      final cameras = await availableCameras();
      emit(state.copyWith(cameras: cameras));
    } catch (_) {
      // Handle camera initialization error
    }
  }

  void toggleCamera() {
    if (state.cameras.isEmpty) return;
    final nextIndex = (state.cameraIndex + 1) % state.cameras.length;
    emit(state.copyWith(cameraIndex: nextIndex));
  }

  void toggleFlash() {
    final modes = FlashMode.values;
    final currentIndex = modes.indexOf(state.flashMode);
    // Cycle through: off -> auto -> always -> torch -> off
    final nextIndex = (currentIndex + 1) % modes.length;
    emit(state.copyWith(flashMode: modes[nextIndex]));
  }

  Future<void> fetchCurrentLocation() async {
    emit(state.copyWith(locationFetchStatus: LocationFetchStatus.fetching));
    try {
      final String? location = await LocationService.getCurrentCityCountry();
      if (location != null && location.isNotEmpty) {
        emit(
          state.copyWith(
            selectedLocation: location,
            locationFetchStatus: LocationFetchStatus.idle,
          ),
        );
      } else {
        emit(state.copyWith(locationFetchStatus: LocationFetchStatus.idle));
      }
    } catch (_) {
      emit(state.copyWith(locationFetchStatus: LocationFetchStatus.idle));
    }
  }

  Future<void> loadCaptureMetadata() async {
    try {
      final List<CaptureCollectionRecord> rows =
          await _collectionDataSource.getCollections();
      final List<String> categories = await _collectionDataSource.getCategories();
      final List<CaptureCollectionOption> collections = rows
          .map(
            (item) => CaptureCollectionOption(id: item.id, name: item.name),
          )
          .toList(growable: false);

      final int selectedCollectionId = collections.any(
            (item) => item.id == state.selectedCollectionId,
          )
          ? state.selectedCollectionId
          : (collections.isNotEmpty ? collections.first.id : 1);

      emit(
        state.copyWith(
          availableCollections: collections.isEmpty
              ? state.availableCollections
              : collections,
          availableCategories: _mergeCategories(
            state.availableCategories,
            categories,
          ),
          selectedCollectionId: selectedCollectionId,
        ),
      );
    } catch (_) {
      // Keep fallback options if metadata loading fails.
    }
  }

  List<String> _mergeCategories(List<String> defaults, List<String> dynamicItems) {
    final Set<String> normalized = <String>{};
    final List<String> result = <String>[];
    for (final value in <String>[...defaults, ...dynamicItems]) {
      final String trimmed = value.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      final String key = trimmed.toLowerCase();
      if (normalized.add(key)) {
        result.add(trimmed);
      }
    }
    result.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return result;
  }

  Future<void> captureFromCamera() async {
    emit(state.copyWith(status: CaptureStatus.creating));

    try {
      final bool allowed = await CaptureMediaHelper.ensureCameraPermission();
      if (!allowed) {
        emit(state.copyWith(status: CaptureStatus.error));
        return;
      }

      final XFile? captured = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 92,
      );
      if (captured == null) {
        emit(
          state.copyWith(
            status: CaptureStatus.initial,
          ),
        );
        return;
      }

      setDraft(captured.path, 'Camera');
    } catch (_) {
      emit(
        state.copyWith(
          status: CaptureStatus.error,
        ),
      );
    }
  }

  Future<void> importFromGallery() async {
    emit(state.copyWith(status: CaptureStatus.creating));

    try {
      final bool allowed = await CaptureMediaHelper.ensureGalleryPermission();
      if (!allowed) {
        emit(state.copyWith(status: CaptureStatus.error));
        return;
      }

      final XFile? picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 92,
      );
      if (picked == null) {
        emit(
          state.copyWith(
            status: CaptureStatus.initial,
          ),
        );
        return;
      }

      setDraft(picked.path, 'Gallery');
    } catch (_) {
      emit(
        state.copyWith(
          status: CaptureStatus.error,
        ),
      );
    }
  }

  void selectBorderPreset(StampBorderPreset preset) {
    if (preset == state.selectedBorderPreset) {
      return;
    }
    emit(state.copyWith(selectedBorderPreset: preset));
  }

  void selectOuterShape(StampOuterShape shape) {
    if (shape == state.selectedOuterShape) return;
    emit(state.copyWith(selectedOuterShape: shape));
  }

  void selectCollectionId(int collectionId) {
    if (collectionId == state.selectedCollectionId) {
      return;
    }
    emit(state.copyWith(selectedCollectionId: collectionId));
  }

  void selectCategory(String category) {
    if (category == state.selectedCategory) {
      return;
    }
    emit(state.copyWith(selectedCategory: category));
  }

  Future<void> createCollection(String name) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      emit(
        state.copyWith(
          status: CaptureStatus.error,
        ),
      );
      return;
    }

    try {
      final int id = await _collectionDataSource.createCollection(trimmed);
      final List<CaptureCollectionOption> next = <CaptureCollectionOption>[
        ...state.availableCollections,
        CaptureCollectionOption(id: id, name: trimmed),
      ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      emit(
        state.copyWith(
          availableCollections: next,
          selectedCollectionId: id,
          status: CaptureStatus.initial,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CaptureStatus.error,
        ),
      );
    }
  }

  Future<void> createCategory(String name) async {
    final String normalized = name.trim();
    if (normalized.isEmpty) {
      emit(
        state.copyWith(
          status: CaptureStatus.error,
        ),
      );
      return;
    }

    final bool exists = state.availableCategories.any(
      (item) => item.toLowerCase() == normalized.toLowerCase(),
    );
    if (exists) {
      final String selected = state.availableCategories.firstWhere(
        (item) => item.toLowerCase() == normalized.toLowerCase(),
      );
      emit(state.copyWith(selectedCategory: selected));
      return;
    }

    final List<String> next = <String>[
      ...state.availableCategories,
      normalized,
    ]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    emit(
      state.copyWith(
        availableCategories: next,
        selectedCategory: normalized,
        status: CaptureStatus.initial,
      ),
    );
  }

  void selectBorderColor(Color? color) {
    if (color == null) {
      emit(state.copyWith(clearSelectedBorderColorValue: true));
      return;
    }

    emit(state.copyWith(selectedBorderColorValue: color.toARGB32()));
  }

  void setRotationDegrees(double value) {
    final double normalized = value.clamp(-45.0, 45.0);
    emit(state.copyWith(rotationDegrees: normalized));
  }

  void setNotchWidthScale(double value) {
    final double normalized = value.clamp(0.6, 1.8);
    emit(state.copyWith(notchWidthScale: normalized));
  }

  void setHorizontalNotchStretch(double value) {
    final double normalized = value.clamp(1.0, 2.4);
    emit(state.copyWith(horizontalNotchStretch: normalized));
  }
  
  void selectImageFilter(StampImageFilter filter) {
    if (filter == state.selectedImageFilter) {
      return;
    }
    emit(state.copyWith(selectedImageFilter: filter));
  }

  void selectLocation(String location) {
    emit(state.copyWith(selectedLocation: location));
  }

  void toggleFiltersExpanded() {
    emit(state.copyWith(
      panelExpansion: state.panelExpansion == PanelExpansion.collapsed
          ? PanelExpansion.expanded
          : PanelExpansion.collapsed,
    ));
  }

  void selectTitle(String title) {
    emit(state.copyWith(selectedTitle: title));
  }

  void setEditorMode(EditorMode mode) {
    if (mode == state.editorMode) return;
    emit(state.copyWith(editorMode: mode));
  }

  void setInteractionState(InteractionState stateValue) {
    if (stateValue == state.interactionState) return;
    emit(state.copyWith(interactionState: stateValue));
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void setNotes(String notes) {
    emit(state.copyWith(notes: notes));
  }

  void resetCurrentImage() {
    emit(
      state.copyWith(
        status: CaptureStatus.initial,
        clearDraftImagePath: true,
        clearSourceLabel: true,
        selectedBorderPreset: StampBorderPreset.classic,
        selectedOuterShape: StampOuterShape.rectangle,
        clearSelectedBorderColorValue: true,
        rotationDegrees: 0,
        notchWidthScale: 1,
        horizontalNotchStretch: 1,
        selectedImageFilter: StampImageFilter.normal,
        selectedLocation: '',
        selectedTitle: '',
        selectedDate: DateTime.now(),
        locationFetchStatus: LocationFetchStatus.idle,
        notes: '',
      ),
    );
  }

  void addSticker(StampSticker sticker) {
    final updatedList = List<StampSticker>.from(state.activeStickers)..add(sticker);
    emit(state.copyWith(activeStickers: updatedList));
  }

  void updateSticker(StampSticker updatedSticker) {
    final updatedList = state.activeStickers.map((s) {
      return s.id == updatedSticker.id ? updatedSticker : s;
    }).toList();
    emit(state.copyWith(activeStickers: updatedList));
  }

  void removeSticker(String stickerId) {
    final updatedList = state.activeStickers.where((s) => s.id != stickerId).toList();
    emit(state.copyWith(activeStickers: updatedList));
  }

  Future<void> saveCurrentCapture({Uint8List? renderedBytes}) async {
    if ((state.draftImagePath ?? '').isEmpty) {
      emit(
        state.copyWith(
          status: CaptureStatus.error,
        ),
      );
      return;
    }

    emit(state.copyWith(status: CaptureStatus.creating));

    try {
      final DateTime saveTime = state.selectedDate ?? DateTime.now();
      final String imagePath;
      if (renderedBytes != null && renderedBytes.isNotEmpty) {
        imagePath = await CaptureMediaHelper.persistRenderedImage(renderedBytes, saveTime);
      } else {
        final File sourceFile = File(state.draftImagePath!);
        imagePath = await CaptureMediaHelper.persistImage(sourceFile, saveTime);
      }

      final String location = state.selectedLocation.trim().isEmpty 
          ? 'Unknown Location' 
          : state.selectedLocation.trim();

      final String title = state.selectedTitle.trim().isEmpty
          ? (state.selectedLocation.isNotEmpty 
              ? '${state.selectedLocation} Stamp'
              : 'New Stamp Capture')
          : state.selectedTitle.trim();

      final StampItem item = StampItem(
        collectionId: state.selectedCollectionId,
        category: state.selectedCategory,
        title: title,
        country: location,
        year: saveTime.year,
        denomination: 0,
        condition: 'Mint',
        isNft: false,
        imagePath: imagePath,
        description: state.notes,
        createdAt: saveTime,
      );
      await _addStamp(item);

      emit(
        state.copyWith(
          status: CaptureStatus.success,
          clearDraftImagePath: true,
          clearSourceLabel: true,
          selectedBorderPreset: StampBorderPreset.classic,
          selectedOuterShape: StampOuterShape.rectangle,
          clearSelectedBorderColorValue: true,
          rotationDegrees: 0,
          notchWidthScale: 1,
          horizontalNotchStretch: 1,
          selectedImageFilter: StampImageFilter.normal,
          selectedLocation: '',
          selectedTitle: '',
          selectedDate: DateTime.now(),
          locationFetchStatus: LocationFetchStatus.idle,
          notes: '',
          activeStickers: const <StampSticker>[],
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CaptureStatus.error,
        ),
      );
    }
  }

  void setDraft(String filePath, String sourceLabel) {
    emit(
      state.copyWith(
        status: CaptureStatus.initial,
        draftImagePath: filePath,
        sourceLabel: sourceLabel,
        selectedBorderPreset: StampBorderPreset.classic,
        selectedOuterShape: StampOuterShape.rectangle,
        clearSelectedBorderColorValue: true,
        rotationDegrees: 0,
        notchWidthScale: 1,
        horizontalNotchStretch: 1,
        selectedImageFilter: StampImageFilter.normal,
        selectedDate: DateTime.now(),
        activeStickers: const <StampSticker>[],
      ),
    );

    // Automatically fetch location when a draft is set
    fetchCurrentLocation();
  }
}
