import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';

const int otpLength = 6;

/// 6-box OTP input — one digit per box, numeric keyboard only, auto-advances
/// focus to the next box as each digit is typed, and calls [onCompleted]
/// once all 6 boxes are filled (no separate "Verify" tap required). Reused
/// in Verify Phone and Forgot Password (PROJECT.md 6.3).
///
/// [hasError] highlights all 6 boxes red without clearing them (wrong-code
/// state) — call [OtpRowState.clear] explicitly via a [GlobalKey] when the
/// caller actually wants the boxes emptied (e.g. on resend).
class OtpRow extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool hasError;

  const OtpRow({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.hasError = false,
  });

  @override
  State<OtpRow> createState() => OtpRowState();
}

class OtpRowState extends State<OtpRow> {
  final List<TextEditingController> _controllers =
      List.generate(otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(otpLength, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// The digits typed so far (shorter than [otpLength] until complete).
  String get code => _controllers.map((c) => c.text).join();

  /// Empties all 6 boxes and refocuses the first one. Deliberately not
  /// called on a wrong-code error — only a real reset (e.g. resend) should
  /// clear digits the user already typed.
  void clear() {
    for (final controller in _controllers) {
      controller.clear();
    }
    setState(() {});
    _focusNodes.first.requestFocus();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isNotEmpty) {
      _focusNodes[index].unfocus();
    }
    setState(() {});
    widget.onChanged?.call(code);
    if (code.length == otpLength) {
      widget.onCompleted(code);
    }
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isNotEmpty || index == 0) return;
    _focusNodes[index - 1].requestFocus();
    _controllers[index - 1].clear();
    setState(() {});
    widget.onChanged?.call(code);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        widget.hasError ? AppColors.danger : AppColors.textSecondary.withValues(alpha: 0.25);
    final fillColor =
        widget.hasError ? AppColors.danger.withValues(alpha: 0.06) : AppColors.cardBackground;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(otpLength, (index) {
        return SizedBox(
          width: 46,
          height: 56,
          child: KeyboardListener(
            focusNode: _focusNodes[index],
            onKeyEvent: (event) {
              if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
                _onBackspace(index);
              }
            },
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: fillColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: widget.hasError ? AppColors.danger : AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (value) => _onDigitChanged(index, value),
            ),
          ),
        );
      }),
    );
  }
}
