import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';

/// One entry in a [LegalScreen]'s table of contents.
class LegalTocEntry {
  final String id;
  final String label;

  const LegalTocEntry({required this.id, required this.label});
}

/// One numbered section of a [LegalScreen] — [body] is a `Widget` rather
/// than a plain string so most sections can use [LegalSection.text] for
/// simple paragraphs while a section needing something else (e.g. a
/// `PendingLegalCard` placeholder) can still supply arbitrary content.
class LegalSection {
  final String id;
  final String heading;
  final Widget body;

  const LegalSection({
    required this.id,
    required this.heading,
    required this.body,
  });

  /// Convenience for the common case — one or more plain paragraphs.
  factory LegalSection.text({
    required String id,
    required String heading,
    required List<String> paragraphs,
  }) {
    return LegalSection(
      id: id,
      heading: heading,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < paragraphs.length; i++) ...[
            Text(
              paragraphs[i],
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
            if (i != paragraphs.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

/// Shared template for Terms, Privacy, and Refund (PROJECT.md 6.2/6.3) —
/// title, last-updated date, a tappable table of contents that scrolls to
/// the matching section, and a list of numbered sections. Plain text and
/// numbered headings, no cards — this is legal copy, not a marketing
/// screen, so it deliberately doesn't borrow the app's card/shadow
/// language. No AdMob slot on any screen built with this (PROJECT.md
/// pattern for trust/legal pages).
class LegalScreen extends StatefulWidget {
  final String title;
  final DateTime lastUpdated;
  final List<LegalTocEntry> tableOfContents;
  final List<LegalSection> sections;

  const LegalScreen({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.tableOfContents,
    required this.sections,
  });

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  late final Map<String, GlobalKey> _sectionKeys = {
    for (final section in widget.sections) section.id: GlobalKey(),
  };

  void _scrollToSection(String id) {
    final sectionContext = _sectionKeys[id]?.currentContext;
    if (sectionContext == null) return;
    Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMMM yyyy');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(widget.title),
      ),
      body: SafeArea(
        top: false,
        // A plain Column, not ListView — a lazily-mounted sliver child's
        // GlobalKey.currentContext is null until it scrolls into the
        // viewport's cache extent, which silently breaks deep-linking to
        // a section anchor that starts off-screen (see Settings screen,
        // PROJECT.md Phase 4). A Column mounts every section immediately
        // so the table of contents' Scrollable.ensureVisible always has a
        // real context to scroll to, even for the last section.
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last updated: ${dateFormat.format(widget.lastUpdated)}',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.textSecondary.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contents',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    for (var i = 0; i < widget.tableOfContents.length; i++)
                      InkWell(
                        onTap: () =>
                            _scrollToSection(widget.tableOfContents[i].id),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${i + 1}. ${widget.tableOfContents[i].label}',
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              for (var i = 0; i < widget.sections.length; i++) ...[
                Column(
                  key: _sectionKeys[widget.sections[i].id],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${i + 1}. ${widget.sections[i].heading}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    widget.sections[i].body,
                  ],
                ),
                if (i != widget.sections.length - 1) const SizedBox(height: 26),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
