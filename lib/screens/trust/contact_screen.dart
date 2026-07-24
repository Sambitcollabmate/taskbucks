import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/contact_topic.dart';
import '../../shared/widgets/gradient_cta_button.dart';
import '../auth/widgets/auth_text_field.dart';
import 'widgets/contact_channels_card.dart';
import 'widgets/topic_dropdown.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Trust page (PROJECT.md Phase 5) — reachable from Welcome and Profile,
/// same as `/how-it-works`, `/about`, and `/faq`. No AdMob slot — trust/
/// legal pages don't carry ads (PROJECT.md pattern).
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
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

  void _onSend() {
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
      const SnackBar(content: Text("Message sent — we'll reply within 24 hours.")),
    );

    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    setState(() => _topic = ContactTopic.values.first);
  }

  @override
  Widget build(BuildContext context) {
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
            const Text(
              "Have a question or ran into an issue? Send us a message and "
              "we'll get back to you within 24 hours.",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _nameController,
              label: 'Name',
              hintText: 'Your name',
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _emailController,
              label: 'Email',
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
              hintText: 'Tell us what happened...',
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            GradientCtaButton(label: 'Send message', onTap: _onSend),
            const SizedBox(height: 28),
            const ContactChannelsCard(),
          ],
        ),
      ),
    );
  }
}
