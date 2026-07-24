import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/contact_topic.dart';
import '../../../providers/support_provider.dart';
import '../../../shared/widgets/gradient_cta_button.dart';
import '../../auth/widgets/auth_text_field.dart';
import '../../trust/widgets/topic_dropdown.dart';

/// "Raise a new ticket" form — reuses Contact's `TopicDropdown` (same 5
/// topics, PROJECT.md Phase 5) plus a message field. On submit, calls
/// [SupportProvider.raiseTicket] and pops itself; the new ticket appears at
/// the top of the list with Open status since that's what the provider
/// prepends.
class RaiseTicketSheet extends StatefulWidget {
  final SupportProvider provider;

  const RaiseTicketSheet({super.key, required this.provider});

  @override
  State<RaiseTicketSheet> createState() => _RaiseTicketSheetState();
}

class _RaiseTicketSheetState extends State<RaiseTicketSheet> {
  final _messageController = TextEditingController();
  ContactTopic _topic = ContactTopic.values.first;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (widget.provider.isSubmitting) return;

    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Describe your issue before submitting.')),
      );
      return;
    }

    await widget.provider.raiseTicket(topic: _topic, message: message);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Raise a new ticket',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TopicDropdown(
              value: _topic,
              onChanged: (topic) => setState(() => _topic = topic),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _messageController,
              label: 'Message',
              hintText: 'Tell us what happened...',
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: widget.provider,
              builder: (context, _) {
                return GradientCtaButton(
                  label: widget.provider.isSubmitting ? 'Submitting...' : 'Submit ticket',
                  onTap: _onSubmit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
