import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/support_ticket.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/support_provider.dart';
import 'ticket_status_pill.dart';

/// Ticket detail view as a real chat-bubble thread (design doc: "chat-bubble
/// thread, not a plain reply list") — user messages right-aligned in the
/// primary colour, support replies left-aligned and neutral, with the
/// support agent's name shown so "a human reads every ticket" has visible
/// evidence in the product, not just a claim elsewhere in the app. A reply
/// field at the bottom lets the user continue the conversation instead of
/// this being a one-shot message + one-shot reply.
class TicketDetailSheet extends StatefulWidget {
  final String ticketId;

  const TicketDetailSheet({super.key, required this.ticketId});

  @override
  State<TicketDetailSheet> createState() => _TicketDetailSheetState();
}

class _TicketDetailSheetState extends State<TicketDetailSheet> {
  final _replyController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _replyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _onSend(SupportProvider provider) async {
    final text = _replyController.text.trim();
    if (text.isEmpty || provider.isSendingReply) return;

    _replyController.clear();
    await provider.sendReply(widget.ticketId, text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupportProvider>(
      builder: (context, provider, _) {
        final l10n = AppLocalizations.of(context);
        final ticket = provider.ticketById(widget.ticketId);

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${ticket.id} — ${ticket.topic.label}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TicketStatusPill(status: ticket.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.supportReplyTimeNotice,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: ticket.messages.length,
                    itemBuilder: (context, index) => _ChatBubble(message: ticket.messages[index]),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _replyController,
                        decoration: InputDecoration(
                          hintText: l10n.typeAReply,
                          hintStyle: const TextStyle(color: AppColors.textSecondary),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _onSend(provider),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: AppColors.primary,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => _onSend(provider),
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: provider.isSendingReply
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final TicketMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat('d MMM, h:mm a');
    final isUser = message.isFromUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser && message.authorName != null) ...[
              Text(
                l10n.supportAuthorLabel(message.authorName!),
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              message.text,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: isUser ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateFormat.format(message.timestamp),
              style: TextStyle(
                fontSize: 10.5,
                color: isUser
                    ? Colors.white.withValues(alpha: 0.7)
                    : AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
