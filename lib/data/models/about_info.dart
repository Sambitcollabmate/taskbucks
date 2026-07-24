/// Data-driven fields for the About screen's intro copy and stat chips
/// (PROJECT.md Phase 5) — never hardcode these numbers directly in a widget.
class AboutInfo {
  final int foundingYear;
  final int earnerCount;
  final int statesCovered;

  const AboutInfo({
    required this.foundingYear,
    required this.earnerCount,
    required this.statesCovered,
  });
}
