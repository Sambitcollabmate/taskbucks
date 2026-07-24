import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/contact_topic.dart';
import '../../data/models/user_profile.dart';
import '../../providers/profile_provider.dart';
import '../../shared/widgets/gradient_cta_button.dart';
import '../auth/widgets/auth_text_field.dart';
import 'widgets/contact_channels_card.dart';
import 'widgets/topic_dropdown.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Trust page (PROJECT.md Phase 5) — reachable from Welcome and Profile,
/// same as `/how-it-works`, `/about`, and `/faq`. No AdMob slot — trust/
/// legal pages don't carry ads (PROJECT.md pattern).
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: const _ContactScreenBody(),
    );
  }
}

class _ContactScreenBody extends StatefulWidget {
  const _ContactScreenBody();

  @override
  State<_ContactScreenBody> createState() => _ContactScreenBodyState();
}

class _ContactScreenBodyState extends State<_ContactScreenBody> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  ContactTopic _topic = ContactTopic.values.first;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Premium members get a faster stated reply time — a real, differentiated
  /// "Priority support" benefit (see `PremiumChecklistCard`), not just a
  /// marketing claim with nothing behind it.
  String _responseTimeRange(bool isPremium) => isPremium ? '12–24 hours' : '24–48 hours';

  void _onSend(bool isPremium) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || !_emailPattern.hasMatch(email) || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fill in your name, a valid email, and a message.'),
        ),
      );
      return;
    }

    // TODO: POST to a real Laravel /support/tickets endpoint once it exists
    // (PROJECT.md Phase 7). _topic tags which internal queue this should
    // route to — see ContactTopic's doc comment for the intended mapping.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Message sent — we'll reply within ${_responseTimeRange(isPremium)}.",
        ),
      ),
    );

    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    setState(() => _topic = ContactTopic.values.first);
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<ProfileProvider>().profile?.tier == UserTier.premium;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Contact us'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            Text(
              'Every ticket is read and answered within '
              '${_responseTimeRange(isPremium)}${isPremium ? ' — Premium priority' : ''}.',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _nameController,
              label: 'Full name',
              hintText: 'Your name',
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _emailController,
              label: 'Email address',
              hintText: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
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
              hintText: "Tell us what's going on...",
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            GradientCtaButton(
              label: 'Send message',
              onTap: () => _onSend(isPremium),
            ),
            const SizedBox(height: 28),
            ContactChannelsCard(responseTimeRange: _responseTimeRange(isPremium)),
          ],
        ),
      ),
    );
  }
}
