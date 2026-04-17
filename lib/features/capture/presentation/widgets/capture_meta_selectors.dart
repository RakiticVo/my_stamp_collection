import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../cubit/capture_state.dart';

class CaptureMetaSelectors extends StatefulWidget {
  const CaptureMetaSelectors({
    super.key,
    required this.availableCollections,
    required this.selectedCollectionId,
    required this.availableCategories,
    required this.selectedCategory,
    required this.selectedLocation,
    required this.selectedTitle,
    required this.selectedDate,
    required this.isFetchingLocation,
    required this.onCollectionChanged,
    required this.onCategoryChanged,
    required this.onLocationChanged,
    required this.onTitleChanged,
    required this.onDateChanged,
    required this.onCreateCollection,
    required this.onCreateCategory,
  });

  final List<CaptureCollectionOption> availableCollections;
  final int selectedCollectionId;
  final List<String> availableCategories;
  final String selectedCategory;
  final String selectedLocation;
  final String selectedTitle;
  final DateTime? selectedDate;
  final bool isFetchingLocation;
  final ValueChanged<int> onCollectionChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<DateTime> onDateChanged;
  final Future<void> Function(String) onCreateCollection;
  final Future<void> Function(String) onCreateCategory;

  @override
  State<CaptureMetaSelectors> createState() => _CaptureMetaSelectorsState();
}

class _CaptureMetaSelectorsState extends State<CaptureMetaSelectors> {
  late final TextEditingController _locationController;
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.selectedLocation);
    _titleController = TextEditingController(text: widget.selectedTitle);
  }

  @override
  void didUpdateWidget(covariant CaptureMetaSelectors oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedLocation != oldWidget.selectedLocation &&
        widget.selectedLocation != _locationController.text) {
      _locationController.text = widget.selectedLocation;
    }
    if (widget.selectedTitle != oldWidget.selectedTitle &&
        widget.selectedTitle != _titleController.text) {
      _titleController.text = widget.selectedTitle;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  InputDecoration _getInputDecoration({
    required String label,
    String? hintText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600),
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.onSurface.withValues(alpha: 0.4)),
      prefixIcon: prefixIcon != null ? IconTheme(
        data: const IconThemeData(color: AppColors.primary),
        child: prefixIcon,
      ) : null,
      filled: true,
      fillColor: AppColors.surfaceContainerLow.withValues(alpha: 0.5), // Subtle background
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _titleController,
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.onSurface),
          decoration: _getInputDecoration(
            label: 'Stamp Name',
            hintText: 'Enter stamp name...',
            prefixIcon: const Icon(Icons.title_rounded, size: 20),
          ),
          onChanged: widget.onTitleChanged,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _locationController,
          enabled: !widget.isFetchingLocation,
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.onSurface),
          decoration: _getInputDecoration(
            label: 'Location',
            hintText: 'Where did you get this?',
            prefixIcon: widget.isFetchingLocation
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    ),
                  )
                : const Icon(Icons.location_on_rounded, size: 20),
          ),
          onChanged: widget.onLocationChanged,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () async {
            final DateTime initialDate = widget.selectedDate ?? DateTime.now();
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(1800),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primary,
                      onPrimary: AppColors.white,
                      onSurface: AppColors.onSurface,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              widget.onDateChanged(picked);
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              key: ValueKey(widget.selectedDate),
              initialValue: widget.selectedDate != null
                  ? DateFormat('MMM dd, yyyy').format(widget.selectedDate!)
                  : '',
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.onSurface),
              decoration: _getInputDecoration(
                label: 'Date',
                prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          key: ValueKey(widget.selectedCollectionId),
          initialValue: widget.selectedCollectionId,
          decoration: _getInputDecoration(label: 'Collection'),
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.onSurface),
          items: widget.availableCollections
              .map(
                (item) => DropdownMenuItem(
                  value: item.id,
                  child: Text(item.name),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value != null) {
              widget.onCollectionChanged(value);
            }
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _showNameDialog(
              context: context,
              title: 'New Collection',
              hintText: 'Collection name',
              onSubmit: widget.onCreateCollection,
            ),
            icon: const Icon(Icons.add, color: AppColors.primary),
            label: const Text(
              'New Collection',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          key: ValueKey(widget.selectedCategory),
          initialValue: widget.selectedCategory,
          decoration: _getInputDecoration(label: 'Category'),
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.onSurface),
          items: widget.availableCategories
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value != null) {
              widget.onCategoryChanged(value);
            }
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _showNameDialog(
              context: context,
              title: 'New Category',
              hintText: 'Category name',
              onSubmit: (value) async => widget.onCreateCategory(value),
            ),
            icon: const Icon(Icons.add, color: AppColors.primary),
            label: const Text(
              'New Category',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showNameDialog({
    required BuildContext context,
    required String title,
    required String hintText,
    required Future<void> Function(String value) onSubmit,
  }) async {
    final TextEditingController controller = TextEditingController();
    final String? value = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.onSurface),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.onSurface.withValues(alpha: 0.4)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.w700),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(controller.text.trim());
              },
              child: const Text('Create', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );

    if (value != null && value.isNotEmpty) {
      await onSubmit(value);
    }
    controller.dispose();
  }
}
