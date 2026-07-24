import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

class FaqEntry {
  final String question;
  final String answer;

  const FaqEntry(this.question, this.answer);
}

/// One grouped FAQ section (PROJECT.md Phase 5) — a plain, non-tappable
/// section label followed by an accordion card. Only one question in this
/// section can be expanded at a time: tapping a collapsed question expands
/// it and collapses whichever one was open, tapping the open question
/// collapses it.
class FaqSection extends StatefulWidget {
  final String title;
  final List<FaqEntry> entries;

  const FaqSection({super.key, required this.title, required this.entries});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                for (var i = 0; i < widget.entries.length; i++) ...[
                  _FaqItem(
                    entry: widget.entries[i],
                    isExpanded: _expandedIndex == i,
                    onTap: () => setState(() {
                      _expandedIndex = _expandedIndex == i ? null : i;
                    }),
                  ),
                  if (i != widget.entries.length - 1)
                    const Divider(height: 1, indent: 18, endIndent: 18),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FaqItem extends StatelessWidget {
  final FaqEntry entry;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqItem({required this.entry, required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    entry.question,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    LucideIcons.chevronDown,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.topCenter,
              child: isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        entry.answer,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
