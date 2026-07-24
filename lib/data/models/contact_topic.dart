/// The Contact form's 5 topic options (PROJECT.md Phase 5). Selecting one
/// doesn't route anywhere yet — no backend exists — but the field is
/// structured so a real routing map is a one-line addition once it does,
/// e.g.:
///   withdrawalIssue           -> payments team
///   referralCommissionMissing -> payments team (referral ledger)
///   adNotCredited              -> tasks/ads team
///   accountAccess              -> account/security team
///   somethingElse               -> general support queue
enum ContactTopic {
  accountAccess('Account access'),
  withdrawalIssue('Withdrawal issue'),
  adNotCredited('Ad not credited'),
  referralCommissionMissing('Referral commission missing'),
  somethingElse('Something else');

  final String label;

  const ContactTopic(this.label);
}
