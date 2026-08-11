import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/contact_topic.dart';
import '../../data/models/user_profile.dart';
import '../../data/services/support_service.dart';
import '../../data/services/token_store.dart';
import '../../l10n/app_localizations.dart';
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
    // ProfileProvider is a shared app-wide instance (main.dart) — see
    // ProfileScreen's doc comment. Pre-auth visitors just see a null
    // profile here, which reads as "not Premium," the correct default.
    return const _ContactScreenBody();
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
  final _supportService = SupportService();

  ContactTopic _topic = ContactTopic.values.first;
  bool _isSending = false;

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
  String _responseTimeRange(AppLocalizations l10n, bool isPremium) =>
      isPremium ? l10n.responseTimePremium : l10n.responseTimeStandard;

  Future<void> _onSend(AppLocalizations l10n, bool isPremium) async {
    if (_isSending) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || !_emailPattern.hasMatch(email) || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.fillContactFormNotice),
        ),
      );
      return;
    }

    // Contact is reachable both pre- and post-auth (_publicPaths in
    // app_router.dart), but the real /support/tickets endpoint is
    // auth:sanctum-only — check locally instead of letting a guest's
    // submit fail with an opaque 401.
    if (TokenStore.instance.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.signInToSendMessage)),
      );
      return;
    }

    setState(() => _isSending = true);
    try {
      await _supportService.raiseTicket(topic: _topic, message: message);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.messageSentNotice(_responseTimeRange(l10n, isPremium)),
          ),
        ),
      );
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
      setState(() => _topic = ContactTopic.values.first);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPremium = context.watch<ProfileProvider>().profile?.tier == UserTier.premium;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(l10n.contactUsTitle),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            Text(
              l10n.everyTicketAnswered(
                _responseTimeRange(l10n, isPremium),
                isPremium ? l10n.premiumPrioritySuffix : '',
              ),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _nameController,
              label: l10n.fullNameLabel,
              hintText: l10n.fullNameHint,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _emailController,
              label: l10n.emailAddressLabel,
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
              label: l10n.messageLabel,
              hintText: l10n.contactMessageHint,
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            GradientCtaButton(
              label: _isSending ? l10n.submittingLabel : l10n.sendMessageButton,
              onTap: () => _onSend(l10n, isPremium),
            ),
            const SizedBox(height: 28),
            ContactChannelsCard(responseTimeRange: _responseTimeRange(l10n, isPremium)),
          ],
        ),
      ),
    );
  }
}
