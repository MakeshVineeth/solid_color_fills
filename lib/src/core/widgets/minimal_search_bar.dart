import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solid_color_fills/src/core/security/input_validator.dart';

/// Compact, theme-aware search bar for filtering color titles.
class MinimalSearchBar extends StatefulWidget {
  final String initialQuery;
  final String hintText;
  final String clearTooltip;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const MinimalSearchBar({
    super.key,
    this.initialQuery = '',
    this.hintText = 'Search colors...',
    this.clearTooltip = 'Clear search',
    required this.onChanged,
    this.onClear,
  });

  @override
  State<MinimalSearchBar> createState() => _MinimalSearchBarState();
}

class _MinimalSearchBarState extends State<MinimalSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant MinimalSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery &&
        widget.initialQuery != InputValidator.sanitizeText(_controller.text)) {
      _controller.value = TextEditingValue(
        text: widget.initialQuery,
        selection: TextSelection.collapsed(offset: widget.initialQuery.length),
      );
    }
  }

  void _handleFocusChange() {
    if (mounted && _hasFocus != _focusNode.hasFocus) {
      setState(() => _hasFocus = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleClear() {
    _controller.clear();
    if (widget.onClear != null) {
      widget.onClear!();
    } else {
      widget.onChanged('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fillColor = isDark ? theme.cardColor : const Color(0xFFF3F4F6);
    final borderColor = _hasFocus
        ? theme.primaryColor.withValues(alpha: 0.65)
        : (isDark ? Colors.white : Colors.black)
            .withValues(alpha: isDark ? 0.08 : 0.07);
    final mutedColor = isDark ? Colors.white70 : const Color(0xFF5F6368);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      constraints: const BoxConstraints(minHeight: 48),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        autocorrect: false,
        maxLines: 1,
        inputFormatters: [
          FilteringTextInputFormatter.deny(InputValidator.disallowedTextPattern),
          LengthLimitingTextInputFormatter(InputValidator.maxSearchLength),
        ],
        onTapOutside: (_) => _focusNode.unfocus(),
        onChanged: widget.onChanged,
        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
            color: mutedColor,
          ),
          prefixIcon: Icon(
            FluentIcons.search_20_regular,
            size: 19,
            color: mutedColor,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 48,
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 48,
                  minHeight: 48,
                ),
                icon: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: mutedColor,
                ),
                tooltip: widget.clearTooltip,
                onPressed: _handleClear,
              );
            },
          ),
        ),
      ),
    );
  }
}
