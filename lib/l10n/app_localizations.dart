import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Lingola'**
  String get appTitle;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @photoTranslate.
  ///
  /// In en, this message translates to:
  /// **'Photo Translate'**
  String get photoTranslate;

  /// No description provided for @voiceTranslate.
  ///
  /// In en, this message translates to:
  /// **'Voice Translate'**
  String get voiceTranslate;

  /// No description provided for @textTranslation.
  ///
  /// In en, this message translates to:
  /// **'Text Translation'**
  String get textTranslation;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get listening;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// No description provided for @sourceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Source Language'**
  String get sourceLanguage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'F.A.Q.'**
  String get faq;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// No description provided for @shareFriend.
  ///
  /// In en, this message translates to:
  /// **'Share Friend'**
  String get shareFriend;

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

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @placeTextInsideFrame.
  ///
  /// In en, this message translates to:
  /// **'Place the text you want to translate inside the frame.'**
  String get placeTextInsideFrame;

  /// No description provided for @selectOrCapturePhoto.
  ///
  /// In en, this message translates to:
  /// **'Select or capture a photo'**
  String get selectOrCapturePhoto;

  /// No description provided for @selectVoiceModeToBegin.
  ///
  /// In en, this message translates to:
  /// **'Select a voice mode to begin'**
  String get selectVoiceModeToBegin;

  /// No description provided for @realTimeTranslation.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Translation'**
  String get realTimeTranslation;

  /// No description provided for @translating.
  ///
  /// In en, this message translates to:
  /// **'Translating...'**
  String get translating;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @translationCopied.
  ///
  /// In en, this message translates to:
  /// **'Translation copied'**
  String get translationCopied;

  /// No description provided for @translationMustBeSavedFirst.
  ///
  /// In en, this message translates to:
  /// **'Translation must be saved first'**
  String get translationMustBeSavedFirst;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @favoriteUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Favorite update failed'**
  String get favoriteUpdateFailed;

  /// No description provided for @voiceTranslateTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice Translate'**
  String get voiceTranslateTitle;

  /// No description provided for @voiceTranslateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Translation - Faster,\nSmarter Artificial Intelligence'**
  String get voiceTranslateSubtitle;

  /// No description provided for @tryNow.
  ///
  /// In en, this message translates to:
  /// **'Try Now!'**
  String get tryNow;

  /// No description provided for @savingResult.
  ///
  /// In en, this message translates to:
  /// **'Saving result...'**
  String get savingResult;

  /// No description provided for @translationResults.
  ///
  /// In en, this message translates to:
  /// **'Translation results'**
  String get translationResults;

  /// No description provided for @tapToTranslateNow.
  ///
  /// In en, this message translates to:
  /// **'Tap to translate now'**
  String get tapToTranslateNow;

  /// No description provided for @selectLanguageToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Please select the language you wish to speak in'**
  String get selectLanguageToSpeak;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get languageTurkish;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @demoRecognizedTextTr.
  ///
  /// In en, this message translates to:
  /// **'Merhaba, nasılsın?'**
  String get demoRecognizedTextTr;

  /// No description provided for @demoRecognizedTextEn.
  ///
  /// In en, this message translates to:
  /// **'Hello, how are you?'**
  String get demoRecognizedTextEn;

  /// No description provided for @textTranslationTitle.
  ///
  /// In en, this message translates to:
  /// **'Text Translation'**
  String get textTranslationTitle;

  /// No description provided for @sourceLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'SOURCE LANGUAGE'**
  String get sourceLanguageLabel;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @translationLabel.
  ///
  /// In en, this message translates to:
  /// **'TRANSLATION'**
  String get translationLabel;

  /// No description provided for @aiExpertsTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Experts'**
  String get aiExpertsTitle;

  /// No description provided for @examplesLabel.
  ///
  /// In en, this message translates to:
  /// **'EXAMPLES'**
  String get examplesLabel;

  /// No description provided for @noLoggedInUser.
  ///
  /// In en, this message translates to:
  /// **'No logged in user'**
  String get noLoggedInUser;

  /// No description provided for @savedToHistory.
  ///
  /// In en, this message translates to:
  /// **'Saved to history'**
  String get savedToHistory;

  /// No description provided for @couldNotSaveTranslationFirst.
  ///
  /// In en, this message translates to:
  /// **'Could not save translation first'**
  String get couldNotSaveTranslationFirst;

  /// No description provided for @favoriteRouteNotReady.
  ///
  /// In en, this message translates to:
  /// **'Favorite route is not ready yet'**
  String get favoriteRouteNotReady;

  /// No description provided for @exampleTextTitle1.
  ///
  /// In en, this message translates to:
  /// **'The weather is so nice today;\nI want to go for a walk.'**
  String get exampleTextTitle1;

  /// No description provided for @exampleTextSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Bugün hava çok güzel; yürüyüşe çıkmak istiyorum.'**
  String get exampleTextSubtitle1;

  /// No description provided for @exampleTextTitle2.
  ///
  /// In en, this message translates to:
  /// **'It’s a beautiful day; I think I’ll take a stroll.'**
  String get exampleTextTitle2;

  /// No description provided for @exampleTextSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Harika bir gün; sanırım kısa bir yürüyüş yapacağım.'**
  String get exampleTextSubtitle2;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @freeVersion.
  ///
  /// In en, this message translates to:
  /// **'Free Version'**
  String get freeVersion;

  /// No description provided for @profileProBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited access to\nall features'**
  String get profileProBannerTitle;

  /// No description provided for @pro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get pro;

  /// No description provided for @accountSettingsSection.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT SETTINGS'**
  String get accountSettingsSection;

  /// No description provided for @generalSection.
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get generalSection;

  /// No description provided for @faqTitleShort.
  ///
  /// In en, this message translates to:
  /// **'F.A.Q.'**
  String get faqTitleShort;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @profileLogoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'You are about to log out'**
  String get profileLogoutDialogTitle;

  /// No description provided for @profileLogoutDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See you again soon! We\'ll miss your\nbreathing exercises.'**
  String get profileLogoutDialogSubtitle;

  /// No description provided for @shareWithFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'Share with Friend'**
  String get shareWithFriendTitle;

  /// No description provided for @shareWithFriendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite your friends and enjoy\ntranslate together'**
  String get shareWithFriendSubtitle;

  /// No description provided for @linkLabel.
  ///
  /// In en, this message translates to:
  /// **'LINK'**
  String get linkLabel;

  /// No description provided for @copyTheLink.
  ///
  /// In en, this message translates to:
  /// **'Copy the link'**
  String get copyTheLink;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @profileCouldNotBeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Profile could not be loaded'**
  String get profileCouldNotBeLoaded;

  /// No description provided for @profileLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Profile load failed'**
  String get profileLoadFailed;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get saveFailed;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get accountDeleted;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get deleteFailed;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to\ndelete your account?'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone, and all\nyour history and data will be\npermanently deleted.'**
  String get deleteAccountDialogDescription;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageGerman;

  /// No description provided for @languageItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get languageItalian;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get languageJapanese;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKorean;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get languagePortuguese;

  /// No description provided for @appLanguageChangedTo.
  ///
  /// In en, this message translates to:
  /// **'App language changed to {language}'**
  String appLanguageChangedTo(Object language);

  /// No description provided for @faqQuestion1.
  ///
  /// In en, this message translates to:
  /// **'How does Live Lingola work?'**
  String get faqQuestion1;

  /// No description provided for @faqAnswer1.
  ///
  /// In en, this message translates to:
  /// **'Live Lingola helps you translate text, voice, and other content quickly with AI-powered tools.'**
  String get faqAnswer1;

  /// No description provided for @faqQuestion2.
  ///
  /// In en, this message translates to:
  /// **'Is my data secure?'**
  String get faqQuestion2;

  /// No description provided for @faqAnswer2.
  ///
  /// In en, this message translates to:
  /// **'We take data security seriously and aim to protect your personal information and translation history.'**
  String get faqAnswer2;

  /// No description provided for @faqQuestion3.
  ///
  /// In en, this message translates to:
  /// **'Can I use it offline?'**
  String get faqQuestion3;

  /// No description provided for @faqAnswer3.
  ///
  /// In en, this message translates to:
  /// **'Some features may require an internet connection. Offline support depends on the translation service being used.'**
  String get faqAnswer3;

  /// No description provided for @faqQuestion4.
  ///
  /// In en, this message translates to:
  /// **'How can I cancel my subscription?'**
  String get faqQuestion4;

  /// No description provided for @faqAnswer4.
  ///
  /// In en, this message translates to:
  /// **'You can manage or cancel your subscription from your store account settings or the subscription section of the app.'**
  String get faqAnswer4;

  /// No description provided for @faqQuestion5.
  ///
  /// In en, this message translates to:
  /// **'Is family sharing available?'**
  String get faqQuestion5;

  /// No description provided for @faqAnswer5.
  ///
  /// In en, this message translates to:
  /// **'Family sharing availability depends on your subscription platform and store policies. Please check your account settings for supported options.'**
  String get faqAnswer5;

  /// No description provided for @photoTranslateTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo Translate'**
  String get photoTranslateTitle;

  /// No description provided for @photoTranslateInstruction.
  ///
  /// In en, this message translates to:
  /// **'Place the text you want to translate\ninside the frame.'**
  String get photoTranslateInstruction;

  /// No description provided for @photoTranslationFailed.
  ///
  /// In en, this message translates to:
  /// **'Photo translation failed'**
  String get photoTranslationFailed;

  /// No description provided for @photoTranslationFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'Photo translation failed: {error}'**
  String photoTranslationFailedWithError(Object error);

  /// No description provided for @galleryAccessFailed.
  ///
  /// In en, this message translates to:
  /// **'Gallery access failed: {error}'**
  String galleryAccessFailed(Object error);

  /// No description provided for @cameraAccessFailed.
  ///
  /// In en, this message translates to:
  /// **'Camera access failed: {error}'**
  String cameraAccessFailed(Object error);

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Break Down\nLanguage Barriers'**
  String get onboardingTitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Live Translation\nExperience'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'With Live Lingola, no matter where you are in the world, foreign languages are no longer a barrier. Experience communication at its most fluid.'**
  String get onboardingBody1;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Instantly translate your voice and surrounding text into your own language. Conversations are now seamless with our AI-powered technology.'**
  String get onboardingBody2;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingFlow5Title.
  ///
  /// In en, this message translates to:
  /// **'Your Personal Account\nIs Being Created'**
  String get onboardingFlow5Title;

  /// No description provided for @onboardingFlow5Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your AI assistant is personalizing your experience.\nThis may take a few seconds.'**
  String get onboardingFlow5Subtitle;

  /// No description provided for @onboardingFlow5ProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'AI personalizing your experience'**
  String get onboardingFlow5ProgressLabel;

  /// No description provided for @onboardingFlow5StepProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile is being created'**
  String get onboardingFlow5StepProfile;

  /// No description provided for @onboardingFlow5StepLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language settings are being configured'**
  String get onboardingFlow5StepLanguage;

  /// No description provided for @onboardingFlow5StepAi.
  ///
  /// In en, this message translates to:
  /// **'AI model is being prepared'**
  String get onboardingFlow5StepAi;

  /// No description provided for @preferencesSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Preferences save failed: {error}'**
  String preferencesSaveFailed(Object error);

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @onboardingFlow4Title.
  ///
  /// In en, this message translates to:
  /// **'What features would you like\nin a translation app?'**
  String get onboardingFlow4Title;

  /// No description provided for @onboardingFlow4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Please indicate your preference.'**
  String get onboardingFlow4Subtitle;

  /// No description provided for @onboardingFlow4OptionAccurate.
  ///
  /// In en, this message translates to:
  /// **'Accurate Translation'**
  String get onboardingFlow4OptionAccurate;

  /// No description provided for @onboardingFlow4OptionEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy To Use'**
  String get onboardingFlow4OptionEasy;

  /// No description provided for @onboardingFlow4OptionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Protection'**
  String get onboardingFlow4OptionPrivacy;

  /// No description provided for @onboardingFlow4OptionTeach.
  ///
  /// In en, this message translates to:
  /// **'Teach Me A Language'**
  String get onboardingFlow4OptionTeach;

  /// No description provided for @onboardingFlow4OptionAll.
  ///
  /// In en, this message translates to:
  /// **'All Of Them'**
  String get onboardingFlow4OptionAll;

  /// No description provided for @onboardingFlow3Title.
  ///
  /// In en, this message translates to:
  /// **'Have you used AI\ntranslation before?'**
  String get onboardingFlow3Title;

  /// No description provided for @onboardingFlow3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Please indicate your preference.'**
  String get onboardingFlow3Subtitle;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @onboardingFlow2Title.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get onboardingFlow2Title;

  /// No description provided for @onboardingFlow2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the language you want to translate.\nYour selection affects the entire application.'**
  String get onboardingFlow2Subtitle;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @onboardingFlow1Title.
  ///
  /// In en, this message translates to:
  /// **'What do you use the\ntranslation for most?'**
  String get onboardingFlow1Title;

  /// No description provided for @onboardingFlow1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Please indicate your preference.'**
  String get onboardingFlow1Subtitle;

  /// No description provided for @onboardingFlow1OptionDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily Communication'**
  String get onboardingFlow1OptionDaily;

  /// No description provided for @onboardingFlow1OptionBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business World'**
  String get onboardingFlow1OptionBusiness;

  /// No description provided for @onboardingFlow1OptionLearning.
  ///
  /// In en, this message translates to:
  /// **'Language Learning'**
  String get onboardingFlow1OptionLearning;

  /// No description provided for @onboardingFlow1OptionTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get onboardingFlow1OptionTravel;

  /// No description provided for @onboardingFlow1OptionEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get onboardingFlow1OptionEntertainment;

  /// No description provided for @onboardingFlow1OptionOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get onboardingFlow1OptionOther;

  /// No description provided for @homeWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Let’s start translating into\nyour desired language'**
  String get homeWelcomeTitle;

  /// No description provided for @homeFeatureVoice.
  ///
  /// In en, this message translates to:
  /// **'Instant Voice\nTranslation'**
  String get homeFeatureVoice;

  /// No description provided for @homeFeaturePhoto.
  ///
  /// In en, this message translates to:
  /// **'Instant Photo\nTranslation'**
  String get homeFeaturePhoto;

  /// No description provided for @homeFeatureText.
  ///
  /// In en, this message translates to:
  /// **'Instant Text\nTranslation'**
  String get homeFeatureText;

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActionsTitle;

  /// No description provided for @historyFavoriteTitle.
  ///
  /// In en, this message translates to:
  /// **'History & Favorite'**
  String get historyFavoriteTitle;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTab;

  /// No description provided for @favoriteTab.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favoriteTab;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory;

  /// No description provided for @clearFavorite.
  ///
  /// In en, this message translates to:
  /// **'Clear favorite'**
  String get clearFavorite;

  /// No description provided for @noHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No history found'**
  String get noHistoryFound;

  /// No description provided for @noFavoritesFound.
  ///
  /// In en, this message translates to:
  /// **'No favorites found'**
  String get noFavoritesFound;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @couldNotLoadData.
  ///
  /// In en, this message translates to:
  /// **'Could not load data'**
  String get couldNotLoadData;

  /// No description provided for @clearHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistoryTitle;

  /// No description provided for @clearFavoriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Favorite'**
  String get clearFavoriteTitle;

  /// No description provided for @clearHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to\nclear your history?'**
  String get clearHistoryDescription;

  /// No description provided for @clearFavoriteDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to\nclear your favorite list?'**
  String get clearFavoriteDescription;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @frequentlyTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Terms'**
  String get frequentlyTermsTitle;

  /// No description provided for @couldNotLoadFrequentlyUsedTerms.
  ///
  /// In en, this message translates to:
  /// **'Could not load frequently used terms'**
  String get couldNotLoadFrequentlyUsedTerms;

  /// No description provided for @noFrequentlyUsedTermsFound.
  ///
  /// In en, this message translates to:
  /// **'No frequently used terms found'**
  String get noFrequentlyUsedTermsFound;

  /// No description provided for @microphonePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required.'**
  String get microphonePermissionRequired;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @hiUser.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String hiUser(Object name);

  /// No description provided for @moreFeatures.
  ///
  /// In en, this message translates to:
  /// **'More Features'**
  String get moreFeatures;

  /// No description provided for @frequentlyUsed.
  ///
  /// In en, this message translates to:
  /// **'Frequently Used'**
  String get frequentlyUsed;

  /// No description provided for @reviewMostFrequentlyUsedTerms.
  ///
  /// In en, this message translates to:
  /// **'Review the most\nfrequently used terms.'**
  String get reviewMostFrequentlyUsedTerms;

  /// No description provided for @unlimitedLiveTranslation.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Live Translation'**
  String get unlimitedLiveTranslation;

  /// No description provided for @removeDailyLimits.
  ///
  /// In en, this message translates to:
  /// **'Remove daily limits\non voice and text.'**
  String get removeDailyLimits;

  /// No description provided for @getPremium.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get getPremium;

  /// No description provided for @aiChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChat;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @textCheck.
  ///
  /// In en, this message translates to:
  /// **'Text Check'**
  String get textCheck;

  /// No description provided for @interview.
  ///
  /// In en, this message translates to:
  /// **'Interview'**
  String get interview;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @replyIdeas.
  ///
  /// In en, this message translates to:
  /// **'Reply Ideas'**
  String get replyIdeas;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @signInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign in was cancelled.'**
  String get signInCancelled;

  /// No description provided for @appleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Apple sign in failed.'**
  String get appleSignInFailed;

  /// No description provided for @facebookSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Facebook sign in failed.'**
  String get facebookSignInFailed;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign in failed.'**
  String get googleSignInFailed;

  /// No description provided for @genericSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed: {error}'**
  String genericSignInFailed(Object error);

  /// No description provided for @userSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sync user information.'**
  String get userSyncFailed;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Live Lingola'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue with your preferred account to start translating.'**
  String get loginSubtitle;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueWithFacebook;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @loginLegalPrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get loginLegalPrefix;

  /// No description provided for @termsOfServiceLinkText.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceLinkText;

  /// No description provided for @loginLegalMiddle.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get loginLegalMiddle;

  /// No description provided for @privacyPolicyLinkText.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLinkText;

  /// No description provided for @loginLegalAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get loginLegalAnd;

  /// No description provided for @cookiesPolicyLinkText.
  ///
  /// In en, this message translates to:
  /// **'Cookies Policy'**
  String get cookiesPolicyLinkText;

  /// No description provided for @faqQuestion6.
  ///
  /// In en, this message translates to:
  /// **'Which languages does Live Lingola support?'**
  String get faqQuestion6;

  /// No description provided for @faqAnswer6.
  ///
  /// In en, this message translates to:
  /// **'Our app supports text, voice, and image translation in more than 100 languages.'**
  String get faqAnswer6;

  /// No description provided for @faqQuestion7.
  String get faqQuestion7;

  /// No description provided for @faqAnswer7.
  String get faqAnswer7;

  /// No description provided for @faqQuestion8.
  String get faqQuestion8;

  /// No description provided for @faqAnswer8.
  String get faqAnswer8;

  /// No description provided for @faqQuestion9.
  String get faqQuestion9;

  /// No description provided for @faqAnswer9.
  String get faqAnswer9;

  /// No description provided for @faqQuestion10.
  String get faqQuestion10;

  /// No description provided for @faqAnswer10.
  String get faqAnswer10;

  /// No description provided for @proLabel.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get proLabel;

  /// No description provided for @freeLabel.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get freeLabel;

  /// No description provided for @voicePlanProTitle.
  ///
  /// In en, this message translates to:
  /// **'Real-Time\nTranslation'**
  String get voicePlanProTitle;

  /// No description provided for @voicePlanFreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Translation Machine'**
  String get voicePlanFreeTitle;

  /// No description provided for @highPrecision.
  ///
  /// In en, this message translates to:
  /// **'High Precision'**
  String get highPrecision;

  /// No description provided for @proScenario.
  ///
  /// In en, this message translates to:
  /// **'Pro Scenario'**
  String get proScenario;

  /// No description provided for @automaticTranslation.
  ///
  /// In en, this message translates to:
  /// **'Automatic Translation'**
  String get automaticTranslation;

  /// No description provided for @topLevelModel.
  ///
  /// In en, this message translates to:
  /// **'Top-Level Model'**
  String get topLevelModel;

  /// No description provided for @basicSensitivity.
  ///
  /// In en, this message translates to:
  /// **'Basic Sensitivity'**
  String get basicSensitivity;

  /// No description provided for @simpleScenario.
  ///
  /// In en, this message translates to:
  /// **'Simple Scenario'**
  String get simpleScenario;

  /// No description provided for @touchAndTalk.
  ///
  /// In en, this message translates to:
  /// **'Touch and Talk'**
  String get touchAndTalk;

  /// No description provided for @generalModel.
  ///
  /// In en, this message translates to:
  /// **'General Model'**
  String get generalModel;

  /// No description provided for @startButton.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startButton;

  /// No description provided for @trial60s.
  ///
  /// In en, this message translates to:
  /// **'60s trial'**
  String get trial60s;

  /// No description provided for @aiChatTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChatTitle;

  /// No description provided for @todayUppercase.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get todayUppercase;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typing;

  /// No description provided for @aiChatWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello! I'm Lingola AI. How can I help you today?'**
  String get aiChatWelcomeMessage;

  /// No description provided for @aiChatErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Sorry, something went wrong.\n{error}'**
  String aiChatErrorMessage(Object error);

  /// No description provided for @aiChatChipPromptSushi.
  ///
  /// In en, this message translates to:
  /// **'Best sushi in Tokyo?'**
  String get aiChatChipPromptSushi;

  /// No description provided for @aiChatChipLabelSushi.
  ///
  /// In en, this message translates to:
  /// **'🇯🇵 Best Sushi?'**
  String get aiChatChipLabelSushi;

  /// No description provided for @aiChatChipPromptHotel.
  ///
  /// In en, this message translates to:
  /// **'Any hotel tips for Tokyo?'**
  String get aiChatChipPromptHotel;

  /// No description provided for @aiChatChipLabelHotel.
  ///
  /// In en, this message translates to:
  /// **'🏨 Hotel Tips'**
  String get aiChatChipLabelHotel;

  /// No description provided for @aiChatChipPromptTransit.
  ///
  /// In en, this message translates to:
  /// **'Can you explain Tokyo transit?'**
  String get aiChatChipPromptTransit;

  /// No description provided for @aiChatChipLabelTransit.
  ///
  /// In en, this message translates to:
  /// **'🚇 Transit Guide'**
  String get aiChatChipLabelTransit;

  /// No description provided for @expertGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get expertGeneral;

  /// No description provided for @expertAutoSelection.
  ///
  /// In en, this message translates to:
  /// **'Auto-Selection'**
  String get expertAutoSelection;

  /// No description provided for @expertGourmet.
  ///
  /// In en, this message translates to:
  /// **'Gourmet'**
  String get expertGourmet;

  /// No description provided for @expertShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get expertShopping;

  /// No description provided for @expertBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get expertBusiness;

  /// No description provided for @expertTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get expertTravel;

  /// No description provided for @expertDating.
  ///
  /// In en, this message translates to:
  /// **'Dating'**
  String get expertDating;

  /// No description provided for @expertGames.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get expertGames;

  /// No description provided for @expertHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get expertHealth;

  /// No description provided for @expertLaw.
  ///
  /// In en, this message translates to:
  /// **'Law'**
  String get expertLaw;

  /// No description provided for @expertArt.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get expertArt;

  /// No description provided for @expertFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get expertFinance;

  /// No description provided for @expertTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get expertTechnology;

  /// No description provided for @expertNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get expertNews;

  /// No description provided for @translated.
  ///
  /// In en, this message translates to:
  /// **'Translated'**
  String get translated;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get original;

  /// No description provided for @yesterday.
  String get yesterday;

  /// No description provided for @noNotifications.
  String get noNotifications;

  /// No description provided for @notificationNewTranslationReadyTitle.
  String get notificationNewTranslationReadyTitle;

  /// No description provided for @notificationNewTranslationReadyBody.
  String get notificationNewTranslationReadyBody;

  /// No description provided for @notificationTime10MinAgo.
  String get notificationTime10MinAgo;

  /// No description provided for @notificationSpecialOfferTitle.
  String get notificationSpecialOfferTitle;

  /// No description provided for @notificationSpecialOfferBody.
  String get notificationSpecialOfferBody;

  /// No description provided for @notificationTime2hAgo.
  String get notificationTime2hAgo;

  /// No description provided for @notificationSeeOpportunity.
  String get notificationSeeOpportunity;

  /// No description provided for @notificationAiChatTitle.
  String get notificationAiChatTitle;

  /// No description provided for @notificationAiChatBody.
  String get notificationAiChatBody;

  /// No description provided for @notificationTimeJustNow.
  String get notificationTimeJustNow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'it',
        'ja',
        'ko',
        'pt',
        'ru',
        'tr'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
