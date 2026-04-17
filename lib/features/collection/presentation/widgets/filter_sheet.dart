import 'package:flutter/material.dart';

import '../../domain/entities/stamp_filter.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
    required this.initialFilter,
    required this.collectionOptions,
    required this.categoryOptions,
  });

  final StampFilter initialFilter;
  final Map<int, String> collectionOptions;
  final List<String> categoryOptions;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late TextEditingController _queryController;
  int? _collectionId;
  String _category = '';
  String _condition = '';
  bool? _isNft;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController(
      text: widget.initialFilter.query ?? '',
    );
    _collectionId = widget.initialFilter.collectionId;
    _category = widget.initialFilter.category ?? '';
    _condition = widget.initialFilter.condition ?? '';
    _isNft = widget.initialFilter.isNft;
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _queryController,
            decoration: const InputDecoration(
              labelText: 'Search title or country',
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _collectionId?.toString() ?? 'all',
            decoration: const InputDecoration(labelText: 'Collection'),
            items: [
              const DropdownMenuItem(value: 'all', child: Text('All')),
              ...widget.collectionOptions.entries.map(
                (entry) => DropdownMenuItem(
                  value: entry.key.toString(),
                  child: Text(entry.value),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _collectionId = switch (value) {
                  null || 'all' => null,
                  _ => int.tryParse(value),
                };
              });
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items: [
              const DropdownMenuItem(value: '', child: Text('All')),
              if (_category.isNotEmpty &&
                  !widget.categoryOptions.contains(_category))
                DropdownMenuItem(value: _category, child: Text(_category)),
              ...widget.categoryOptions.map(
                (item) => DropdownMenuItem(value: item, child: Text(item)),
              ),
            ],
            onChanged: (value) => setState(() => _category = value ?? ''),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _condition,
            decoration: const InputDecoration(labelText: 'Condition'),
            items: const [
              DropdownMenuItem(value: '', child: Text('All')),
              DropdownMenuItem(value: 'Mint', child: Text('Mint')),
              DropdownMenuItem(value: 'Used', child: Text('Used')),
            ],
            onChanged: (value) => setState(() => _condition = value ?? ''),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _isNft == null ? 'all' : (_isNft! ? 'yes' : 'no'),
            decoration: const InputDecoration(labelText: 'NFT'),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All')),
              DropdownMenuItem(value: 'yes', child: Text('Yes')),
              DropdownMenuItem(value: 'no', child: Text('No')),
            ],
            onChanged: (value) {
              setState(() {
                _isNft = switch (value) {
                  'yes' => true,
                  'no' => false,
                  _ => null,
                };
              });
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              Navigator.pop(
                context,
                StampFilter(
                  query: _queryController.text.trim(),
                  collectionId: _collectionId,
                  category: _category,
                  condition: _condition,
                  isNft: _isNft,
                ),
              );
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
