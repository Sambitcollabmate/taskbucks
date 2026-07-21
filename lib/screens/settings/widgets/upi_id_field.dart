import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

/// `name@bankhandle` — the standard UPI VPA shape. Validated on every
/// keystroke (not just on save): PROJECT.md flags a UPI typo caught only
/// at withdrawal time as a much worse failure moment than one caught here.
final upiIdPattern = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');

/// Editable UPI ID field with a "Default" pill and live format validation.
/// Errors show as soon as the field is non-empty and doesn't match — no
/// waiting for a save/submit attempt.
class UpiIdField extends StatefulWidget {
  final String initialValue;
  final bool isDefault;
  final bool isSaving;
  final ValueChanged<String> onSave;

  const UpiIdField({
    super.key,
    required this.initialValue,
    required this.isDefault,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<UpiIdField> createState() => _UpiIdFieldState();
}

class _UpiIdFieldState extends State<UpiIdField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isValid => upiIdPattern.hasMatch(_controller.text);
  bool get _isEmpty => _controller.text.isEmpty;
  bool get _hasChanged => _controller.text != widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final showError = !_isEmpty && !_isValid;
    final borderColor = showError
        ? AppColors.danger
        : (!_isEmpty && _isValid)
        ? AppColors.earningsGreen
        : AppColors.textSecondary.withValues(alpha: 0.25);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'UPI ID',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (widget.isDefault) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.earningsGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.earningsGreen,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          key: const Key('upi_id_field'),
          controller: _controller,
          autocorrect: false,
          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'yourname@bank',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            suffixIcon: _isEmpty
                ? null
                : Icon(
                    _isValid ? LucideIcons.circleCheck : LucideIcons.circleAlert,
                    size: 18,
                    color: _isValid ? AppColors.earningsGreen : AppColors.danger,
                  ),
            filled: true,
            fillColor: AppColors.cardBackground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
          ),
        ),
        if (showError) ...[
          const SizedBox(height: 6),
          const Text(
            'Enter a valid UPI ID, e.g. yourname@okhdfcbank.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.danger,
            ),
          ),
        ],
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: (_isValid && _hasChanged && !widget.isSaving)
                ? () => widget.onSave(_controller.text)
                : null,
            child: widget.isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Save UPI ID',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ],
    );
  }
}
