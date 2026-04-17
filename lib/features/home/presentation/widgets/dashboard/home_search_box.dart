import 'package:flutter/material.dart';
import 'package:my_stamp_collection/app/theme/app_colors.dart';

class HomeSearchBox extends StatefulWidget {
  const HomeSearchBox({
    super.key,
    required this.initialQuery,
    required this.onChanged,
  });

  final String initialQuery;
  final ValueChanged<String> onChanged;

  @override
  State<HomeSearchBox> createState() => _HomeSearchBoxState();
}

class _HomeSearchBoxState extends State<HomeSearchBox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void didUpdateWidget(covariant HomeSearchBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery &&
        _controller.text != widget.initialQuery) {
      _controller.text = widget.initialQuery;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'Search your memories...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
