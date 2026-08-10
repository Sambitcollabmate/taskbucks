// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get heroTagline => 'Simple daily earning, made for India';

  @override
  String get heroHeadline => 'Watch 25 ads a day. Get paid every month.';

  @override
  String get heroDescription =>
      'Open the app, tap a task, watch one short video ad, earn ₹100. Do it 25 times a day and cash out monthly straight to UPI — no surveys, no complicated offers.';

  @override
  String get seePaymentProofs => 'See real payment proofs';

  @override
  String get createFreeAccount => 'Create free account';

  @override
  String get logIn => 'Log in';

  @override
  String get legalAndSupport => 'Legal & support';

  @override
  String get loginTitle => 'Log in to your account';

  @override
  String get loginSubtitle => 'Welcome back — enter your details to continue.';

  @override
  String get mobileOrEmailLabel => 'Mobile number or email';

  @override
  String get mobileOrEmailHint => '98765 43210 or you@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Your password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String newToApp(String brandName) {
    return 'New to $brandName? ';
  }

  @override
  String get createAccountLink => 'Create a free account';

  @override
  String get registerTitle => 'Start earning in under a minute';

  @override
  String get registerSubtitle => 'Free forever. No card required.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameHint => 'Your name';

  @override
  String get mobileNumberLabel => 'Mobile number';

  @override
  String get otpHint => 'We\'ll send a 6-digit OTP to verify this number.';

  @override
  String get emailOptionalLabel => 'Email (optional)';

  @override
  String get passwordHintChars => 'At least 8 characters';

  @override
  String get referralCodeOptionalLabel => 'Referral code (optional)';

  @override
  String get referralCodeHint => 'e.g. SAMBIT482';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get couldNotSendOtp => 'Could not send OTP right now.';

  @override
  String get otpDidNotMatch => 'That code didn\'t match.';

  @override
  String get couldNotResendOtp => 'Could not resend OTP right now.';

  @override
  String get passwordUpdatedLoginMessage =>
      'Password updated. Log in with your new password.';

  @override
  String get resetPasswordTitle => 'Reset your password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your mobile number and we\'ll send a 6-digit OTP to reset your password.';

  @override
  String get didntGetOtp =>
      'Didn\'t get it? Check that your number can receive SMS, or wait a few minutes and try again.';

  @override
  String get remembered => 'Remembered it? ';

  @override
  String get backToLogin => 'Back to log in';

  @override
  String get verifyAndReset => 'Verify & reset';

  @override
  String verifyResetSubtitle(String maskedPhone) {
    return 'Enter the 6-digit code sent to +91 $maskedPhone, then choose a new password.';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Re-enter new password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get updatePassword => 'Update password';

  @override
  String get consentPrefix => 'I\'m 18+ and agree to the ';

  @override
  String get termsLabel => 'Terms';

  @override
  String get consentAnd => ' and ';

  @override
  String get privacyPolicyLabel => 'Privacy Policy';

  @override
  String get consentSuffix => '';

  @override
  String get aboutUs => 'About us';

  @override
  String get faq => 'FAQ';

  @override
  String get contact => 'Contact';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get refundPolicy => 'Refund Policy';

  @override
  String get tasksPerDayLabel => 'Tasks/day';

  @override
  String get earnersLabel => 'Earners';

  @override
  String get monthlyValue => 'Monthly';

  @override
  String get payoutLabel => 'Payout';

  @override
  String get sslSecured => 'SSL secured';

  @override
  String get yearsPaying => '7 yrs paying';

  @override
  String get upiBankPill => 'UPI · Bank';

  @override
  String get howItWorks => 'How it works';

  @override
  String get stepTapTask => 'Tap a task — 25 available every day';

  @override
  String get stepWatchAd => 'Watch the video ad — non-skippable, ~20–30 sec';

  @override
  String get stepGetCredited => 'Get credited — instantly after each ad';

  @override
  String get stepWithdraw =>
      'Withdraw monthly — once a month, on the 1st, to UPI or bank';

  @override
  String get walletLabel => 'Wallet';

  @override
  String get referAndEarnLabel => 'Refer & earn';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get thisWeek => 'This week';

  @override
  String get dailyTaskStreak => 'Your daily task streak';

  @override
  String get dayLetters => 'S,M,T,W,T,F,S';

  @override
  String get todaysTasks => 'Today\'s tasks';

  @override
  String get capReachedMessage =>
      'You\'ve hit today\'s cap. Come back tomorrow!';

  @override
  String moreToReachLimit(int count) {
    return '$count more to reach your daily limit';
  }

  @override
  String get capReached => 'Cap reached';

  @override
  String get watchVideoToEarn => 'Watch a video to earn';

  @override
  String get topReferrer => 'Top referrer';

  @override
  String get topAdWatcher => 'Top ad-watcher';

  @override
  String get thisWeeksLeaders => 'This week\'s leaders';

  @override
  String get weeklyBonusFootnote =>
      'Top referrer & top ad-watcher each get a bonus gift every week.';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get adNoticeMessage =>
      'Each task plays one short video ad. The ad cannot be skipped or minimized — stay on screen until it finishes to get credited.';

  @override
  String get completedLabel => 'Completed';

  @override
  String get earnedTodayLabel => 'Earned today';

  @override
  String taskOfDay(int id) {
    return 'Task $id of the day';
  }

  @override
  String watchAndEarn(String amount) {
    return 'Watch a video, earn $amount';
  }

  @override
  String get watchNow => 'Watch Now';

  @override
  String allBonusSlotsWatched(int count) {
    return 'All $count bonus slots watched this week 🎉';
  }

  @override
  String bonusSlotsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bonus ad slots left this week',
      one: '1 bonus ad slot left this week',
    );
    return '$_temp0';
  }

  @override
  String get bonusAdsFootnote =>
      'From last week\'s referral bonus. Watch any time before the week resets.';

  @override
  String get bonusAdsTitle => 'Bonus ads';

  @override
  String watchedOfTotal(int watched, int total) {
    return '$watched of $total watched';
  }

  @override
  String get noBonusSlots => 'No bonus ad slots this week';

  @override
  String get noBonusSlotsExplainer =>
      'Get 5 Premium referrals to convert in the same week and you\'ll unlock 5 bonus ad slots the week after.';

  @override
  String get lockedLabel => 'Locked';

  @override
  String resetsIn(int hours, int minutes, int seconds) {
    return 'Resets in ${hours}h ${minutes}m ${seconds}s';
  }

  @override
  String get walletTitle => 'Wallet';

  @override
  String get withdrawLabel => 'Withdraw';

  @override
  String get historyLabel => 'History';

  @override
  String withdrawalWindowNotice(int days) {
    return 'Withdrawals are processed once a month, on the 1st. Next window opens in $days days.';
  }

  @override
  String get paymentMethodTitle => 'Payment method';

  @override
  String get addUpiNotice => 'Add a UPI ID in Settings to receive payouts.';

  @override
  String get recentActivityTitle => 'Recent activity';

  @override
  String get balanceBreakdown => 'Balance breakdown';

  @override
  String get taskAdEarnings => 'Task (video ad) earnings';

  @override
  String get referralEarnings => 'Referral earnings';

  @override
  String get bonusRewards => 'Bonus rewards';

  @override
  String get defaultBadge => 'DEFAULT';

  @override
  String get availableBalance => 'Available balance';

  @override
  String todayAtTime(String time) {
    return 'Today, $time';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get referAndEarnTitle => 'Refer & earn';

  @override
  String get referralCommissionNotice =>
      'You earn ₹125 only when someone you refer completes the ₹49 Premium purchase, not just for signing up. It shows as pending until their payment clears.';

  @override
  String get recentReferralsTitle => 'Recent referrals';

  @override
  String get referredLabel => 'Referred';

  @override
  String get convertedLabel => 'Converted';

  @override
  String get earnedLabel => 'Earned';

  @override
  String get referralLinkCopied => 'Referral link copied';

  @override
  String get referralCodeCopied => 'Referral code copied';

  @override
  String shareReferralMessage(String brandName, String link) {
    return 'Join me on $brandName and start earning! Use my link: $link';
  }

  @override
  String get yourReferralCode => 'Your referral code';

  @override
  String get copyLink => 'Copy link';

  @override
  String get shareLabel => 'Share';

  @override
  String get pendingLabel => 'Pending';

  @override
  String get thisWeeksTopReferrers => 'This week\'s top referrers';

  @override
  String conversionsCount(int count) {
    return '$count conversions';
  }

  @override
  String get topReferrerBonusFootnote =>
      'Top referrer this week wins a bonus gift.';

  @override
  String get weeklyReferralBonusTitle => 'Weekly referral bonus';

  @override
  String get weeklyBonusLockedExplainer =>
      'Get 5 Premium referrals converting in the same week and you\'ll earn +5 bonus ad slots the week after, but this perk is Premium-only. Upgrade to start qualifying.';

  @override
  String get upgradeToPremiumArrow => 'Upgrade to Premium →';

  @override
  String bonusSlotsActiveMessage(int count) {
    return '🎉 $count bonus ad slots are active this week. Head to Tasks to watch them, in any order, any time before the week ends.';
  }

  @override
  String weeklyBonusProgress(
    int converted,
    int threshold,
    int remaining,
    int slots,
  ) {
    return '$converted of $threshold Premium referrals converted this week. Get $remaining more to convert this same week for +$slots bonus ad slots next week.';
  }

  @override
  String get enterValidAmount => 'Enter a valid withdrawal amount.';

  @override
  String get cannotExceedBalance =>
      'You can\'t withdraw more than your available balance.';

  @override
  String withdrawalRequestedMessage(String date) {
    return 'Withdrawal requested — queued for the $date payout cycle.';
  }

  @override
  String get withdrawTitle => 'Withdraw';

  @override
  String withdrawWindowNotice(int days) {
    return 'Withdrawals are processed once a month, on the 1st. This month\'s window opens in $days days — your request will queue until then, not transfer right away.';
  }

  @override
  String get amountLabel => 'Amount';

  @override
  String get enterAmountHint => 'Enter amount';

  @override
  String get payoutMethodLabel => 'Payout method';

  @override
  String get upiMethodLabel => 'UPI (Google Pay / PhonePe / Paytm)';

  @override
  String get addUpiBeforeWithdrawNotice =>
      'Add a UPI ID in Settings before requesting a withdrawal.';

  @override
  String get recentUpiCapNotice =>
      'This UPI ID was added in the last 24 hours, so withdrawals to it are capped at ₹5,000 during that window. If a transfer fails for that reason, it may auto-retry once the 24 hours pass.';

  @override
  String get queuingLabel => 'Queuing...';

  @override
  String queueWithdrawalFor(String date) {
    return 'Queue withdrawal for $date';
  }

  @override
  String get firstTimeWithdrawalNotice =>
      'First-time withdrawals may need manual verification.';

  @override
  String get appLanguageLabel => 'App language';

  @override
  String get termsAndPrivacy => 'Terms & Privacy';

  @override
  String get profileTitle => 'Profile';

  @override
  String get accountLabel => 'Account';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get securityAndPassword => 'Security & password';

  @override
  String get paymentDetails => 'Payment details';

  @override
  String get manageSubscription => 'Manage subscription';

  @override
  String get supportLabel => 'Support';

  @override
  String get notificationsLabel => 'Notifications';

  @override
  String get supportTickets => 'Support tickets';

  @override
  String get contactUs => 'Contact us';

  @override
  String get paymentProofs => 'Payment proofs';

  @override
  String get logOut => 'Log out';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get freeBadge => 'Free';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get profilePhotoRemoved => 'Profile photo removed';

  @override
  String get profilePhotoUpdated => 'Profile photo updated';

  @override
  String get fullNameSettingsLabel => 'Full name';

  @override
  String get emailAddressLabel => 'Email address';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get securityTitle => 'Security';

  @override
  String get currentPasswordLabel => 'Current password';

  @override
  String get currentPasswordHint => 'Your current password';

  @override
  String get passwordUpdatedShort => 'Password updated';

  @override
  String get twoStepOn => 'Two-step verification turned on';

  @override
  String get twoStepOff => 'Two-step verification turned off';

  @override
  String get paymentDetailsTitle => 'Payment details';

  @override
  String get upiIdUpdated => 'UPI ID updated';

  @override
  String get bankAccountLabel => 'Bank account';

  @override
  String get pushNotificationsTitle => 'Push notifications';

  @override
  String get earningsPushTitle => 'Earnings';

  @override
  String get earningsPushSubtitle => 'Task credits, referrals, streak bonuses';

  @override
  String get accountPushTitle => 'Account';

  @override
  String get accountPushSubtitle => 'Security alerts, like new-device logins';

  @override
  String get promotionsPushTitle => 'Promotions';

  @override
  String get promotionsPushSubtitle =>
      'Occasional offers, like Premium discounts';

  @override
  String get cropPhoto => 'Crop photo';

  @override
  String get takeAPhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get twoStepVerification => 'Two-step verification';

  @override
  String get extraCodeAtLogin => 'Extra code at login';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get turnOffTwoStepExplainer =>
      'Turning off two-step verification reduces your account security. Enter your password to confirm.';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get turnOff => 'Turn off';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get defaultLabelLower => 'Default';

  @override
  String get upiIdHint => 'yourname@bank';

  @override
  String get upiIdValidationError =>
      'Enter a valid UPI ID, e.g. yourname@okhdfcbank.';

  @override
  String get saveUpiId => 'Save UPI ID';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotificationsHere => 'No notifications here';

  @override
  String get allFilterLabel => 'All';

  @override
  String allFilterLabelWithCount(int count) {
    return 'All ($count)';
  }

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get noTransactionsYet => 'No transactions yet';

  @override
  String get tasksFilterLabel => 'Tasks';

  @override
  String get referralsFilterLabel => 'Referrals';

  @override
  String get withdrawalsFilterLabel => 'Withdrawals';

  @override
  String get newTicket => '+ New ticket';

  @override
  String get supportReplyTimeNotice =>
      'We read and reply to every ticket within 24–48 hours.';

  @override
  String get noOpenTickets => 'No open tickets';

  @override
  String get noClosedTickets => 'No closed tickets';

  @override
  String openWithCount(int count) {
    return 'Open ($count)';
  }

  @override
  String closedWithCount(int count) {
    return 'Closed ($count)';
  }

  @override
  String get ticketStatusOpen => 'Open';

  @override
  String get ticketStatusReply => 'Reply';

  @override
  String get ticketStatusClosed => 'Closed';

  @override
  String get describeIssueFirst => 'Describe your issue before submitting.';

  @override
  String get raiseNewTicket => 'Raise a new ticket';

  @override
  String get messageLabel => 'Message';

  @override
  String get tellUsWhatHappened => 'Tell us what happened...';

  @override
  String get submittingLabel => 'Submitting...';

  @override
  String get submitTicket => 'Submit ticket';

  @override
  String get typeAReply => 'Type a reply...';

  @override
  String supportAuthorLabel(String authorName) {
    return 'Support ($authorName)';
  }

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutHeadline =>
      'Built by people who got burned by earning apps that never paid.';

  @override
  String aboutBody(int foundingYear) {
    return 'EarnBucks started in $foundingYear as a reaction to an industry full of apps that vanish when users ask to withdraw.';
  }

  @override
  String get companyDetailsTitle => 'Company details';

  @override
  String get legalEntityNameField => 'Legal entity name';

  @override
  String get registrationNumberField => 'Registration number';

  @override
  String get registeredAddressField => 'Registered address';

  @override
  String get companyDetailsPendingNote =>
      'Pending legal confirmation — do not invent a name, number, or address here.';

  @override
  String get seePaymentProofsButton => 'See payment proofs';

  @override
  String get foundedLabel => 'Founded';

  @override
  String get statesLabel => 'States';

  @override
  String get fourCommitments => 'Four commitments';

  @override
  String get commitmentTransparencyTitle => 'Transparency';

  @override
  String get commitmentTransparencyBody =>
      'Every payout is published publicly — see real, verified withdrawals on our Payment Proofs page, not just a promise.';

  @override
  String get commitmentNoPayToJoinTitle => 'No pay-to-join';

  @override
  String get commitmentNoPayToJoinBody =>
      'Signing up is free, forever. Never a fee to earn or withdraw — no deposits, no hidden charges.';

  @override
  String get commitmentFairRatesTitle => 'Fair rates';

  @override
  String get commitmentFairRatesBody =>
      'The exact ₹ rate for a task is shown before you start it — no surprise deductions, no rate changes without notice.';

  @override
  String get commitmentRealSupportTitle => 'Real support';

  @override
  String get commitmentRealSupportBody =>
      'A human reads every support ticket — not a bot loop, you always get a real reply.';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get faqSectionTasks => 'Tasks & earning';

  @override
  String get faqSectionPayments => 'Payments';

  @override
  String get faqSectionReferrals => 'Referrals & Premium';

  @override
  String get contactSupportButton => 'Contact support';

  @override
  String get faqQ1 => 'Why only 25 tasks a day?';

  @override
  String get faqA1 =>
      'A fixed daily set keeps payouts predictable and sustainable for everyone. Premium members get 30/day, at the same ₹/task rate.';

  @override
  String get faqQ2 => 'How much does each task pay?';

  @override
  String get faqA2 =>
      '₹100 per task — complete all 25 and earn up to ₹2,500 a day.';

  @override
  String get faqQ3 => 'When do my daily tasks reset?';

  @override
  String get faqA3 =>
      'At midnight, every day. Whatever\'s left of today\'s cap disappears — there\'s no rollover.';

  @override
  String get faqQ4 => 'Why can\'t I skip the ad?';

  @override
  String get faqA4 =>
      'Your reward is funded by the advertiser paying for a full view — skipping early means no reward can be credited. Credit only fires once the ad finishes playing to the end, not on tap or open.';

  @override
  String get faqQ5 => 'Can I get more tasks by using multiple accounts?';

  @override
  String get faqA5 =>
      'No — each phone number gets one account, and using multiple accounts is against our terms.';

  @override
  String get faqQ6 => 'When do I get paid?';

  @override
  String get faqA6 =>
      'Withdrawals are processed once a month, on the 1st, straight to your UPI ID or a verified bank account (IMPS transfer).';

  @override
  String get faqQ7 => 'Can I withdraw whenever I want?';

  @override
  String get faqA7 =>
      'Not right now — payouts are monthly only, there\'s no on-demand withdrawal.';

  @override
  String get faqQ8 => 'Which payment methods do you support?';

  @override
  String get faqA8 =>
      'UPI (Google Pay, PhonePe, Paytm) and verified bank account transfer only — no PayPal, no wallets, no other payout methods.';

  @override
  String get faqQ9 => 'What if I have the wrong UPI ID saved?';

  @override
  String get faqA9 =>
      'Payouts go to whatever\'s saved in Settings, so double-check it before the 1st — a typo means a delayed payout while our team helps you fix it.';

  @override
  String get faqQ10 => 'How much do I earn per referral?';

  @override
  String get faqA10 =>
      '₹125 flat, credited only when the person you referred completes the ₹49 Premium purchase — never for signing up alone.';

  @override
  String get faqQ11 => 'Why is my referral still showing as \"pending\"?';

  @override
  String get faqA11 =>
      'It stays pending until your referral\'s Premium payment clears. Once it does, the ₹125 credits automatically.';

  @override
  String get faqQ12 => 'What does Premium include?';

  @override
  String get faqA12 =>
      '30 tasks/day instead of 25, at the same ₹/task rate — never a smaller cut per task.';

  @override
  String get faqQ13 => 'Can I cancel Premium anytime?';

  @override
  String get faqA13 =>
      'Yes, from Profile → Manage subscription. Your benefits continue until the end of the paid cycle, even after you cancel.';

  @override
  String get faqQ14 =>
      'What happens if my referral\'s Premium purchase is refunded?';

  @override
  String get faqA14 =>
      'The ₹125 commission is reversed — deducted from your balance, even from a future payout if it\'s already been paid out.';

  @override
  String get faqQ15 => 'What is the weekly referral bonus?';

  @override
  String get faqA15 =>
      'Premium members who get 5 or more referrals converting to Premium within the same Sunday–Saturday week earn +5 bonus ad slots, active the following week. It\'s gated on you holding Premium yourself. Free-tier accounts still earn the ₹125 commission, just never this bonus.';

  @override
  String get faqQ16 =>
      'Does it matter when my referral signed up, or when they went Premium?';

  @override
  String get faqA16 =>
      'Only the week their Premium purchase lands counts toward your 5. Signup timing doesn\'t matter, and each week is judged on its own. If 4 convert one week and a 5th converts the next, neither week reaches 5 and no bonus fires for either.';

  @override
  String get fillContactFormNotice =>
      'Fill in your name, a valid email, and a message.';

  @override
  String messageSentNotice(String range) {
    return 'Message sent — we\'ll reply within $range.';
  }

  @override
  String get contactUsTitle => 'Contact us';

  @override
  String everyTicketAnswered(String range, String premiumSuffix) {
    return 'Every ticket is read and answered within $range$premiumSuffix.';
  }

  @override
  String get premiumPrioritySuffix => ' — Premium priority';

  @override
  String get contactMessageHint => 'Tell us what\'s going on...';

  @override
  String get sendMessageButton => 'Send message';

  @override
  String get responseTimePremium => '12–24 hours';

  @override
  String get responseTimeStandard => '24–48 hours';

  @override
  String get otherWaysToReachUs => 'Other ways to reach us';

  @override
  String get supportChannelLabel => 'Support';

  @override
  String get paymentsChannelLabel => 'Payments';

  @override
  String weUsuallyReplyWithin(String range) {
    return 'We usually reply within $range.';
  }

  @override
  String noEmailAppFound(String email) {
    return 'No email app found for $email';
  }

  @override
  String get topicLabel => 'Topic';

  @override
  String get topicAccountAccess => 'Account access';

  @override
  String get topicWithdrawalIssue => 'Withdrawal issue';

  @override
  String get topicAdNotCredited => 'Ad not credited';

  @override
  String get topicReferralCommissionMissing => 'Referral commission missing';

  @override
  String get topicSomethingElse => 'Something else';

  @override
  String get howItWorksTitle => 'How it works';

  @override
  String get howItWorksIntro =>
      'One earning method, kept simple. No offer walls, no surveys, no confusing task types — just short video ads, up to 25 a day.';

  @override
  String get wantMore => 'Want more?';

  @override
  String get referAndEarnInfoTitle => 'Refer & earn';

  @override
  String get referAndEarnInfoMessage =>
      'Share your referral link. You earn ₹125 only when the person you referred actually completes the ₹49 Premium purchase, not just for signing up. Earnings show as \"pending\" until their payment clears, and are reversed if their payment is refunded.';

  @override
  String get goPremiumInfoTitle => 'Go Premium';

  @override
  String get goPremiumBullet1 => '30 tasks/day, up from Free\'s 25';

  @override
  String get goPremiumBullet2 =>
      'Same ₹/task rate — no reduced payout per task';

  @override
  String get goPremiumBullet3 =>
      'Billed monthly — cancel anytime from Settings, benefits continue until the end of the paid cycle';

  @override
  String get weeklyBonusInfoTitle => 'Weekly referral bonus';

  @override
  String get weeklyBonusInfoMessage =>
      'Premium members who get 5 or more referrals converting to Premium in the same Sunday–Saturday week earn +5 bonus ad slots, active the following week. The week that counts is when your referral\'s purchase lands, not when they signed up. Each week resets clean with no partial carryover.';

  @override
  String get stepCreateAccountTitle => 'Create your free account';

  @override
  String get stepCreateAccountBody =>
      'Sign up with your mobile number in under a minute — no fees to join.';

  @override
  String get stepOpenTasksTitle => 'Open today\'s tasks';

  @override
  String get stepOpenTasksBody =>
      '25 tasks reset daily at midnight (30 on the Premium plan).';

  @override
  String get stepWatchAdTitle => 'Watch the video ad';

  @override
  String get stepWatchAdBody =>
      'Each task plays one short, non-skippable video ad — stay on screen until it finishes.';

  @override
  String get stepGetPaidTitle => 'Get paid monthly';

  @override
  String get stepGetPaidBody =>
      'All earnings are paid out once a month, on the 1st, to UPI or bank transfer.';

  @override
  String get paymentProofsTitle => 'Payment Proofs';

  @override
  String get paymentProofsIntro =>
      'Every withdrawal appears here automatically. Nothing is hand-picked.';

  @override
  String get lastCycleLabel => 'Last cycle';

  @override
  String get totalEarnersLabel => 'Total earners';

  @override
  String get paidBadge => 'PAID';

  @override
  String get sampleDataNotLive => 'Sample data — not live';

  @override
  String get sampleDataExplainer =>
      'Every amount, name, and date on this screen is illustrative, not a real payout. This banner stays until this screen is wired to real transaction records.';

  @override
  String lastUpdatedOn(String date) {
    return 'Last updated: $date';
  }

  @override
  String get contentsLabel => 'Contents';

  @override
  String get nowPremiumMessage => 'You\'re now Premium!';

  @override
  String get subscriptionCancelledMessage =>
      'Subscription cancelled — benefits continue until the cycle ends.';

  @override
  String get upgradeTitle => 'Upgrade';

  @override
  String get goPremiumTitle => 'Go Premium';

  @override
  String get unlockExtraTasksSubtitle => 'Unlock 5 extra tasks every day.';

  @override
  String cancellationScheduled(String date) {
    return 'Cancellation scheduled. Benefits continue until $date.';
  }

  @override
  String get endOfThisCycle => 'the end of this cycle';

  @override
  String get youreOnPremium => 'You\'re on Premium.';

  @override
  String get cancelSubscription => 'Cancel subscription';

  @override
  String get subscribePriceButton => 'Subscribe — ₹49/month';

  @override
  String get billedMonthlyNotice =>
      'Billed monthly via Google Play. Cancel anytime from Profile → Manage subscription — Premium benefits continue until the end of the paid cycle.';

  @override
  String get referralCommissionOnUpgradeNotice =>
      'If you were referred by someone, completing this purchase credits their ₹125 referral commission, it\'s never credited on signup alone. See Refund Policy for subscription cancellation terms.';

  @override
  String get weeklyBonusUnlockNotice =>
      'Premium also unlocks the weekly referral bonus: get 5+ referrals converting to Premium in the same week and earn +5 bonus ad slots the week after.';

  @override
  String get perMonthSuffix => ' /month';

  @override
  String get cancelAnytimeNoContract =>
      'Cancel anytime — no long-term contract';

  @override
  String get proBadge => 'PRO';

  @override
  String get whatYouGet => 'What you get';

  @override
  String get prioritySupportBullet =>
      'Priority support — faster reply on tickets';

  @override
  String get homeLabel => 'Home';

  @override
  String get referLabel => 'Refer';

  @override
  String get goPremiumBannerTitle => 'Go Premium ';

  @override
  String get goPremiumBannerPrice => '— ₹49/month';

  @override
  String get unlock30TasksSubtitle => 'Unlock 30 tasks/day at the same rate';

  @override
  String get dontLoseStreakTitle => 'Don\'t lose today\'s streak';

  @override
  String get notificationRationale =>
      'We\'ll let you know when you\'re close to missing today\'s task cap, and when a task or referral is credited — nothing more.';

  @override
  String get turnOnNotifications => 'Turn on notifications';

  @override
  String get notNow => 'Not now';

  @override
  String get oneMoreStep => 'One more step';

  @override
  String get verifyYourPhone => 'Verify your phone number';

  @override
  String sendingCodeMessage(String maskedPhone) {
    return 'Sending a 6-digit code by SMS to +91 $maskedPhone…';
  }

  @override
  String sentCodeMessage(String maskedPhone) {
    return 'We\'ve sent a 6-digit code by SMS to +91 $maskedPhone.';
  }

  @override
  String get tryAgain => 'Try again';

  @override
  String resendOtpInCountdown(String seconds) {
    return 'Didn\'t get the code? Resend OTP in 0:$seconds';
  }

  @override
  String get verifyAndContinue => 'Verify & continue';

  @override
  String get changeMobileNumber => 'Change mobile number';

  @override
  String get smsDndNotice =>
      'Make sure your number can receive SMS — some DND (Do Not Disturb) settings block OTP messages. Code expires in 10 minutes.';

  @override
  String get otpCodeMismatchRetry =>
      'That code didn\'t match. Check and try again.';

  @override
  String get otpCodeExpired => 'This code has expired — request a new one.';

  @override
  String get otpTooManyAttempts =>
      'Too many attempts. You\'re temporarily locked out for 5 minutes.';

  @override
  String couldNotVerifyRightNow(String error) {
    return 'Couldn\'t verify that code right now. ($error)';
  }

  @override
  String couldNotSendOtpWithError(String error) {
    return 'Could not send OTP right now. ($error)';
  }

  @override
  String couldNotResendOtpWithError(String error) {
    return 'Could not resend OTP right now. ($error)';
  }
}
