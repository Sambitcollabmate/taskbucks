import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.twoStepVerification,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.extraCodeAtLogin,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.confirmYourPassword),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.turnOffTwoStepExplainer,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.passwordLabel,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancelLabel),
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
              child: Text(
                l10n.turnOff,
                style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700),
              ),
            );
          },
        ),
      ],
    );
  }
}
