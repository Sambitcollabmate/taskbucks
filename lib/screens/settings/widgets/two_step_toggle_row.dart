import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Turning two-step verification ON is a single tap — turning it OFF asks
/// for a password confirm first. Disabling a security feature should have
/// more friction than enabling one, not the same amount.
class TwoStepToggleRow extends StatelessWidget {
  final bool value;
  final bool isSaving;
  final ValueChanged<bool> onChanged;

  const TwoStepToggleRow({
    super.key,
    required this.value,
    required this.isSaving,
    required this.onChanged,
  });

  Future<void> _handleChange(BuildContext context, bool next) async {
    if (next) {
      onChanged(true);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const _ReauthDialog(),
    );
    if (confirmed ?? false) onChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Two-step verification',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Adds an OTP check on top of your password when logging in.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Switch(
                value: value,
                activeThumbColor: AppColors.primary,
                onChanged: (next) => _handleChange(context, next),
              ),
      ],
    );
  }
}

/// Owns its own [TextEditingController] via normal State lifecycle, rather
/// than a controller created/disposed around `showDialog`'s await — that
/// pattern disposes the controller as soon as `Navigator.pop` resolves the
/// future, which races the dialog's still-running exit transition (the
/// TextField is still mounted mid-fade-out) and throws "used after being
/// disposed". A dedicated State disposes it exactly when its Element
/// actually unmounts instead.
class _ReauthDialog extends StatefulWidget {
  const _ReauthDialog();

  @override
  State<_ReauthDialog> createState() => _ReauthDialogState();
}

class _ReauthDialogState extends State<_ReauthDialog> {
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm your password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Turning off two-step verification reduces your account '
            'security. Enter your password to confirm.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _passwordController,
          builder: (context, value, _) {
            return TextButton(
              // Real flow verifies this against the account password/an
              // OTP step (TODO: wire once auth API exists, PROJECT.md 4)
              // — for now any non-empty entry confirms, since there's no
              // backend to check it against yet.
              onPressed: value.text.isEmpty
                  ? null
                  : () => Navigator.of(context).pop(true),
              child: const Text(
                'Turn off',
                style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700),
              ),
            );
          },
        ),
      ],
    );
  }
}
