// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get heroTagline => 'भारत के लिए बनाई गई आसान रोज़ाना कमाई';

  @override
  String get heroHeadline => 'रोज़ 25 विज्ञापन देखें। हर महीने भुगतान पाएं।';

  @override
  String get heroDescription =>
      'ऐप खोलें, एक टास्क पर टैप करें, एक छोटा वीडियो विज्ञापन देखें, ₹100 कमाएं। इसे दिन में 25 बार करें और हर महीने सीधे UPI पर निकालें — कोई सर्वे नहीं, कोई जटिल ऑफ़र नहीं।';

  @override
  String get seePaymentProofs => 'असली भुगतान प्रमाण देखें';

  @override
  String get createFreeAccount => 'मुफ़्त खाता बनाएं';

  @override
  String get logIn => 'लॉग इन करें';

  @override
  String get legalAndSupport => 'कानूनी व सहायता';

  @override
  String get loginTitle => 'अपने खाते में लॉग इन करें';

  @override
  String get loginSubtitle =>
      'वापसी पर स्वागत है — जारी रखने के लिए अपनी जानकारी दर्ज करें।';

  @override
  String get mobileOrEmailLabel => 'मोबाइल नंबर या ईमेल';

  @override
  String get mobileOrEmailHint => '98765 43210 या you@example.com';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get passwordHint => 'आपका पासवर्ड';

  @override
  String get rememberMe => 'मुझे याद रखें';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String newToApp(String brandName) {
    return '$brandName में नए हैं? ';
  }

  @override
  String get createAccountLink => 'मुफ़्त खाता बनाएं';

  @override
  String get registerTitle => 'एक मिनट से भी कम समय में कमाई शुरू करें';

  @override
  String get registerSubtitle => 'हमेशा मुफ़्त। किसी कार्ड की ज़रूरत नहीं।';

  @override
  String get fullNameLabel => 'पूरा नाम';

  @override
  String get fullNameHint => 'आपका नाम';

  @override
  String get mobileNumberLabel => 'मोबाइल नंबर';

  @override
  String get otpHint =>
      'हम इस ईमेल को सत्यापित करने के लिए 6-अंकों का कोड भेजेंगे।';

  @override
  String get passwordHintChars => 'कम से कम 8 अक्षर';

  @override
  String get referralCodeOptionalLabel => 'रेफ़रल कोड (वैकल्पिक)';

  @override
  String get referralCodeHint => 'उदा. SAMBIT482';

  @override
  String get sendOtp => 'OTP भेजें';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है? ';

  @override
  String get passwordUpdatedLoginMessage =>
      'पासवर्ड अपडेट हो गया। अपने नए पासवर्ड से लॉग इन करें।';

  @override
  String get resetPasswordTitle => 'अपना पासवर्ड रीसेट करें';

  @override
  String get resetPasswordSubtitle =>
      'अपना ईमेल दर्ज करें और हम पासवर्ड रीसेट करने के लिए 6-अंकों का कोड भेजेंगे।';

  @override
  String get didntGetOtp =>
      'कोड नहीं मिला? अपना स्पैम फ़ोल्डर जांचें, या कुछ मिनट रुककर फिर से कोशिश करें।';

  @override
  String get remembered => 'याद आ गया? ';

  @override
  String get backToLogin => 'लॉग इन पर वापस जाएं';

  @override
  String get verifyAndReset => 'सत्यापित करें और रीसेट करें';

  @override
  String verifyResetSubtitle(String maskedEmail) {
    return '$maskedEmail पर भेजा गया 6-अंकों का कोड दर्ज करें, फिर एक नया पासवर्ड चुनें।';
  }

  @override
  String get resendOtp => 'OTP दोबारा भेजें';

  @override
  String get newPasswordLabel => 'नया पासवर्ड';

  @override
  String get confirmPasswordLabel => 'पासवर्ड की पुष्टि करें';

  @override
  String get confirmPasswordHint => 'नया पासवर्ड फिर से दर्ज करें';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते।';

  @override
  String get updatePassword => 'पासवर्ड अपडेट करें';

  @override
  String get consentPrefix => 'मैं 14+ हूं और ';

  @override
  String get termsLabel => 'नियम व शर्तों';

  @override
  String get consentAnd => ' और ';

  @override
  String get privacyPolicyLabel => 'गोपनीयता नीति';

  @override
  String get consentSuffix => ' से सहमत हूं';

  @override
  String get aboutUs => 'हमारे बारे में';

  @override
  String get faq => 'सामान्य प्रश्न';

  @override
  String get contact => 'संपर्क करें';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get refundPolicy => 'रिफंड नीति';

  @override
  String get tasksPerDayLabel => 'टास्क/दिन';

  @override
  String get earnersLabel => 'कमाने वाले';

  @override
  String get monthlyValue => 'मासिक';

  @override
  String get payoutLabel => 'भुगतान';

  @override
  String get sslSecured => 'SSL सुरक्षित';

  @override
  String get yearsPaying => '7 साल से भुगतान';

  @override
  String get upiBankPill => 'UPI · बैंक';

  @override
  String get howItWorks => 'यह कैसे काम करता है';

  @override
  String get stepTapTask => 'एक टास्क पर टैप करें — रोज़ 25 उपलब्ध';

  @override
  String get stepWatchAd =>
      'वीडियो विज्ञापन देखें — स्किप नहीं कर सकते, ~20–30 सेकंड';

  @override
  String get stepGetCredited => 'क्रेडिट पाएं — हर विज्ञापन के तुरंत बाद';

  @override
  String get stepWithdraw =>
      'मासिक निकासी — महीने में एक बार, 1 तारीख को, UPI या बैंक में';

  @override
  String get walletLabel => 'वॉलेट';

  @override
  String get referAndEarnLabel => 'रेफ़र करें और कमाएं';

  @override
  String get goodMorning => 'सुप्रभात';

  @override
  String get goodAfternoon => 'शुभ दोपहर';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get dailyTaskStreak => 'आपकी दैनिक टास्क स्ट्रीक';

  @override
  String get dayLetters => 'र,सो,मं,बु,गु,शु,श';

  @override
  String get todaysTasks => 'आज के टास्क';

  @override
  String get capReachedMessage => 'आपने आज की सीमा पूरी कर ली है। कल फिर आएं!';

  @override
  String moreToReachLimit(int count) {
    return 'आपकी दैनिक सीमा तक पहुंचने के लिए $count और';
  }

  @override
  String get capReached => 'सीमा पूरी हुई';

  @override
  String get watchVideoToEarn => 'कमाने के लिए एक वीडियो देखें';

  @override
  String get topReferrer => 'टॉप रेफ़रर';

  @override
  String get topAdWatcher => 'टॉप विज्ञापन देखने वाला';

  @override
  String get thisWeeksLeaders => 'इस सप्ताह के अग्रणी';

  @override
  String get weeklyBonusFootnote =>
      'टॉप रेफ़रर और टॉप विज्ञापन देखने वाले को हर हफ़्ते एक बोनस उपहार मिलता है।';

  @override
  String get tasksTitle => 'टास्क';

  @override
  String get adNoticeMessage =>
      'हर टास्क में एक छोटा वीडियो विज्ञापन चलता है। विज्ञापन को स्किप या मिनिमाइज़ नहीं किया जा सकता — क्रेडिट पाने के लिए विज्ञापन खत्म होने तक स्क्रीन पर बने रहें।';

  @override
  String get completedLabel => 'पूर्ण';

  @override
  String get earnedTodayLabel => 'आज की कमाई';

  @override
  String taskOfDay(int id) {
    return 'आज का टास्क $id';
  }

  @override
  String watchAndEarn(String amount) {
    return 'एक वीडियो देखें, $amount कमाएं';
  }

  @override
  String get watchNow => 'अभी देखें';

  @override
  String allBonusSlotsWatched(int count) {
    return 'इस सप्ताह के सभी $count बोनस स्लॉट देखे गए 🎉';
  }

  @override
  String bonusSlotsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'इस सप्ताह $count बोनस विज्ञापन स्लॉट बचे हैं',
      one: 'इस सप्ताह 1 बोनस विज्ञापन स्लॉट बचा है',
    );
    return '$_temp0';
  }

  @override
  String get bonusAdsFootnote =>
      'पिछले सप्ताह के रेफ़रल बोनस से। सप्ताह रीसेट होने से पहले कभी भी देखें।';

  @override
  String get bonusAdsTitle => 'बोनस विज्ञापन';

  @override
  String watchedOfTotal(int watched, int total) {
    return '$total में से $watched देखे गए';
  }

  @override
  String get noBonusSlots => 'इस सप्ताह कोई बोनस विज्ञापन स्लॉट नहीं';

  @override
  String get noBonusSlotsExplainer =>
      'उसी सप्ताह 5 प्रीमियम रेफ़रल कन्वर्ट करवाएं और अगले सप्ताह 5 बोनस विज्ञापन स्लॉट अनलॉक करें।';

  @override
  String get lockedLabel => 'लॉक्ड';

  @override
  String resetsIn(int hours, int minutes, int seconds) {
    return '$hoursघं $minutesमि $secondsसे में रीसेट होगा';
  }

  @override
  String get walletTitle => 'वॉलेट';

  @override
  String get withdrawLabel => 'निकालें';

  @override
  String get historyLabel => 'इतिहास';

  @override
  String withdrawalWindowNotice(int days) {
    return 'निकासी महीने में एक बार, 1 तारीख को होती है। अगली विंडो $days दिनों में खुलेगी।';
  }

  @override
  String get paymentMethodTitle => 'भुगतान विधि';

  @override
  String get addUpiNotice => 'भुगतान पाने के लिए सेटिंग्स में UPI ID जोड़ें।';

  @override
  String get recentActivityTitle => 'हाल की गतिविधि';

  @override
  String get balanceBreakdown => 'बैलेंस विवरण';

  @override
  String get taskAdEarnings => 'टास्क (वीडियो विज्ञापन) कमाई';

  @override
  String get referralEarnings => 'रेफ़रल कमाई';

  @override
  String get bonusRewards => 'बोनस रिवॉर्ड';

  @override
  String get defaultBadge => 'डिफ़ॉल्ट';

  @override
  String get availableBalance => 'उपलब्ध बैलेंस';

  @override
  String todayAtTime(String time) {
    return 'आज, $time';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन पहले',
      one: '1 दिन पहले',
    );
    return '$_temp0';
  }

  @override
  String get referAndEarnTitle => 'रेफ़र करें और कमाएं';

  @override
  String get referralCommissionNotice =>
      'आप तभी ₹125 कमाते हैं जब आपका रेफ़र किया व्यक्ति ₹49 का प्रीमियम खरीदता है, केवल साइन अप करने पर नहीं। उनका भुगतान पूरा होने तक यह पेंडिंग दिखेगा।';

  @override
  String get recentReferralsTitle => 'हाल के रेफ़रल';

  @override
  String get referredLabel => 'रेफ़र किए';

  @override
  String get convertedLabel => 'कन्वर्ट किए';

  @override
  String get earnedLabel => 'कमाए';

  @override
  String get referralLinkCopied => 'रेफ़रल लिंक कॉपी हुआ';

  @override
  String get referralCodeCopied => 'रेफ़रल कोड कॉपी हुआ';

  @override
  String shareReferralMessage(String brandName, String link) {
    return '$brandName पर मेरे साथ जुड़ें और कमाना शुरू करें! मेरा लिंक इस्तेमाल करें: $link';
  }

  @override
  String get yourReferralCode => 'आपका रेफ़रल कोड';

  @override
  String get copyLink => 'लिंक कॉपी करें';

  @override
  String get shareLabel => 'शेयर करें';

  @override
  String get pendingLabel => 'पेंडिंग';

  @override
  String get thisWeeksTopReferrers => 'इस सप्ताह के टॉप रेफ़रर';

  @override
  String conversionsCount(int count) {
    return '$count कन्वर्जन';
  }

  @override
  String get topReferrerBonusFootnote =>
      'इस सप्ताह का टॉप रेफ़रर एक बोनस उपहार जीतता है।';

  @override
  String get weeklyReferralBonusTitle => 'साप्ताहिक रेफ़रल बोनस';

  @override
  String get weeklyBonusLockedExplainer =>
      'उसी सप्ताह 5 प्रीमियम रेफ़रल कन्वर्ट करवाएं और अगले सप्ताह +5 बोनस विज्ञापन स्लॉट कमाएं, लेकिन यह सुविधा केवल प्रीमियम के लिए है। योग्य बनने के लिए अपग्रेड करें।';

  @override
  String get upgradeToPremiumArrow => 'प्रीमियम में अपग्रेड करें →';

  @override
  String bonusSlotsActiveMessage(int count) {
    return '🎉 इस सप्ताह $count बोनस विज्ञापन स्लॉट सक्रिय हैं। किसी भी क्रम में, सप्ताह खत्म होने से पहले कभी भी देखने के लिए टास्क पर जाएं।';
  }

  @override
  String weeklyBonusProgress(
    int converted,
    int threshold,
    int remaining,
    int slots,
  ) {
    return 'इस सप्ताह $threshold में से $converted प्रीमियम रेफ़रल कन्वर्ट हुए। अगले सप्ताह +$slots बोनस विज्ञापन स्लॉट के लिए $remaining और कन्वर्ट करवाएं।';
  }

  @override
  String get enterValidAmount => 'एक मान्य निकासी राशि दर्ज करें।';

  @override
  String get cannotExceedBalance =>
      'आप अपने उपलब्ध बैलेंस से अधिक नहीं निकाल सकते।';

  @override
  String withdrawalRequestedMessage(String date) {
    return 'निकासी का अनुरोध किया गया — $date के भुगतान चक्र के लिए कतारबद्ध।';
  }

  @override
  String get withdrawTitle => 'निकालें';

  @override
  String withdrawWindowNotice(int days) {
    return 'निकासी महीने में एक बार, 1 तारीख को होती है। इस महीने की विंडो $days दिनों में खुलेगी — आपका अनुरोध तब तक कतार में रहेगा, तुरंत ट्रांसफर नहीं होगा।';
  }

  @override
  String get amountLabel => 'राशि';

  @override
  String get enterAmountHint => 'राशि दर्ज करें';

  @override
  String get payoutMethodLabel => 'भुगतान विधि';

  @override
  String get upiMethodLabel => 'UPI (Google Pay / PhonePe / Paytm)';

  @override
  String get addUpiBeforeWithdrawNotice =>
      'निकासी का अनुरोध करने से पहले सेटिंग्स में UPI ID जोड़ें।';

  @override
  String get recentUpiCapNotice =>
      'यह UPI ID पिछले 24 घंटों में जोड़ी गई है, इसलिए इस दौरान इसमें निकासी ₹5,000 तक सीमित है। यदि इस कारण ट्रांसफर विफल होता है, तो यह 24 घंटे बीतने के बाद अपने आप फिर से कोशिश कर सकता है।';

  @override
  String get queuingLabel => 'कतारबद्ध हो रहा है...';

  @override
  String queueWithdrawalFor(String date) {
    return '$date के लिए निकासी कतारबद्ध करें';
  }

  @override
  String get firstTimeWithdrawalNotice =>
      'पहली बार निकासी के लिए मैनुअल सत्यापन आवश्यक हो सकता है।';

  @override
  String get appLanguageLabel => 'ऐप की भाषा';

  @override
  String get termsAndPrivacy => 'नियम व गोपनीयता';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get accountLabel => 'खाता';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get securityAndPassword => 'सुरक्षा व पासवर्ड';

  @override
  String get paymentDetails => 'भुगतान विवरण';

  @override
  String get manageSubscription => 'सदस्यता प्रबंधित करें';

  @override
  String get supportLabel => 'सहायता';

  @override
  String get notificationsLabel => 'सूचनाएं';

  @override
  String get supportTickets => 'सहायता टिकट';

  @override
  String get contactUs => 'हमसे संपर्क करें';

  @override
  String get paymentProofs => 'भुगतान प्रमाण';

  @override
  String get logOut => 'लॉग आउट करें';

  @override
  String get premiumBadge => 'प्रीमियम';

  @override
  String get freeBadge => 'फ्री';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get profilePhotoRemoved => 'प्रोफ़ाइल फ़ोटो हटाई गई';

  @override
  String get profilePhotoUpdated => 'प्रोफ़ाइल फ़ोटो अपडेट हुई';

  @override
  String get fullNameSettingsLabel => 'पूरा नाम';

  @override
  String get emailAddressLabel => 'ईमेल पता';

  @override
  String get saveChanges => 'बदलाव सहेजें';

  @override
  String get profileUpdated => 'प्रोफ़ाइल अपडेट हुई';

  @override
  String get securityTitle => 'सुरक्षा';

  @override
  String get currentPasswordLabel => 'वर्तमान पासवर्ड';

  @override
  String get currentPasswordHint => 'आपका वर्तमान पासवर्ड';

  @override
  String get passwordUpdatedShort => 'पासवर्ड अपडेट हुआ';

  @override
  String get twoStepOn => 'दो-चरणीय सत्यापन चालू हुआ';

  @override
  String get twoStepOff => 'दो-चरणीय सत्यापन बंद हुआ';

  @override
  String get paymentDetailsTitle => 'भुगतान विवरण';

  @override
  String get upiIdUpdated => 'UPI ID अपडेट हुई';

  @override
  String get bankAccountLabel => 'बैंक खाता';

  @override
  String get pushNotificationsTitle => 'पुश सूचनाएं';

  @override
  String get earningsPushTitle => 'कमाई';

  @override
  String get earningsPushSubtitle => 'टास्क क्रेडिट, रेफ़रल, स्ट्रीक बोनस';

  @override
  String get accountPushTitle => 'खाता';

  @override
  String get accountPushSubtitle => 'सुरक्षा अलर्ट, जैसे नए डिवाइस से लॉगिन';

  @override
  String get promotionsPushTitle => 'प्रचार';

  @override
  String get promotionsPushSubtitle => 'कभी-कभी ऑफ़र, जैसे प्रीमियम छूट';

  @override
  String get cropPhoto => 'फ़ोटो क्रॉप करें';

  @override
  String get takeAPhoto => 'फ़ोटो लें';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get removePhoto => 'फ़ोटो हटाएं';

  @override
  String get twoStepVerification => 'दो-चरणीय सत्यापन';

  @override
  String get extraCodeAtLogin => 'लॉगिन पर अतिरिक्त कोड';

  @override
  String get confirmYourPassword => 'अपने पासवर्ड की पुष्टि करें';

  @override
  String get turnOffTwoStepExplainer =>
      'दो-चरणीय सत्यापन बंद करने से आपके खाते की सुरक्षा कम हो जाती है। पुष्टि के लिए अपना पासवर्ड दर्ज करें।';

  @override
  String get cancelLabel => 'रद्द करें';

  @override
  String get turnOff => 'बंद करें';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get defaultLabelLower => 'डिफ़ॉल्ट';

  @override
  String get upiIdHint => 'yourname@bank';

  @override
  String get upiIdValidationError =>
      'एक मान्य UPI ID दर्ज करें, उदा. yourname@okhdfcbank.';

  @override
  String get saveUpiId => 'UPI ID सहेजें';

  @override
  String get notificationsTitle => 'सूचनाएं';

  @override
  String get markAllRead => 'सभी पढ़ी हुई चिह्नित करें';

  @override
  String get noNotificationsHere => 'यहां कोई सूचना नहीं है';

  @override
  String get allFilterLabel => 'सभी';

  @override
  String allFilterLabelWithCount(int count) {
    return 'सभी ($count)';
  }

  @override
  String get transactionsTitle => 'लेन-देन';

  @override
  String get noTransactionsYet => 'अभी तक कोई लेन-देन नहीं';

  @override
  String get tasksFilterLabel => 'टास्क';

  @override
  String get referralsFilterLabel => 'रेफ़रल';

  @override
  String get withdrawalsFilterLabel => 'निकासी';

  @override
  String get newTicket => '+ नया टिकट';

  @override
  String get supportReplyTimeNotice =>
      'हम हर टिकट को 24–48 घंटों के भीतर पढ़ते और जवाब देते हैं।';

  @override
  String get noOpenTickets => 'कोई खुला टिकट नहीं';

  @override
  String get noClosedTickets => 'कोई बंद टिकट नहीं';

  @override
  String openWithCount(int count) {
    return 'खुले ($count)';
  }

  @override
  String closedWithCount(int count) {
    return 'बंद ($count)';
  }

  @override
  String get ticketStatusOpen => 'खुला';

  @override
  String get ticketStatusReply => 'जवाब';

  @override
  String get ticketStatusClosed => 'बंद';

  @override
  String get describeIssueFirst => 'जमा करने से पहले अपनी समस्या बताएं।';

  @override
  String get raiseNewTicket => 'नया टिकट बनाएं';

  @override
  String get messageLabel => 'संदेश';

  @override
  String get tellUsWhatHappened => 'हमें बताएं क्या हुआ...';

  @override
  String get submittingLabel => 'जमा हो रहा है...';

  @override
  String get submitTicket => 'टिकट जमा करें';

  @override
  String get typeAReply => 'जवाब लिखें...';

  @override
  String supportAuthorLabel(String authorName) {
    return 'सहायता ($authorName)';
  }

  @override
  String get aboutTitle => 'हमारे बारे में';

  @override
  String get aboutHeadline =>
      'उन लोगों द्वारा बनाया गया जो कभी भुगतान न करने वाले कमाई ऐप्स से परेशान हुए थे।';

  @override
  String aboutBody(int foundingYear) {
    return 'EarnBucks की शुरुआत $foundingYear में उन ऐप्स के जवाब में हुई जो निकासी मांगने पर गायब हो जाते हैं।';
  }

  @override
  String get companyDetailsTitle => 'कंपनी विवरण';

  @override
  String get legalEntityNameField => 'कानूनी संस्था का नाम';

  @override
  String get registrationNumberField => 'पंजीकरण संख्या';

  @override
  String get registeredAddressField => 'पंजीकृत पता';

  @override
  String get companyDetailsPendingNote =>
      'कानूनी पुष्टि लंबित — यहां कोई नाम, संख्या या पता न बनाएं।';

  @override
  String get seePaymentProofsButton => 'भुगतान प्रमाण देखें';

  @override
  String get foundedLabel => 'स्थापित';

  @override
  String get statesLabel => 'राज्य';

  @override
  String get fourCommitments => 'चार प्रतिबद्धताएं';

  @override
  String get commitmentTransparencyTitle => 'पारदर्शिता';

  @override
  String get commitmentTransparencyBody =>
      'हर भुगतान सार्वजनिक रूप से प्रकाशित होता है — हमारे भुगतान प्रमाण पेज पर असली, सत्यापित निकासी देखें, केवल वादा नहीं।';

  @override
  String get commitmentNoPayToJoinTitle => 'जुड़ने के लिए भुगतान नहीं';

  @override
  String get commitmentNoPayToJoinBody =>
      'साइन अप हमेशा मुफ़्त है। कमाने या निकालने पर कभी कोई शुल्क नहीं — कोई डिपॉज़िट नहीं, कोई छिपा हुआ शुल्क नहीं।';

  @override
  String get commitmentFairRatesTitle => 'उचित दरें';

  @override
  String get commitmentFairRatesBody =>
      'किसी टास्क की सटीक ₹ दर शुरू करने से पहले दिखाई जाती है — कोई अनपेक्षित कटौती नहीं, बिना सूचना के दर में बदलाव नहीं।';

  @override
  String get commitmentRealSupportTitle => 'असली सहायता';

  @override
  String get commitmentRealSupportBody =>
      'हर सहायता टिकट को एक इंसान पढ़ता है — बॉट लूप नहीं, आपको हमेशा असली जवाब मिलता है।';

  @override
  String get faqTitle => 'सामान्य प्रश्न';

  @override
  String get faqSectionTasks => 'टास्क व कमाई';

  @override
  String get faqSectionPayments => 'भुगतान';

  @override
  String get faqSectionReferrals => 'रेफ़रल व प्रीमियम';

  @override
  String get contactSupportButton => 'सहायता से संपर्क करें';

  @override
  String get faqQ1 => 'रोज़ केवल 25 टास्क ही क्यों?';

  @override
  String get faqA1 =>
      'एक तय दैनिक सीमा सभी के लिए भुगतान को अनुमानित और टिकाऊ बनाए रखती है। प्रीमियम सदस्यों को उसी ₹/टास्क दर पर 30/दिन मिलते हैं।';

  @override
  String get faqQ2 => 'हर टास्क का भुगतान कितना है?';

  @override
  String get faqA2 =>
      '₹100 प्रति टास्क — सभी 25 पूरा करें और रोज़ाना ₹2,500 तक कमाएं।';

  @override
  String get faqQ3 => 'मेरे दैनिक टास्क कब रीसेट होते हैं?';

  @override
  String get faqA3 =>
      'हर दिन आधी रात को। आज की सीमा में जो बचा है वह गायब हो जाता है — कोई रोलओवर नहीं होता।';

  @override
  String get faqQ4 => 'मैं विज्ञापन को स्किप क्यों नहीं कर सकता?';

  @override
  String get faqA4 =>
      'आपका इनाम विज्ञापनदाता द्वारा पूरा दृश्य देखने के लिए भुगतान से वित्तपोषित होता है — जल्दी स्किप करने का मतलब है कोई इनाम क्रेडिट नहीं हो सकता। क्रेडिट तभी मिलता है जब विज्ञापन पूरा हो जाए, टैप या खोलने पर नहीं।';

  @override
  String get faqQ5 => 'क्या मैं कई खातों का उपयोग करके अधिक टास्क पा सकता हूं?';

  @override
  String get faqA5 =>
      'नहीं — हर फ़ोन नंबर को एक ही खाता मिलता है, और कई खातों का उपयोग हमारी शर्तों के विरुद्ध है।';

  @override
  String get faqQ6 => 'मुझे भुगतान कब मिलता है?';

  @override
  String get faqA6 =>
      'निकासी महीने में एक बार, 1 तारीख को, सीधे आपकी UPI ID या सत्यापित बैंक खाते में (IMPS ट्रांसफर) प्रोसेस की जाती है।';

  @override
  String get faqQ7 => 'क्या मैं जब चाहूं निकासी कर सकता हूं?';

  @override
  String get faqA7 =>
      'अभी नहीं — भुगतान केवल मासिक हैं, कोई ऑन-डिमांड निकासी नहीं है।';

  @override
  String get faqQ8 => 'आप कौन सी भुगतान विधियों का समर्थन करते हैं?';

  @override
  String get faqA8 =>
      'केवल UPI (Google Pay, PhonePe, Paytm) और सत्यापित बैंक खाता ट्रांसफर — कोई PayPal नहीं, कोई वॉलेट नहीं, कोई अन्य भुगतान विधि नहीं।';

  @override
  String get faqQ9 => 'अगर मेरे पास गलत UPI ID सेव है तो क्या होगा?';

  @override
  String get faqA9 =>
      'भुगतान सेटिंग्स में सेव जो भी है वहां जाता है, इसलिए 1 तारीख से पहले इसे दोबारा जांच लें — एक टाइपो का मतलब है भुगतान में देरी जब तक हमारी टीम इसे ठीक करने में मदद करती है।';

  @override
  String get faqQ10 => 'मुझे प्रति रेफ़रल कितना कमाई होती है?';

  @override
  String get faqA10 =>
      'फ्लैट ₹125, केवल तभी क्रेडिट होता है जब आपके रेफ़र किए व्यक्ति ने ₹49 का प्रीमियम खरीद पूरा किया हो — केवल साइन अप करने पर कभी नहीं।';

  @override
  String get faqQ11 => 'मेरा रेफ़रल अभी भी \"पेंडिंग\" क्यों दिख रहा है?';

  @override
  String get faqA11 =>
      'यह तब तक पेंडिंग रहता है जब तक आपके रेफ़रल का प्रीमियम भुगतान पूरा न हो जाए। ऐसा होते ही ₹125 अपने आप क्रेडिट हो जाता है।';

  @override
  String get faqQ12 => 'प्रीमियम में क्या शामिल है?';

  @override
  String get faqA12 =>
      '25 की जगह 30 टास्क/दिन, उसी ₹/टास्क दर पर — प्रति टास्क कभी कम हिस्सा नहीं।';

  @override
  String get faqQ13 => 'क्या मैं कभी भी प्रीमियम रद्द कर सकता हूं?';

  @override
  String get faqA13 =>
      'हां, प्रोफ़ाइल → सदस्यता प्रबंधित करें से। रद्द करने के बाद भी आपके लाभ भुगतान चक्र के अंत तक जारी रहते हैं।';

  @override
  String get faqQ14 =>
      'अगर मेरे रेफ़रल का प्रीमियम खरीद रिफंड हो जाए तो क्या होगा?';

  @override
  String get faqA14 =>
      '₹125 का कमीशन वापस ले लिया जाता है — आपके बैलेंस से काटा जाता है, अगर वह पहले ही भुगतान हो चुका है तो भविष्य के भुगतान से भी।';

  @override
  String get faqQ15 => 'साप्ताहिक रेफ़रल बोनस क्या है?';

  @override
  String get faqA15 =>
      'जो प्रीमियम सदस्य एक ही रविवार–शनिवार सप्ताह में 5 या अधिक रेफ़रल को प्रीमियम में कन्वर्ट करवाते हैं, वे अगले सप्ताह सक्रिय होने वाले +5 बोनस विज्ञापन स्लॉट कमाते हैं। यह आपके खुद प्रीमियम रखने पर निर्भर है। फ्री-टियर खाते फिर भी ₹125 कमीशन कमाते हैं, बस यह बोनस कभी नहीं।';

  @override
  String get faqQ16 =>
      'क्या यह मायने रखता है कि मेरा रेफ़रल कब साइन अप हुआ, या कब प्रीमियम बना?';

  @override
  String get faqA16 =>
      'केवल वह सप्ताह मायने रखता है जिसमें उनकी प्रीमियम खरीद होती है, आपके 5 की गिनती के लिए। साइन अप का समय मायने नहीं रखता, और हर सप्ताह अपने आप में आंका जाता है। अगर एक सप्ताह 4 कन्वर्ट होते हैं और अगले सप्ताह 5वां, तो कोई भी सप्ताह 5 तक नहीं पहुंचता और किसी के लिए भी बोनस नहीं मिलता।';

  @override
  String get fillContactFormNotice =>
      'अपना नाम, एक मान्य ईमेल और एक संदेश भरें।';

  @override
  String get signInToSendMessage => 'संदेश भेजने के लिए कृपया साइन इन करें।';

  @override
  String messageSentNotice(String range) {
    return 'संदेश भेजा गया — हम $range के भीतर जवाब देंगे।';
  }

  @override
  String get contactUsTitle => 'हमसे संपर्क करें';

  @override
  String everyTicketAnswered(String range, String premiumSuffix) {
    return 'हर टिकट $range$premiumSuffix के भीतर पढ़ा और जवाब दिया जाता है।';
  }

  @override
  String get premiumPrioritySuffix => ' — प्रीमियम प्राथमिकता';

  @override
  String get contactMessageHint => 'हमें बताएं क्या हो रहा है...';

  @override
  String get sendMessageButton => 'संदेश भेजें';

  @override
  String get responseTimePremium => '12–24 घंटे';

  @override
  String get responseTimeStandard => '24–48 घंटे';

  @override
  String get otherWaysToReachUs => 'हमसे संपर्क करने के अन्य तरीके';

  @override
  String get supportChannelLabel => 'सहायता';

  @override
  String get paymentsChannelLabel => 'भुगतान';

  @override
  String weUsuallyReplyWithin(String range) {
    return 'हम आमतौर पर $range के भीतर जवाब देते हैं।';
  }

  @override
  String noEmailAppFound(String email) {
    return '$email के लिए कोई ईमेल ऐप नहीं मिला';
  }

  @override
  String get topicLabel => 'विषय';

  @override
  String get topicAccountAccess => 'खाता एक्सेस';

  @override
  String get topicWithdrawalIssue => 'निकासी समस्या';

  @override
  String get topicAdNotCredited => 'विज्ञापन क्रेडिट नहीं हुआ';

  @override
  String get topicReferralCommissionMissing => 'रेफ़रल कमीशन गायब है';

  @override
  String get topicSomethingElse => 'कुछ और';

  @override
  String get howItWorksTitle => 'यह कैसे काम करता है';

  @override
  String get howItWorksIntro =>
      'एक कमाई का तरीका, सरल रखा गया। कोई ऑफ़र वॉल नहीं, कोई सर्वे नहीं, कोई भ्रमित करने वाले टास्क प्रकार नहीं — बस छोटे वीडियो विज्ञापन, रोज़ 25 तक।';

  @override
  String get wantMore => 'और चाहिए?';

  @override
  String get referAndEarnInfoTitle => 'रेफ़र करें और कमाएं';

  @override
  String get referAndEarnInfoMessage =>
      'अपना रेफ़रल लिंक शेयर करें। आप तभी ₹125 कमाते हैं जब आपका रेफ़र किया व्यक्ति ₹49 का प्रीमियम खरीद पूरा करता है, केवल साइन अप करने पर नहीं। कमाई तब तक \"पेंडिंग\" दिखती है जब तक उनका भुगतान पूरा नहीं होता, और अगर उनका भुगतान रिफंड हो जाता है तो वापस ले ली जाती है।';

  @override
  String get goPremiumInfoTitle => 'प्रीमियम लें';

  @override
  String get goPremiumBullet1 => 'फ्री के 25 से बढ़कर 30 टास्क/दिन';

  @override
  String get goPremiumBullet2 => 'वही ₹/टास्क दर — प्रति टास्क कम भुगतान नहीं';

  @override
  String get goPremiumBullet3 =>
      'मासिक बिल — सेटिंग्स से कभी भी रद्द करें, लाभ भुगतान चक्र के अंत तक जारी रहते हैं';

  @override
  String get weeklyBonusInfoTitle => 'साप्ताहिक रेफ़रल बोनस';

  @override
  String get weeklyBonusInfoMessage =>
      'जो प्रीमियम सदस्य एक ही रविवार–शनिवार सप्ताह में 5 या अधिक रेफ़रल को प्रीमियम में कन्वर्ट करवाते हैं, वे अगले सप्ताह सक्रिय होने वाले +5 बोनस विज्ञापन स्लॉट कमाते हैं। जो सप्ताह मायने रखता है वह है जब आपके रेफ़रल की खरीद होती है, न कि जब वे साइन अप हुए। हर सप्ताह बिना किसी आंशिक कैरीओवर के साफ़ रीसेट होता है।';

  @override
  String get stepCreateAccountTitle => 'अपना मुफ़्त खाता बनाएं';

  @override
  String get stepCreateAccountBody =>
      'एक मिनट से भी कम समय में अपने मोबाइल नंबर से साइन अप करें — जुड़ने का कोई शुल्क नहीं।';

  @override
  String get stepOpenTasksTitle => 'आज के टास्क खोलें';

  @override
  String get stepOpenTasksBody =>
      '25 टास्क रोज़ आधी रात को रीसेट होते हैं (प्रीमियम प्लान पर 30)।';

  @override
  String get stepWatchAdTitle => 'वीडियो विज्ञापन देखें';

  @override
  String get stepWatchAdBody =>
      'हर टास्क में एक छोटा, स्किप न होने वाला वीडियो विज्ञापन चलता है — इसके खत्म होने तक स्क्रीन पर बने रहें।';

  @override
  String get stepGetPaidTitle => 'मासिक भुगतान पाएं';

  @override
  String get stepGetPaidBody =>
      'सभी कमाई महीने में एक बार, 1 तारीख को, UPI या बैंक ट्रांसफर में भुगतान की जाती है।';

  @override
  String get paymentProofsTitle => 'भुगतान प्रमाण';

  @override
  String get paymentProofsIntro =>
      'हर निकासी यहां अपने आप दिखाई देती है। कुछ भी चुनकर नहीं दिखाया जाता।';

  @override
  String get lastCycleLabel => 'पिछला चक्र';

  @override
  String get totalEarnersLabel => 'कुल कमाने वाले';

  @override
  String get paidBadge => 'भुगतान हुआ';

  @override
  String get sampleDataNotLive => 'नमूना डेटा — लाइव नहीं';

  @override
  String get sampleDataExplainer =>
      'इस स्क्रीन पर हर राशि, नाम और तारीख उदाहरण के लिए है, असली भुगतान नहीं। यह बैनर तब तक रहेगा जब तक यह स्क्रीन असली लेन-देन रिकॉर्ड से नहीं जुड़ जाती।';

  @override
  String lastUpdatedOn(String date) {
    return 'अंतिम अपडेट: $date';
  }

  @override
  String get contentsLabel => 'विषय-सूची';

  @override
  String get nowPremiumMessage => 'अब आप प्रीमियम हैं!';

  @override
  String get upgradeTitle => 'अपग्रेड';

  @override
  String get goPremiumTitle => 'प्रीमियम लें';

  @override
  String get unlockExtraTasksSubtitle => 'हर दिन 5 अतिरिक्त टास्क अनलॉक करें।';

  @override
  String premiumActiveUntil(String date) {
    return 'आप $date तक प्रीमियम पर हैं। नवीनीकरण के लिए उससे पहले वापस आएं।';
  }

  @override
  String get youreOnPremium => 'आप प्रीमियम पर हैं।';

  @override
  String get renewNow => 'अभी नवीनीकरण करें';

  @override
  String get subscribePriceButton => 'सब्सक्राइब करें — ₹49/माह';

  @override
  String get billedMonthlyNotice =>
      'Razorpay के माध्यम से एक बार का ₹49 भुगतान 30 दिनों के लिए प्रीमियम अनलॉक करता है — यह अपने आप नवीनीकृत नहीं होता, इसलिए अपने लाभ बनाए रखने के लिए इसके समाप्त होने से पहले फिर से खरीदें।';

  @override
  String get referralCommissionOnUpgradeNotice =>
      'अगर आपको किसी ने रेफ़र किया था, तो यह खरीद पूरी करने पर उनका ₹125 रेफ़रल कमीशन क्रेडिट होता है, यह केवल साइन अप पर कभी क्रेडिट नहीं होता। सदस्यता रद्दीकरण शर्तों के लिए रिफंड नीति देखें।';

  @override
  String get weeklyBonusUnlockNotice =>
      'प्रीमियम साप्ताहिक रेफ़रल बोनस भी अनलॉक करता है: एक ही सप्ताह में 5+ रेफ़रल को प्रीमियम में कन्वर्ट करवाएं और अगले सप्ताह +5 बोनस विज्ञापन स्लॉट कमाएं।';

  @override
  String get perMonthSuffix => ' /माह';

  @override
  String get cancelAnytimeNoContract =>
      'कभी भी रद्द करें — कोई दीर्घकालिक अनुबंध नहीं';

  @override
  String get proBadge => 'PRO';

  @override
  String get whatYouGet => 'आपको क्या मिलता है';

  @override
  String get prioritySupportBullet => 'प्राथमिकता सहायता — टिकट पर तेज़ जवाब';

  @override
  String get homeLabel => 'होम';

  @override
  String get referLabel => 'रेफ़र';

  @override
  String get goPremiumBannerTitle => 'प्रीमियम लें ';

  @override
  String get goPremiumBannerPrice => '— ₹49/माह';

  @override
  String get unlock30TasksSubtitle => 'उसी दर पर 30 टास्क/दिन अनलॉक करें';

  @override
  String get dontLoseStreakTitle => 'आज की स्ट्रीक न गंवाएं';

  @override
  String get notificationRationale =>
      'हम आपको बताएंगे जब आप आज की टास्क सीमा चूकने के करीब हों, और जब कोई टास्क या रेफ़रल क्रेडिट हो — बस इतना ही।';

  @override
  String get turnOnNotifications => 'सूचनाएं चालू करें';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get oneMoreStep => 'एक और कदम';

  @override
  String get verifyYourPhone => 'अपना ईमेल सत्यापित करें';

  @override
  String sentCodeMessage(String maskedEmail) {
    return 'हमने $maskedEmail पर ईमेल द्वारा 6-अंकों का कोड भेजा है।';
  }

  @override
  String resendOtpInCountdown(String seconds) {
    return 'कोड नहीं मिला? 0:$seconds में OTP दोबारा भेजें';
  }

  @override
  String get verifyAndContinue => 'सत्यापित करें और जारी रखें';

  @override
  String get changeMobileNumber => 'विवरण बदलें';

  @override
  String get smsDndNotice =>
      'कोड के लिए अपना इनबॉक्स (और स्पैम फ़ोल्डर) जांचें। यह 10 मिनट में समाप्त हो जाता है।';
}
