import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @heroTagline.
  ///
  /// In en, this message translates to:
  /// **'Simple daily earning, made for India'**
  String get heroTagline;

  /// No description provided for @heroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Watch 25 ads a day. Get paid every month.'**
  String get heroHeadline;

  /// No description provided for @heroDescription.
  ///
  /// In en, this message translates to:
  /// **'Open the app, tap a task, watch one short video ad, earn ₹100. Do it 25 times a day and cash out monthly straight to UPI — no surveys, no complicated offers.'**
  String get heroDescription;

  /// No description provided for @seePaymentProofs.
  ///
  /// In en, this message translates to:
  /// **'See real payment proofs'**
  String get seePaymentProofs;

  /// No description provided for @createFreeAccount.
  ///
  /// In en, this message translates to:
  /// **'Create free account'**
  String get createFreeAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @legalAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Legal & support'**
  String get legalAndSupport;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to your account'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back — enter your details to continue.'**
  String get loginSubtitle;

  /// No description provided for @mobileOrEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number or email'**
  String get mobileOrEmailLabel;

  /// No description provided for @mobileOrEmailHint.
  ///
  /// In en, this message translates to:
  /// **'98765 43210 or you@example.com'**
  String get mobileOrEmailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get passwordHint;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @newToApp.
  ///
  /// In en, this message translates to:
  /// **'New to {brandName}? '**
  String newToApp(String brandName);

  /// No description provided for @createAccountLink.
  ///
  /// In en, this message translates to:
  /// **'Create a free account'**
  String get createAccountLink;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Start earning in under a minute'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Free forever. No card required.'**
  String get registerSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get fullNameHint;

  /// No description provided for @mobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumberLabel;

  /// No description provided for @otpHint.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a 6-digit OTP to verify this number.'**
  String get otpHint;

  /// No description provided for @emailOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptionalLabel;

  /// No description provided for @passwordHintChars.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordHintChars;

  /// No description provided for @referralCodeOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Referral code (optional)'**
  String get referralCodeOptionalLabel;

  /// No description provided for @referralCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. SAMBIT482'**
  String get referralCodeHint;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @couldNotSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Could not send OTP right now.'**
  String get couldNotSendOtp;

  /// No description provided for @otpDidNotMatch.
  ///
  /// In en, this message translates to:
  /// **'That code didn\'t match.'**
  String get otpDidNotMatch;

  /// No description provided for @couldNotResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Could not resend OTP right now.'**
  String get couldNotResendOtp;

  /// No description provided for @passwordUpdatedLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'Password updated. Log in with your new password.'**
  String get passwordUpdatedLoginMessage;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number and we\'ll send a 6-digit OTP to reset your password.'**
  String get resetPasswordSubtitle;

  /// No description provided for @didntGetOtp.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get it? Check that your number can receive SMS, or wait a few minutes and try again.'**
  String get didntGetOtp;

  /// No description provided for @remembered.
  ///
  /// In en, this message translates to:
  /// **'Remembered it? '**
  String get remembered;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to log in'**
  String get backToLogin;

  /// No description provided for @verifyAndReset.
  ///
  /// In en, this message translates to:
  /// **'Verify & reset'**
  String get verifyAndReset;

  /// No description provided for @verifyResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to +91 {maskedPhone}, then choose a new password.'**
  String verifyResetSubtitle(String maskedPhone);

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get confirmPasswordHint;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updatePassword;

  /// No description provided for @consentPrefix.
  ///
  /// In en, this message translates to:
  /// **'I\'m 18+ and agree to the '**
  String get consentPrefix;

  /// No description provided for @termsLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get termsLabel;

  /// No description provided for @consentAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get consentAnd;

  /// No description provided for @privacyPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLabel;

  /// No description provided for @consentSuffix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get consentSuffix;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @refundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get refundPolicy;

  /// No description provided for @tasksPerDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Tasks/day'**
  String get tasksPerDayLabel;

  /// No description provided for @earnersLabel.
  ///
  /// In en, this message translates to:
  /// **'Earners'**
  String get earnersLabel;

  /// No description provided for @monthlyValue.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyValue;

  /// No description provided for @payoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get payoutLabel;

  /// No description provided for @sslSecured.
  ///
  /// In en, this message translates to:
  /// **'SSL secured'**
  String get sslSecured;

  /// No description provided for @yearsPaying.
  ///
  /// In en, this message translates to:
  /// **'7 yrs paying'**
  String get yearsPaying;

  /// No description provided for @upiBankPill.
  ///
  /// In en, this message translates to:
  /// **'UPI · Bank'**
  String get upiBankPill;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @stepTapTask.
  ///
  /// In en, this message translates to:
  /// **'Tap a task — 25 available every day'**
  String get stepTapTask;

  /// No description provided for @stepWatchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch the video ad — non-skippable, ~20–30 sec'**
  String get stepWatchAd;

  /// No description provided for @stepGetCredited.
  ///
  /// In en, this message translates to:
  /// **'Get credited — instantly after each ad'**
  String get stepGetCredited;

  /// No description provided for @stepWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw monthly — once a month, on the 1st, to UPI or bank'**
  String get stepWithdraw;

  /// No description provided for @walletLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletLabel;

  /// No description provided for @referAndEarnLabel.
  ///
  /// In en, this message translates to:
  /// **'Refer & earn'**
  String get referAndEarnLabel;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @dailyTaskStreak.
  ///
  /// In en, this message translates to:
  /// **'Your daily task streak'**
  String get dailyTaskStreak;

  /// No description provided for @dayLetters.
  ///
  /// In en, this message translates to:
  /// **'S,M,T,W,T,F,S'**
  String get dayLetters;

  /// No description provided for @todaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tasks'**
  String get todaysTasks;

  /// No description provided for @capReachedMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve hit today\'s cap. Come back tomorrow!'**
  String get capReachedMessage;

  /// No description provided for @moreToReachLimit.
  ///
  /// In en, this message translates to:
  /// **'{count} more to reach your daily limit'**
  String moreToReachLimit(int count);

  /// No description provided for @capReached.
  ///
  /// In en, this message translates to:
  /// **'Cap reached'**
  String get capReached;

  /// No description provided for @watchVideoToEarn.
  ///
  /// In en, this message translates to:
  /// **'Watch a video to earn'**
  String get watchVideoToEarn;

  /// No description provided for @topReferrer.
  ///
  /// In en, this message translates to:
  /// **'Top referrer'**
  String get topReferrer;

  /// No description provided for @topAdWatcher.
  ///
  /// In en, this message translates to:
  /// **'Top ad-watcher'**
  String get topAdWatcher;

  /// No description provided for @thisWeeksLeaders.
  ///
  /// In en, this message translates to:
  /// **'This week\'s leaders'**
  String get thisWeeksLeaders;

  /// No description provided for @weeklyBonusFootnote.
  ///
  /// In en, this message translates to:
  /// **'Top referrer & top ad-watcher each get a bonus gift every week.'**
  String get weeklyBonusFootnote;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTitle;

  /// No description provided for @adNoticeMessage.
  ///
  /// In en, this message translates to:
  /// **'Each task plays one short video ad. The ad cannot be skipped or minimized — stay on screen until it finishes to get credited.'**
  String get adNoticeMessage;

  /// No description provided for @completedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedLabel;

  /// No description provided for @earnedTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Earned today'**
  String get earnedTodayLabel;

  /// No description provided for @taskOfDay.
  ///
  /// In en, this message translates to:
  /// **'Task {id} of the day'**
  String taskOfDay(int id);

  /// No description provided for @watchAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Watch a video, earn {amount}'**
  String watchAndEarn(String amount);

  /// No description provided for @watchNow.
  ///
  /// In en, this message translates to:
  /// **'Watch Now'**
  String get watchNow;

  /// No description provided for @allBonusSlotsWatched.
  ///
  /// In en, this message translates to:
  /// **'All {count} bonus slots watched this week 🎉'**
  String allBonusSlotsWatched(int count);

  /// No description provided for @bonusSlotsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 bonus ad slot left this week} other{{count} bonus ad slots left this week}}'**
  String bonusSlotsLeft(int count);

  /// No description provided for @bonusAdsFootnote.
  ///
  /// In en, this message translates to:
  /// **'From last week\'s referral bonus. Watch any time before the week resets.'**
  String get bonusAdsFootnote;

  /// No description provided for @bonusAdsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bonus ads'**
  String get bonusAdsTitle;

  /// No description provided for @watchedOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{watched} of {total} watched'**
  String watchedOfTotal(int watched, int total);

  /// No description provided for @noBonusSlots.
  ///
  /// In en, this message translates to:
  /// **'No bonus ad slots this week'**
  String get noBonusSlots;

  /// No description provided for @noBonusSlotsExplainer.
  ///
  /// In en, this message translates to:
  /// **'Get 5 Premium referrals to convert in the same week and you\'ll unlock 5 bonus ad slots the week after.'**
  String get noBonusSlotsExplainer;

  /// No description provided for @lockedLabel.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get lockedLabel;

  /// No description provided for @resetsIn.
  ///
  /// In en, this message translates to:
  /// **'Resets in {hours}h {minutes}m {seconds}s'**
  String resetsIn(int hours, int minutes, int seconds);

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// No description provided for @withdrawLabel.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdrawLabel;

  /// No description provided for @historyLabel.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyLabel;

  /// No description provided for @withdrawalWindowNotice.
  ///
  /// In en, this message translates to:
  /// **'Withdrawals are processed once a month, on the 1st. Next window opens in {days} days.'**
  String withdrawalWindowNotice(int days);

  /// No description provided for @paymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethodTitle;

  /// No description provided for @addUpiNotice.
  ///
  /// In en, this message translates to:
  /// **'Add a UPI ID in Settings to receive payouts.'**
  String get addUpiNotice;

  /// No description provided for @recentActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivityTitle;

  /// No description provided for @balanceBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Balance breakdown'**
  String get balanceBreakdown;

  /// No description provided for @taskAdEarnings.
  ///
  /// In en, this message translates to:
  /// **'Task (video ad) earnings'**
  String get taskAdEarnings;

  /// No description provided for @referralEarnings.
  ///
  /// In en, this message translates to:
  /// **'Referral earnings'**
  String get referralEarnings;

  /// No description provided for @bonusRewards.
  ///
  /// In en, this message translates to:
  /// **'Bonus rewards'**
  String get bonusRewards;

  /// No description provided for @defaultBadge.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT'**
  String get defaultBadge;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get availableBalance;

  /// No description provided for @todayAtTime.
  ///
  /// In en, this message translates to:
  /// **'Today, {time}'**
  String todayAtTime(String time);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// No description provided for @referAndEarnTitle.
  ///
  /// In en, this message translates to:
  /// **'Refer & earn'**
  String get referAndEarnTitle;

  /// No description provided for @referralCommissionNotice.
  ///
  /// In en, this message translates to:
  /// **'You earn ₹125 only when someone you refer completes the ₹49 Premium purchase, not just for signing up. It shows as pending until their payment clears.'**
  String get referralCommissionNotice;

  /// No description provided for @recentReferralsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent referrals'**
  String get recentReferralsTitle;

  /// No description provided for @referredLabel.
  ///
  /// In en, this message translates to:
  /// **'Referred'**
  String get referredLabel;

  /// No description provided for @convertedLabel.
  ///
  /// In en, this message translates to:
  /// **'Converted'**
  String get convertedLabel;

  /// No description provided for @earnedLabel.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earnedLabel;

  /// No description provided for @referralLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Referral link copied'**
  String get referralLinkCopied;

  /// No description provided for @referralCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Referral code copied'**
  String get referralCodeCopied;

  /// No description provided for @shareReferralMessage.
  ///
  /// In en, this message translates to:
  /// **'Join me on {brandName} and start earning! Use my link: {link}'**
  String shareReferralMessage(String brandName, String link);

  /// No description provided for @yourReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Your referral code'**
  String get yourReferralCode;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @shareLabel.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareLabel;

  /// No description provided for @pendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingLabel;

  /// No description provided for @thisWeeksTopReferrers.
  ///
  /// In en, this message translates to:
  /// **'This week\'s top referrers'**
  String get thisWeeksTopReferrers;

  /// No description provided for @conversionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} conversions'**
  String conversionsCount(int count);

  /// No description provided for @topReferrerBonusFootnote.
  ///
  /// In en, this message translates to:
  /// **'Top referrer this week wins a bonus gift.'**
  String get topReferrerBonusFootnote;

  /// No description provided for @weeklyReferralBonusTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly referral bonus'**
  String get weeklyReferralBonusTitle;

  /// No description provided for @weeklyBonusLockedExplainer.
  ///
  /// In en, this message translates to:
  /// **'Get 5 Premium referrals converting in the same week and you\'ll earn +5 bonus ad slots the week after, but this perk is Premium-only. Upgrade to start qualifying.'**
  String get weeklyBonusLockedExplainer;

  /// No description provided for @upgradeToPremiumArrow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium →'**
  String get upgradeToPremiumArrow;

  /// No description provided for @bonusSlotsActiveMessage.
  ///
  /// In en, this message translates to:
  /// **'🎉 {count} bonus ad slots are active this week. Head to Tasks to watch them, in any order, any time before the week ends.'**
  String bonusSlotsActiveMessage(int count);

  /// No description provided for @weeklyBonusProgress.
  ///
  /// In en, this message translates to:
  /// **'{converted} of {threshold} Premium referrals converted this week. Get {remaining} more to convert this same week for +{slots} bonus ad slots next week.'**
  String weeklyBonusProgress(
    int converted,
    int threshold,
    int remaining,
    int slots,
  );

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid withdrawal amount.'**
  String get enterValidAmount;

  /// No description provided for @cannotExceedBalance.
  ///
  /// In en, this message translates to:
  /// **'You can\'t withdraw more than your available balance.'**
  String get cannotExceedBalance;

  /// No description provided for @withdrawalRequestedMessage.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal requested — queued for the {date} payout cycle.'**
  String withdrawalRequestedMessage(String date);

  /// No description provided for @withdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdrawTitle;

  /// No description provided for @withdrawWindowNotice.
  ///
  /// In en, this message translates to:
  /// **'Withdrawals are processed once a month, on the 1st. This month\'s window opens in {days} days — your request will queue until then, not transfer right away.'**
  String withdrawWindowNotice(int days);

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @enterAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmountHint;

  /// No description provided for @payoutMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payout method'**
  String get payoutMethodLabel;

  /// No description provided for @upiMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'UPI (Google Pay / PhonePe / Paytm)'**
  String get upiMethodLabel;

  /// No description provided for @addUpiBeforeWithdrawNotice.
  ///
  /// In en, this message translates to:
  /// **'Add a UPI ID in Settings before requesting a withdrawal.'**
  String get addUpiBeforeWithdrawNotice;

  /// No description provided for @recentUpiCapNotice.
  ///
  /// In en, this message translates to:
  /// **'This UPI ID was added in the last 24 hours, so withdrawals to it are capped at ₹5,000 during that window. If a transfer fails for that reason, it may auto-retry once the 24 hours pass.'**
  String get recentUpiCapNotice;

  /// No description provided for @queuingLabel.
  ///
  /// In en, this message translates to:
  /// **'Queuing...'**
  String get queuingLabel;

  /// No description provided for @queueWithdrawalFor.
  ///
  /// In en, this message translates to:
  /// **'Queue withdrawal for {date}'**
  String queueWithdrawalFor(String date);

  /// No description provided for @firstTimeWithdrawalNotice.
  ///
  /// In en, this message translates to:
  /// **'First-time withdrawals may need manual verification.'**
  String get firstTimeWithdrawalNotice;

  /// No description provided for @appLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguageLabel;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get termsAndPrivacy;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @accountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountLabel;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @securityAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Security & password'**
  String get securityAndPassword;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment details'**
  String get paymentDetails;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get manageSubscription;

  /// No description provided for @supportLabel.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportLabel;

  /// No description provided for @notificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsLabel;

  /// No description provided for @supportTickets.
  ///
  /// In en, this message translates to:
  /// **'Support tickets'**
  String get supportTickets;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @paymentProofs.
  ///
  /// In en, this message translates to:
  /// **'Payment proofs'**
  String get paymentProofs;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @premiumBadge.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumBadge;

  /// No description provided for @freeBadge.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get freeBadge;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @profilePhotoRemoved.
  ///
  /// In en, this message translates to:
  /// **'Profile photo removed'**
  String get profilePhotoRemoved;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated'**
  String get profilePhotoUpdated;

  /// No description provided for @fullNameSettingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameSettingsLabel;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressLabel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securityTitle;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// No description provided for @currentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Your current password'**
  String get currentPasswordHint;

  /// No description provided for @passwordUpdatedShort.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdatedShort;

  /// No description provided for @twoStepOn.
  ///
  /// In en, this message translates to:
  /// **'Two-step verification turned on'**
  String get twoStepOn;

  /// No description provided for @twoStepOff.
  ///
  /// In en, this message translates to:
  /// **'Two-step verification turned off'**
  String get twoStepOff;

  /// No description provided for @paymentDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment details'**
  String get paymentDetailsTitle;

  /// No description provided for @upiIdUpdated.
  ///
  /// In en, this message translates to:
  /// **'UPI ID updated'**
  String get upiIdUpdated;

  /// No description provided for @bankAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank account'**
  String get bankAccountLabel;

  /// No description provided for @pushNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get pushNotificationsTitle;

  /// No description provided for @earningsPushTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earningsPushTitle;

  /// No description provided for @earningsPushSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Task credits, referrals, streak bonuses'**
  String get earningsPushSubtitle;

  /// No description provided for @accountPushTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountPushTitle;

  /// No description provided for @accountPushSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Security alerts, like new-device logins'**
  String get accountPushSubtitle;

  /// No description provided for @promotionsPushTitle.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get promotionsPushTitle;

  /// No description provided for @promotionsPushSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Occasional offers, like Premium discounts'**
  String get promotionsPushSubtitle;

  /// No description provided for @cropPhoto.
  ///
  /// In en, this message translates to:
  /// **'Crop photo'**
  String get cropPhoto;

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takeAPhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @twoStepVerification.
  ///
  /// In en, this message translates to:
  /// **'Two-step verification'**
  String get twoStepVerification;

  /// No description provided for @extraCodeAtLogin.
  ///
  /// In en, this message translates to:
  /// **'Extra code at login'**
  String get extraCodeAtLogin;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @turnOffTwoStepExplainer.
  ///
  /// In en, this message translates to:
  /// **'Turning off two-step verification reduces your account security. Enter your password to confirm.'**
  String get turnOffTwoStepExplainer;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @turnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get turnOff;

  /// No description provided for @upiIdLabel.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upiIdLabel;

  /// No description provided for @defaultLabelLower.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabelLower;

  /// No description provided for @upiIdHint.
  ///
  /// In en, this message translates to:
  /// **'yourname@bank'**
  String get upiIdHint;

  /// No description provided for @upiIdValidationError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid UPI ID, e.g. yourname@okhdfcbank.'**
  String get upiIdValidationError;

  /// No description provided for @saveUpiId.
  ///
  /// In en, this message translates to:
  /// **'Save UPI ID'**
  String get saveUpiId;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotificationsHere.
  ///
  /// In en, this message translates to:
  /// **'No notifications here'**
  String get noNotificationsHere;

  /// No description provided for @allFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilterLabel;

  /// No description provided for @allFilterLabelWithCount.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String allFilterLabelWithCount(int count);

  /// No description provided for @transactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsTitle;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @tasksFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksFilterLabel;

  /// No description provided for @referralsFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Referrals'**
  String get referralsFilterLabel;

  /// No description provided for @withdrawalsFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Withdrawals'**
  String get withdrawalsFilterLabel;

  /// No description provided for @newTicket.
  ///
  /// In en, this message translates to:
  /// **'+ New ticket'**
  String get newTicket;

  /// No description provided for @supportReplyTimeNotice.
  ///
  /// In en, this message translates to:
  /// **'We read and reply to every ticket within 24–48 hours.'**
  String get supportReplyTimeNotice;

  /// No description provided for @noOpenTickets.
  ///
  /// In en, this message translates to:
  /// **'No open tickets'**
  String get noOpenTickets;

  /// No description provided for @noClosedTickets.
  ///
  /// In en, this message translates to:
  /// **'No closed tickets'**
  String get noClosedTickets;

  /// No description provided for @openWithCount.
  ///
  /// In en, this message translates to:
  /// **'Open ({count})'**
  String openWithCount(int count);

  /// No description provided for @closedWithCount.
  ///
  /// In en, this message translates to:
  /// **'Closed ({count})'**
  String closedWithCount(int count);

  /// No description provided for @ticketStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get ticketStatusOpen;

  /// No description provided for @ticketStatusReply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get ticketStatusReply;

  /// No description provided for @ticketStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get ticketStatusClosed;

  /// No description provided for @describeIssueFirst.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue before submitting.'**
  String get describeIssueFirst;

  /// No description provided for @raiseNewTicket.
  ///
  /// In en, this message translates to:
  /// **'Raise a new ticket'**
  String get raiseNewTicket;

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// No description provided for @tellUsWhatHappened.
  ///
  /// In en, this message translates to:
  /// **'Tell us what happened...'**
  String get tellUsWhatHappened;

  /// No description provided for @submittingLabel.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submittingLabel;

  /// No description provided for @submitTicket.
  ///
  /// In en, this message translates to:
  /// **'Submit ticket'**
  String get submitTicket;

  /// No description provided for @typeAReply.
  ///
  /// In en, this message translates to:
  /// **'Type a reply...'**
  String get typeAReply;

  /// No description provided for @supportAuthorLabel.
  ///
  /// In en, this message translates to:
  /// **'Support ({authorName})'**
  String supportAuthorLabel(String authorName);

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutHeadline.
  ///
  /// In en, this message translates to:
  /// **'Built by people who got burned by earning apps that never paid.'**
  String get aboutHeadline;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'EarnBucks started in {foundingYear} as a reaction to an industry full of apps that vanish when users ask to withdraw.'**
  String aboutBody(int foundingYear);

  /// No description provided for @companyDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Company details'**
  String get companyDetailsTitle;

  /// No description provided for @legalEntityNameField.
  ///
  /// In en, this message translates to:
  /// **'Legal entity name'**
  String get legalEntityNameField;

  /// No description provided for @registrationNumberField.
  ///
  /// In en, this message translates to:
  /// **'Registration number'**
  String get registrationNumberField;

  /// No description provided for @registeredAddressField.
  ///
  /// In en, this message translates to:
  /// **'Registered address'**
  String get registeredAddressField;

  /// No description provided for @companyDetailsPendingNote.
  ///
  /// In en, this message translates to:
  /// **'Pending legal confirmation — do not invent a name, number, or address here.'**
  String get companyDetailsPendingNote;

  /// No description provided for @seePaymentProofsButton.
  ///
  /// In en, this message translates to:
  /// **'See payment proofs'**
  String get seePaymentProofsButton;

  /// No description provided for @foundedLabel.
  ///
  /// In en, this message translates to:
  /// **'Founded'**
  String get foundedLabel;

  /// No description provided for @statesLabel.
  ///
  /// In en, this message translates to:
  /// **'States'**
  String get statesLabel;

  /// No description provided for @fourCommitments.
  ///
  /// In en, this message translates to:
  /// **'Four commitments'**
  String get fourCommitments;

  /// No description provided for @commitmentTransparencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Transparency'**
  String get commitmentTransparencyTitle;

  /// No description provided for @commitmentTransparencyBody.
  ///
  /// In en, this message translates to:
  /// **'Every payout is published publicly — see real, verified withdrawals on our Payment Proofs page, not just a promise.'**
  String get commitmentTransparencyBody;

  /// No description provided for @commitmentNoPayToJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'No pay-to-join'**
  String get commitmentNoPayToJoinTitle;

  /// No description provided for @commitmentNoPayToJoinBody.
  ///
  /// In en, this message translates to:
  /// **'Signing up is free, forever. Never a fee to earn or withdraw — no deposits, no hidden charges.'**
  String get commitmentNoPayToJoinBody;

  /// No description provided for @commitmentFairRatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fair rates'**
  String get commitmentFairRatesTitle;

  /// No description provided for @commitmentFairRatesBody.
  ///
  /// In en, this message translates to:
  /// **'The exact ₹ rate for a task is shown before you start it — no surprise deductions, no rate changes without notice.'**
  String get commitmentFairRatesBody;

  /// No description provided for @commitmentRealSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Real support'**
  String get commitmentRealSupportTitle;

  /// No description provided for @commitmentRealSupportBody.
  ///
  /// In en, this message translates to:
  /// **'A human reads every support ticket — not a bot loop, you always get a real reply.'**
  String get commitmentRealSupportBody;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faqTitle;

  /// No description provided for @faqSectionTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks & earning'**
  String get faqSectionTasks;

  /// No description provided for @faqSectionPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get faqSectionPayments;

  /// No description provided for @faqSectionReferrals.
  ///
  /// In en, this message translates to:
  /// **'Referrals & Premium'**
  String get faqSectionReferrals;

  /// No description provided for @contactSupportButton.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get contactSupportButton;

  /// No description provided for @faqQ1.
  ///
  /// In en, this message translates to:
  /// **'Why only 25 tasks a day?'**
  String get faqQ1;

  /// No description provided for @faqA1.
  ///
  /// In en, this message translates to:
  /// **'A fixed daily set keeps payouts predictable and sustainable for everyone. Premium members get 30/day, at the same ₹/task rate.'**
  String get faqA1;

  /// No description provided for @faqQ2.
  ///
  /// In en, this message translates to:
  /// **'How much does each task pay?'**
  String get faqQ2;

  /// No description provided for @faqA2.
  ///
  /// In en, this message translates to:
  /// **'₹100 per task — complete all 25 and earn up to ₹2,500 a day.'**
  String get faqA2;

  /// No description provided for @faqQ3.
  ///
  /// In en, this message translates to:
  /// **'When do my daily tasks reset?'**
  String get faqQ3;

  /// No description provided for @faqA3.
  ///
  /// In en, this message translates to:
  /// **'At midnight, every day. Whatever\'s left of today\'s cap disappears — there\'s no rollover.'**
  String get faqA3;

  /// No description provided for @faqQ4.
  ///
  /// In en, this message translates to:
  /// **'Why can\'t I skip the ad?'**
  String get faqQ4;

  /// No description provided for @faqA4.
  ///
  /// In en, this message translates to:
  /// **'Your reward is funded by the advertiser paying for a full view — skipping early means no reward can be credited. Credit only fires once the ad finishes playing to the end, not on tap or open.'**
  String get faqA4;

  /// No description provided for @faqQ5.
  ///
  /// In en, this message translates to:
  /// **'Can I get more tasks by using multiple accounts?'**
  String get faqQ5;

  /// No description provided for @faqA5.
  ///
  /// In en, this message translates to:
  /// **'No — each phone number gets one account, and using multiple accounts is against our terms.'**
  String get faqA5;

  /// No description provided for @faqQ6.
  ///
  /// In en, this message translates to:
  /// **'When do I get paid?'**
  String get faqQ6;

  /// No description provided for @faqA6.
  ///
  /// In en, this message translates to:
  /// **'Withdrawals are processed once a month, on the 1st, straight to your UPI ID or a verified bank account (IMPS transfer).'**
  String get faqA6;

  /// No description provided for @faqQ7.
  ///
  /// In en, this message translates to:
  /// **'Can I withdraw whenever I want?'**
  String get faqQ7;

  /// No description provided for @faqA7.
  ///
  /// In en, this message translates to:
  /// **'Not right now — payouts are monthly only, there\'s no on-demand withdrawal.'**
  String get faqA7;

  /// No description provided for @faqQ8.
  ///
  /// In en, this message translates to:
  /// **'Which payment methods do you support?'**
  String get faqQ8;

  /// No description provided for @faqA8.
  ///
  /// In en, this message translates to:
  /// **'UPI (Google Pay, PhonePe, Paytm) and verified bank account transfer only — no PayPal, no wallets, no other payout methods.'**
  String get faqA8;

  /// No description provided for @faqQ9.
  ///
  /// In en, this message translates to:
  /// **'What if I have the wrong UPI ID saved?'**
  String get faqQ9;

  /// No description provided for @faqA9.
  ///
  /// In en, this message translates to:
  /// **'Payouts go to whatever\'s saved in Settings, so double-check it before the 1st — a typo means a delayed payout while our team helps you fix it.'**
  String get faqA9;

  /// No description provided for @faqQ10.
  ///
  /// In en, this message translates to:
  /// **'How much do I earn per referral?'**
  String get faqQ10;

  /// No description provided for @faqA10.
  ///
  /// In en, this message translates to:
  /// **'₹125 flat, credited only when the person you referred completes the ₹49 Premium purchase — never for signing up alone.'**
  String get faqA10;

  /// No description provided for @faqQ11.
  ///
  /// In en, this message translates to:
  /// **'Why is my referral still showing as \"pending\"?'**
  String get faqQ11;

  /// No description provided for @faqA11.
  ///
  /// In en, this message translates to:
  /// **'It stays pending until your referral\'s Premium payment clears. Once it does, the ₹125 credits automatically.'**
  String get faqA11;

  /// No description provided for @faqQ12.
  ///
  /// In en, this message translates to:
  /// **'What does Premium include?'**
  String get faqQ12;

  /// No description provided for @faqA12.
  ///
  /// In en, this message translates to:
  /// **'30 tasks/day instead of 25, at the same ₹/task rate — never a smaller cut per task.'**
  String get faqA12;

  /// No description provided for @faqQ13.
  ///
  /// In en, this message translates to:
  /// **'Can I cancel Premium anytime?'**
  String get faqQ13;

  /// No description provided for @faqA13.
  ///
  /// In en, this message translates to:
  /// **'Yes, from Profile → Manage subscription. Your benefits continue until the end of the paid cycle, even after you cancel.'**
  String get faqA13;

  /// No description provided for @faqQ14.
  ///
  /// In en, this message translates to:
  /// **'What happens if my referral\'s Premium purchase is refunded?'**
  String get faqQ14;

  /// No description provided for @faqA14.
  ///
  /// In en, this message translates to:
  /// **'The ₹125 commission is reversed — deducted from your balance, even from a future payout if it\'s already been paid out.'**
  String get faqA14;

  /// No description provided for @faqQ15.
  ///
  /// In en, this message translates to:
  /// **'What is the weekly referral bonus?'**
  String get faqQ15;

  /// No description provided for @faqA15.
  ///
  /// In en, this message translates to:
  /// **'Premium members who get 5 or more referrals converting to Premium within the same Sunday–Saturday week earn +5 bonus ad slots, active the following week. It\'s gated on you holding Premium yourself. Free-tier accounts still earn the ₹125 commission, just never this bonus.'**
  String get faqA15;

  /// No description provided for @faqQ16.
  ///
  /// In en, this message translates to:
  /// **'Does it matter when my referral signed up, or when they went Premium?'**
  String get faqQ16;

  /// No description provided for @faqA16.
  ///
  /// In en, this message translates to:
  /// **'Only the week their Premium purchase lands counts toward your 5. Signup timing doesn\'t matter, and each week is judged on its own. If 4 convert one week and a 5th converts the next, neither week reaches 5 and no bonus fires for either.'**
  String get faqA16;

  /// No description provided for @fillContactFormNotice.
  ///
  /// In en, this message translates to:
  /// **'Fill in your name, a valid email, and a message.'**
  String get fillContactFormNotice;

  /// No description provided for @messageSentNotice.
  ///
  /// In en, this message translates to:
  /// **'Message sent — we\'ll reply within {range}.'**
  String messageSentNotice(String range);

  /// No description provided for @contactUsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUsTitle;

  /// No description provided for @everyTicketAnswered.
  ///
  /// In en, this message translates to:
  /// **'Every ticket is read and answered within {range}{premiumSuffix}.'**
  String everyTicketAnswered(String range, String premiumSuffix);

  /// No description provided for @premiumPrioritySuffix.
  ///
  /// In en, this message translates to:
  /// **' — Premium priority'**
  String get premiumPrioritySuffix;

  /// No description provided for @contactMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what\'s going on...'**
  String get contactMessageHint;

  /// No description provided for @sendMessageButton.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get sendMessageButton;

  /// No description provided for @responseTimePremium.
  ///
  /// In en, this message translates to:
  /// **'12–24 hours'**
  String get responseTimePremium;

  /// No description provided for @responseTimeStandard.
  ///
  /// In en, this message translates to:
  /// **'24–48 hours'**
  String get responseTimeStandard;

  /// No description provided for @otherWaysToReachUs.
  ///
  /// In en, this message translates to:
  /// **'Other ways to reach us'**
  String get otherWaysToReachUs;

  /// No description provided for @supportChannelLabel.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportChannelLabel;

  /// No description provided for @paymentsChannelLabel.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentsChannelLabel;

  /// No description provided for @weUsuallyReplyWithin.
  ///
  /// In en, this message translates to:
  /// **'We usually reply within {range}.'**
  String weUsuallyReplyWithin(String range);

  /// No description provided for @noEmailAppFound.
  ///
  /// In en, this message translates to:
  /// **'No email app found for {email}'**
  String noEmailAppFound(String email);

  /// No description provided for @topicLabel.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get topicLabel;

  /// No description provided for @topicAccountAccess.
  ///
  /// In en, this message translates to:
  /// **'Account access'**
  String get topicAccountAccess;

  /// No description provided for @topicWithdrawalIssue.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal issue'**
  String get topicWithdrawalIssue;

  /// No description provided for @topicAdNotCredited.
  ///
  /// In en, this message translates to:
  /// **'Ad not credited'**
  String get topicAdNotCredited;

  /// No description provided for @topicReferralCommissionMissing.
  ///
  /// In en, this message translates to:
  /// **'Referral commission missing'**
  String get topicReferralCommissionMissing;

  /// No description provided for @topicSomethingElse.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get topicSomethingElse;

  /// No description provided for @howItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorksTitle;

  /// No description provided for @howItWorksIntro.
  ///
  /// In en, this message translates to:
  /// **'One earning method, kept simple. No offer walls, no surveys, no confusing task types — just short video ads, up to 25 a day.'**
  String get howItWorksIntro;

  /// No description provided for @wantMore.
  ///
  /// In en, this message translates to:
  /// **'Want more?'**
  String get wantMore;

  /// No description provided for @referAndEarnInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Refer & earn'**
  String get referAndEarnInfoTitle;

  /// No description provided for @referAndEarnInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'Share your referral link. You earn ₹125 only when the person you referred actually completes the ₹49 Premium purchase, not just for signing up. Earnings show as \"pending\" until their payment clears, and are reversed if their payment is refunded.'**
  String get referAndEarnInfoMessage;

  /// No description provided for @goPremiumInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get goPremiumInfoTitle;

  /// No description provided for @goPremiumBullet1.
  ///
  /// In en, this message translates to:
  /// **'30 tasks/day, up from Free\'s 25'**
  String get goPremiumBullet1;

  /// No description provided for @goPremiumBullet2.
  ///
  /// In en, this message translates to:
  /// **'Same ₹/task rate — no reduced payout per task'**
  String get goPremiumBullet2;

  /// No description provided for @goPremiumBullet3.
  ///
  /// In en, this message translates to:
  /// **'Billed monthly — cancel anytime from Settings, benefits continue until the end of the paid cycle'**
  String get goPremiumBullet3;

  /// No description provided for @weeklyBonusInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly referral bonus'**
  String get weeklyBonusInfoTitle;

  /// No description provided for @weeklyBonusInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'Premium members who get 5 or more referrals converting to Premium in the same Sunday–Saturday week earn +5 bonus ad slots, active the following week. The week that counts is when your referral\'s purchase lands, not when they signed up. Each week resets clean with no partial carryover.'**
  String get weeklyBonusInfoMessage;

  /// No description provided for @stepCreateAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your free account'**
  String get stepCreateAccountTitle;

  /// No description provided for @stepCreateAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Sign up with your mobile number in under a minute — no fees to join.'**
  String get stepCreateAccountBody;

  /// No description provided for @stepOpenTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Open today\'s tasks'**
  String get stepOpenTasksTitle;

  /// No description provided for @stepOpenTasksBody.
  ///
  /// In en, this message translates to:
  /// **'25 tasks reset daily at midnight (30 on the Premium plan).'**
  String get stepOpenTasksBody;

  /// No description provided for @stepWatchAdTitle.
  ///
  /// In en, this message translates to:
  /// **'Watch the video ad'**
  String get stepWatchAdTitle;

  /// No description provided for @stepWatchAdBody.
  ///
  /// In en, this message translates to:
  /// **'Each task plays one short, non-skippable video ad — stay on screen until it finishes.'**
  String get stepWatchAdBody;

  /// No description provided for @stepGetPaidTitle.
  ///
  /// In en, this message translates to:
  /// **'Get paid monthly'**
  String get stepGetPaidTitle;

  /// No description provided for @stepGetPaidBody.
  ///
  /// In en, this message translates to:
  /// **'All earnings are paid out once a month, on the 1st, to UPI or bank transfer.'**
  String get stepGetPaidBody;

  /// No description provided for @paymentProofsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Proofs'**
  String get paymentProofsTitle;

  /// No description provided for @paymentProofsIntro.
  ///
  /// In en, this message translates to:
  /// **'Every withdrawal appears here automatically. Nothing is hand-picked.'**
  String get paymentProofsIntro;

  /// No description provided for @lastCycleLabel.
  ///
  /// In en, this message translates to:
  /// **'Last cycle'**
  String get lastCycleLabel;

  /// No description provided for @totalEarnersLabel.
  ///
  /// In en, this message translates to:
  /// **'Total earners'**
  String get totalEarnersLabel;

  /// No description provided for @paidBadge.
  ///
  /// In en, this message translates to:
  /// **'PAID'**
  String get paidBadge;

  /// No description provided for @sampleDataNotLive.
  ///
  /// In en, this message translates to:
  /// **'Sample data — not live'**
  String get sampleDataNotLive;

  /// No description provided for @sampleDataExplainer.
  ///
  /// In en, this message translates to:
  /// **'Every amount, name, and date on this screen is illustrative, not a real payout. This banner stays until this screen is wired to real transaction records.'**
  String get sampleDataExplainer;

  /// No description provided for @lastUpdatedOn.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdatedOn(String date);

  /// No description provided for @contentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get contentsLabel;

  /// No description provided for @nowPremiumMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re now Premium!'**
  String get nowPremiumMessage;

  /// No description provided for @subscriptionCancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled — benefits continue until the cycle ends.'**
  String get subscriptionCancelledMessage;

  /// No description provided for @upgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgradeTitle;

  /// No description provided for @goPremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get goPremiumTitle;

  /// No description provided for @unlockExtraTasksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock 5 extra tasks every day.'**
  String get unlockExtraTasksSubtitle;

  /// No description provided for @cancellationScheduled.
  ///
  /// In en, this message translates to:
  /// **'Cancellation scheduled. Benefits continue until {date}.'**
  String cancellationScheduled(String date);

  /// No description provided for @endOfThisCycle.
  ///
  /// In en, this message translates to:
  /// **'the end of this cycle'**
  String get endOfThisCycle;

  /// No description provided for @youreOnPremium.
  ///
  /// In en, this message translates to:
  /// **'You\'re on Premium.'**
  String get youreOnPremium;

  /// No description provided for @cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel subscription'**
  String get cancelSubscription;

  /// No description provided for @subscribePriceButton.
  ///
  /// In en, this message translates to:
  /// **'Subscribe — ₹49/month'**
  String get subscribePriceButton;

  /// No description provided for @billedMonthlyNotice.
  ///
  /// In en, this message translates to:
  /// **'Billed monthly via Google Play. Cancel anytime from Profile → Manage subscription — Premium benefits continue until the end of the paid cycle.'**
  String get billedMonthlyNotice;

  /// No description provided for @referralCommissionOnUpgradeNotice.
  ///
  /// In en, this message translates to:
  /// **'If you were referred by someone, completing this purchase credits their ₹125 referral commission, it\'s never credited on signup alone. See Refund Policy for subscription cancellation terms.'**
  String get referralCommissionOnUpgradeNotice;

  /// No description provided for @weeklyBonusUnlockNotice.
  ///
  /// In en, this message translates to:
  /// **'Premium also unlocks the weekly referral bonus: get 5+ referrals converting to Premium in the same week and earn +5 bonus ad slots the week after.'**
  String get weeklyBonusUnlockNotice;

  /// No description provided for @perMonthSuffix.
  ///
  /// In en, this message translates to:
  /// **' /month'**
  String get perMonthSuffix;

  /// No description provided for @cancelAnytimeNoContract.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime — no long-term contract'**
  String get cancelAnytimeNoContract;

  /// No description provided for @proBadge.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get proBadge;

  /// No description provided for @whatYouGet.
  ///
  /// In en, this message translates to:
  /// **'What you get'**
  String get whatYouGet;

  /// No description provided for @prioritySupportBullet.
  ///
  /// In en, this message translates to:
  /// **'Priority support — faster reply on tickets'**
  String get prioritySupportBullet;

  /// No description provided for @homeLabel.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeLabel;

  /// No description provided for @referLabel.
  ///
  /// In en, this message translates to:
  /// **'Refer'**
  String get referLabel;

  /// No description provided for @goPremiumBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Premium '**
  String get goPremiumBannerTitle;

  /// No description provided for @goPremiumBannerPrice.
  ///
  /// In en, this message translates to:
  /// **'— ₹49/month'**
  String get goPremiumBannerPrice;

  /// No description provided for @unlock30TasksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock 30 tasks/day at the same rate'**
  String get unlock30TasksSubtitle;

  /// No description provided for @dontLoseStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t lose today\'s streak'**
  String get dontLoseStreakTitle;

  /// No description provided for @notificationRationale.
  ///
  /// In en, this message translates to:
  /// **'We\'ll let you know when you\'re close to missing today\'s task cap, and when a task or referral is credited — nothing more.'**
  String get notificationRationale;

  /// No description provided for @turnOnNotifications.
  ///
  /// In en, this message translates to:
  /// **'Turn on notifications'**
  String get turnOnNotifications;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @oneMoreStep.
  ///
  /// In en, this message translates to:
  /// **'One more step'**
  String get oneMoreStep;

  /// No description provided for @verifyYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone number'**
  String get verifyYourPhone;

  /// No description provided for @sendingCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Sending a 6-digit code by SMS to +91 {maskedPhone}…'**
  String sendingCodeMessage(String maskedPhone);

  /// No description provided for @sentCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6-digit code by SMS to +91 {maskedPhone}.'**
  String sentCodeMessage(String maskedPhone);

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @resendOtpInCountdown.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the code? Resend OTP in 0:{seconds}'**
  String resendOtpInCountdown(String seconds);

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & continue'**
  String get verifyAndContinue;

  /// No description provided for @changeMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Change mobile number'**
  String get changeMobileNumber;

  /// No description provided for @smsDndNotice.
  ///
  /// In en, this message translates to:
  /// **'Make sure your number can receive SMS — some DND (Do Not Disturb) settings block OTP messages. Code expires in 10 minutes.'**
  String get smsDndNotice;

  /// No description provided for @otpCodeMismatchRetry.
  ///
  /// In en, this message translates to:
  /// **'That code didn\'t match. Check and try again.'**
  String get otpCodeMismatchRetry;

  /// No description provided for @otpCodeExpired.
  ///
  /// In en, this message translates to:
  /// **'This code has expired — request a new one.'**
  String get otpCodeExpired;

  /// No description provided for @otpTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. You\'re temporarily locked out for 5 minutes.'**
  String get otpTooManyAttempts;

  /// No description provided for @couldNotVerifyRightNow.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t verify that code right now. ({error})'**
  String couldNotVerifyRightNow(String error);

  /// No description provided for @couldNotSendOtpWithError.
  ///
  /// In en, this message translates to:
  /// **'Could not send OTP right now. ({error})'**
  String couldNotSendOtpWithError(String error);

  /// No description provided for @couldNotResendOtpWithError.
  ///
  /// In en, this message translates to:
  /// **'Could not resend OTP right now. ({error})'**
  String couldNotResendOtpWithError(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
