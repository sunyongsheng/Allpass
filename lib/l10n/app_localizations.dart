import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @allpass.
  ///
  /// In en, this message translates to:
  /// **'Allpass'**
  String get allpass;

  /// No description provided for @appError.
  ///
  /// In en, this message translates to:
  /// **'Occurs error'**
  String get appError;

  /// No description provided for @appErrorHint1.
  ///
  /// In en, this message translates to:
  /// **'App occurs unexpected error, please report to author'**
  String get appErrorHint1;

  /// No description provided for @appErrorHint2.
  ///
  /// In en, this message translates to:
  /// **'Please see below for the error message. Kindly take a screenshot and send it to the email address sys6511@126.com.'**
  String get appErrorHint2;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// Text on LoginPage Button
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// Title on LoginPage
  ///
  /// In en, this message translates to:
  /// **'Unlock Allpass'**
  String get unlockAllpass;

  /// Hint for user to input master password
  ///
  /// In en, this message translates to:
  /// **'Please input master password'**
  String get pleaseInputMainPassword;

  /// No description provided for @useBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Use Biometrics to unlock'**
  String get useBiometrics;

  /// No description provided for @notEnableBiometricsYet.
  ///
  /// In en, this message translates to:
  /// **'You have not yet enabled biometric recognition'**
  String get notEnableBiometricsYet;

  /// The user has entered the password incorrectly five times in a row, and the APP has been locked. If the user clicks the unlock button again at this time, the following message will appear:
  ///
  /// In en, this message translates to:
  /// **'Locked, {lockSeconds} seconds remaining'**
  String lockingRemains(int lockSeconds);

  /// No description provided for @errorExceedThreshold.
  ///
  /// In en, this message translates to:
  /// **'Locked for 30 seconds due to five consecutive errors'**
  String get errorExceedThreshold;

  /// No description provided for @clickToUseBiometrics.
  ///
  /// In en, this message translates to:
  /// **'To unlock using biometrics, simply tap here'**
  String get clickToUseBiometrics;

  /// No description provided for @usePassword.
  ///
  /// In en, this message translates to:
  /// **'Use password to unlock'**
  String get usePassword;

  /// No description provided for @inputMainPasswordTimingHint.
  ///
  /// In en, this message translates to:
  /// **'To ensure you don\'t forget your master password, Allpass will periodically prompt you to enter it'**
  String get inputMainPasswordTimingHint;

  /// No description provided for @verificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification successful'**
  String get verificationSuccess;

  /// No description provided for @mainPasswordErrorHint.
  ///
  /// In en, this message translates to:
  /// **'It seems like you may have forgotten your master password'**
  String get mainPasswordErrorHint;

  /// No description provided for @biometricsRecognizedFailed.
  ///
  /// In en, this message translates to:
  /// **'Recognition failed, please try again'**
  String get biometricsRecognizedFailed;

  /// No description provided for @pleaseInputMainPasswordFirst.
  ///
  /// In en, this message translates to:
  /// **'Please input master password first'**
  String get pleaseInputMainPasswordFirst;

  /// No description provided for @unlockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Unlock successfully'**
  String get unlockSuccess;

  /// No description provided for @mainPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Main password incorrect, has been entered incorrectly {inputErrorTimes} times, consecutive errors exceeding five times will result in a 30-second lockout'**
  String mainPasswordError(int inputErrorTimes);

  /// No description provided for @notSetupYet.
  ///
  /// In en, this message translates to:
  /// **'Allpass has not been set up yet, please set it up first'**
  String get notSetupYet;

  /// No description provided for @appHasForceLock.
  ///
  /// In en, this message translates to:
  /// **'Allpass has been locked, please use password to unlock'**
  String get appHasForceLock;

  /// No description provided for @setupAllpass.
  ///
  /// In en, this message translates to:
  /// **'Setup Allpass'**
  String get setupAllpass;

  /// No description provided for @pleaseInputAgain.
  ///
  /// In en, this message translates to:
  /// **'Please input again'**
  String get pleaseInputAgain;

  /// No description provided for @setup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup;

  /// No description provided for @passwordNotSame.
  ///
  /// In en, this message translates to:
  /// **'The two passwords are not the same'**
  String get passwordNotSame;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Main password length must be greater than 6'**
  String get passwordTooShort;

  /// No description provided for @setupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Setup successfully'**
  String get setupSuccess;

  /// No description provided for @alreadySetup.
  ///
  /// In en, this message translates to:
  /// **'Already setup, only allow to setup once'**
  String get alreadySetup;

  /// No description provided for @serviceTerms.
  ///
  /// In en, this message translates to:
  /// **'Service Terms'**
  String get serviceTerms;

  /// No description provided for @confirmServiceTerms.
  ///
  /// In en, this message translates to:
  /// **'Agree and continue'**
  String get confirmServiceTerms;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwords.
  ///
  /// In en, this message translates to:
  /// **'passwords'**
  String get passwords;

  /// No description provided for @addPasswordItem.
  ///
  /// In en, this message translates to:
  /// **'Add Password Item'**
  String get addPasswordItem;

  /// No description provided for @passwordEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Here stores your password information, such as\nGoogle account, Twitter account, etc.'**
  String get passwordEmptyHint;

  /// No description provided for @selectOnePasswordAtLeast.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one password item'**
  String get selectOnePasswordAtLeast;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deletePasswordsWarning.
  ///
  /// In en, this message translates to:
  /// **'You will delete {count} password items, continue to delete?'**
  String deletePasswordsWarning(int count);

  /// No description provided for @deletePasswordsSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count} password(s) deleted'**
  String deletePasswordsSuccess(int count);

  /// No description provided for @movePasswordsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Moved {count} password(s) to {folder} folder'**
  String movePasswordsSuccess(int count, String folder);

  /// No description provided for @searchButton.
  ///
  /// In en, this message translates to:
  /// **'Search {type}'**
  String searchButton(String type);

  /// No description provided for @emptyDataHint.
  ///
  /// In en, this message translates to:
  /// **'Oops, it seems like there\'s nothing here!'**
  String get emptyDataHint;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'cards'**
  String get cards;

  /// No description provided for @addCardItem.
  ///
  /// In en, this message translates to:
  /// **'Add Card Item'**
  String get addCardItem;

  /// No description provided for @cardEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'This is where your card information such as ID cards, bank cards, or VIP cards are stored.'**
  String get cardEmptyHint;

  /// No description provided for @selectOneCardAtLeast.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one card item'**
  String get selectOneCardAtLeast;

  /// No description provided for @deleteCardsWarning.
  ///
  /// In en, this message translates to:
  /// **'You will delete {count} card items, continue to delete?'**
  String deleteCardsWarning(int count);

  /// No description provided for @deleteCardsSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count} card(s) deleted'**
  String deleteCardsSuccess(int count);

  /// No description provided for @moveCardsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Moved {count} card(s) to {folder} folder'**
  String moveCardsSuccess(int count, String folder);

  /// No description provided for @unknownErrorOccur.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred.'**
  String get unknownErrorOccur;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @accountCopied.
  ///
  /// In en, this message translates to:
  /// **'Account has been copied to clipboard'**
  String get accountCopied;

  /// No description provided for @passwordCopied.
  ///
  /// In en, this message translates to:
  /// **'Password has been copied to clipboard'**
  String get passwordCopied;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get url;

  /// No description provided for @urlCopied.
  ///
  /// In en, this message translates to:
  /// **'Link has been copied to clipboard'**
  String get urlCopied;

  /// No description provided for @ownerApp.
  ///
  /// In en, this message translates to:
  /// **'Belongs to app'**
  String get ownerApp;

  /// No description provided for @openAppFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to open app, please ensure that the app is installed'**
  String get openAppFailed;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @emptyNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get emptyNotes;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'tag'**
  String get label;

  /// No description provided for @labels.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get labels;

  /// No description provided for @accountPassword.
  ///
  /// In en, this message translates to:
  /// **'Account: {account}\nPassword: {password}'**
  String accountPassword(String account, String password);

  /// No description provided for @accountPasswordCopied.
  ///
  /// In en, this message translates to:
  /// **'Account and Password has been copied to clipboard'**
  String get accountPasswordCopied;

  /// No description provided for @deletePasswordWaring.
  ///
  /// In en, this message translates to:
  /// **'You are about to permanently delete this password item. continue to delete?'**
  String get deletePasswordWaring;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Delete Successfully'**
  String get deleteSuccess;

  /// No description provided for @viewPassword.
  ///
  /// In en, this message translates to:
  /// **'Password Detail'**
  String get viewPassword;

  /// No description provided for @emptyLabel.
  ///
  /// In en, this message translates to:
  /// **'No tags'**
  String get emptyLabel;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @viewCard.
  ///
  /// In en, this message translates to:
  /// **'Card Detail'**
  String get viewCard;

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get ownerName;

  /// No description provided for @nameCopied.
  ///
  /// In en, this message translates to:
  /// **'Name has been copied to clipboard'**
  String get nameCopied;

  /// No description provided for @cardId.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardId;

  /// No description provided for @cardIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Card number has been copied to clipboard'**
  String get cardIdCopied;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberCopied.
  ///
  /// In en, this message translates to:
  /// **'Phone number has been copied to clipboard'**
  String get phoneNumberCopied;

  /// No description provided for @deleteCardWarning.
  ///
  /// In en, this message translates to:
  /// **'You are about to permanently delete this card item. continue to delete?'**
  String get deleteCardWarning;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get createPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Edit Password'**
  String get updatePassword;

  /// No description provided for @createSuccess.
  ///
  /// In en, this message translates to:
  /// **'Create successfully'**
  String get createSuccess;

  /// No description provided for @updateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update successfully'**
  String get updateSuccess;

  /// No description provided for @upsertPasswordRule.
  ///
  /// In en, this message translates to:
  /// **'Name, Account and Password can\'t be empty'**
  String get upsertPasswordRule;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'folder'**
  String get folder;

  /// No description provided for @folderTitle.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folderTitle;

  /// No description provided for @createLabelSuccess.
  ///
  /// In en, this message translates to:
  /// **'Create Tag {tag} successfully'**
  String createLabelSuccess(String tag);

  /// No description provided for @labelAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Tag {tag} already exists'**
  String labelAlreadyExists(String tag);

  /// No description provided for @setToNone.
  ///
  /// In en, this message translates to:
  /// **'Set to none'**
  String get setToNone;

  /// No description provided for @addNotes.
  ///
  /// In en, this message translates to:
  /// **'Add notes'**
  String get addNotes;

  /// No description provided for @passwordGenerator.
  ///
  /// In en, this message translates to:
  /// **'Password Generator'**
  String get passwordGenerator;

  /// No description provided for @symbols.
  ///
  /// In en, this message translates to:
  /// **'Symbols'**
  String get symbols;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @pleaseSelectOneItemAtLeast.
  ///
  /// In en, this message translates to:
  /// **'Please select one item at least'**
  String get pleaseSelectOneItemAtLeast;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @createCard.
  ///
  /// In en, this message translates to:
  /// **'Create Card'**
  String get createCard;

  /// No description provided for @updateCard.
  ///
  /// In en, this message translates to:
  /// **'Update Card'**
  String get updateCard;

  /// No description provided for @cardPasswordEmptyAutoGen.
  ///
  /// In en, this message translates to:
  /// **'No password entered, automatically initialized as 00000'**
  String get cardPasswordEmptyAutoGen;

  /// No description provided for @upsertCardRule.
  ///
  /// In en, this message translates to:
  /// **'Owner Name and Card Number can\'t be empty'**
  String get upsertCardRule;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @mainPasswordManager.
  ///
  /// In en, this message translates to:
  /// **'Primary account management'**
  String get mainPasswordManager;

  /// No description provided for @biometricAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication'**
  String get biometricAuthentication;

  /// No description provided for @enableBiometricSuccess.
  ///
  /// In en, this message translates to:
  /// **'Enable biometric authentication successfully'**
  String get enableBiometricSuccess;

  /// No description provided for @disableBiometricSuccess.
  ///
  /// In en, this message translates to:
  /// **'Disable biometric authentication successfully'**
  String get disableBiometricSuccess;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric recognition is unavailable, please go to system settings to enable it and retry'**
  String get biometricNotAvailable;

  /// No description provided for @authorizationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authorization failed'**
  String get authorizationFailed;

  /// No description provided for @biometricNotSupport.
  ///
  /// In en, this message translates to:
  /// **'Your device not support biometric'**
  String get biometricNotSupport;

  /// No description provided for @autoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock'**
  String get autoLock;

  /// No description provided for @autoLockDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock app when quit'**
  String get autoLockDialogTitle;

  /// No description provided for @autoLockImmediate.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get autoLockImmediate;

  /// No description provided for @autoLock30s.
  ///
  /// In en, this message translates to:
  /// **'In 30s'**
  String get autoLock30s;

  /// No description provided for @autoLockDisable.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get autoLockDisable;

  /// No description provided for @longPressToCopy.
  ///
  /// In en, this message translates to:
  /// **'Long Press to Copy'**
  String get longPressToCopy;

  /// No description provided for @appTheme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get appTheme;

  /// No description provided for @labelManager.
  ///
  /// In en, this message translates to:
  /// **'Tag Management'**
  String get labelManager;

  /// No description provided for @folderManager.
  ///
  /// In en, this message translates to:
  /// **'Folder Management'**
  String get folderManager;

  /// No description provided for @webDavSync.
  ///
  /// In en, this message translates to:
  /// **'WebDAV Sync'**
  String get webDavSync;

  /// No description provided for @importExport.
  ///
  /// In en, this message translates to:
  /// **'Import/Export'**
  String get importExport;

  /// No description provided for @autofill.
  ///
  /// In en, this message translates to:
  /// **'Autofill Service'**
  String get autofill;

  /// No description provided for @shareToFriends.
  ///
  /// In en, this message translates to:
  /// **'Share Allpass'**
  String get shareToFriends;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @checkUpdate.
  ///
  /// In en, this message translates to:
  /// **'Check Update'**
  String get checkUpdate;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @shareAllpassDesc.
  ///
  /// In en, this message translates to:
  /// **'[Allpass] is a simple and easy-to-use tool for managing private information. [DownloadUrl] {downloadUrl}'**
  String shareAllpassDesc(String downloadUrl);

  /// No description provided for @shareAllpassSubject.
  ///
  /// In en, this message translates to:
  /// **'Software recommendation - Allpass'**
  String get shareAllpassSubject;

  /// No description provided for @pleaseSelect.
  ///
  /// In en, this message translates to:
  /// **'Please Select an Item'**
  String get pleaseSelect;

  /// No description provided for @authorizeToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Authorize to unlock Allpass'**
  String get authorizeToUnlock;

  /// No description provided for @gotoSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get gotoSettings;

  /// No description provided for @iosGoToSettingsDescFace.
  ///
  /// In en, this message translates to:
  /// **'Face ID is currently disabled. Please go to settings to enable Face ID and try again'**
  String get iosGoToSettingsDescFace;

  /// No description provided for @iosGoToSettingsDescFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint unlock is currently disabled. Please go to settings to enable fingerprint unlock and try again'**
  String get iosGoToSettingsDescFingerprint;

  /// No description provided for @iosGoToSettingsDescIris.
  ///
  /// In en, this message translates to:
  /// **'Biometric recognition is currently disabled. Please go to settings to enable it and try again'**
  String get iosGoToSettingsDescIris;

  /// No description provided for @iosGoToSettingsDescDefault.
  ///
  /// In en, this message translates to:
  /// **'Biometric authorization is currently disabled. Please go to settings to enable Touch ID or Face ID and try again'**
  String get iosGoToSettingsDescDefault;

  /// No description provided for @iosLogoutFace.
  ///
  /// In en, this message translates to:
  /// **'Face ID has been disabled. Please lock and unlock your device to enable Face ID'**
  String get iosLogoutFace;

  /// No description provided for @iosLogoutFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Touch ID has been disabled. Please lock and unlock your device to enable Touch ID'**
  String get iosLogoutFingerprint;

  /// No description provided for @iosLogoutIris.
  ///
  /// In en, this message translates to:
  /// **'Biometric recognition has been disabled. Please lock and unlock your device to enable biometric recognition'**
  String get iosLogoutIris;

  /// No description provided for @androidGoToSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint unlock is currently disabled. Please go to settings to enable it and try again'**
  String get androidGoToSettingsDesc;

  /// No description provided for @biometricRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric recognition is not enabled yet'**
  String get biometricRequiredTitle;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Please verify'**
  String get signInTitle;

  /// No description provided for @biometricHint.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint to unlock'**
  String get biometricHint;

  /// No description provided for @modifyMainPassword.
  ///
  /// In en, this message translates to:
  /// **'Modify master password'**
  String get modifyMainPassword;

  /// No description provided for @inputMainPasswordTiming.
  ///
  /// In en, this message translates to:
  /// **'Regularly require master password'**
  String get inputMainPasswordTiming;

  /// No description provided for @secretKeyUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update encrypt secret key'**
  String get secretKeyUpdate;

  /// No description provided for @clearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get clearAllData;

  /// No description provided for @lockAllpass.
  ///
  /// In en, this message translates to:
  /// **'Lock Allpass'**
  String get lockAllpass;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @sevenDays.
  ///
  /// In en, this message translates to:
  /// **'7 Days'**
  String get sevenDays;

  /// No description provided for @tenDays.
  ///
  /// In en, this message translates to:
  /// **'10 Days'**
  String get tenDays;

  /// No description provided for @fifteenDays.
  ///
  /// In en, this message translates to:
  /// **'15 Days'**
  String get fifteenDays;

  /// No description provided for @thirtyDays.
  ///
  /// In en, this message translates to:
  /// **'30 Days'**
  String get thirtyDays;

  /// No description provided for @nDays.
  ///
  /// In en, this message translates to:
  /// **'{n} Days'**
  String nDays(int n);

  /// No description provided for @confirmSelect.
  ///
  /// In en, this message translates to:
  /// **'Confirm Select'**
  String get confirmSelect;

  /// No description provided for @selectNeverWarning.
  ///
  /// In en, this message translates to:
  /// **'After selecting this option, Allpass will no longer regularly ask you to enter the master password. Please keep your master password safe'**
  String get selectNeverWarning;

  /// No description provided for @confirmClearAll.
  ///
  /// In en, this message translates to:
  /// **'Confirm Clear'**
  String get confirmClearAll;

  /// No description provided for @clearAllWaring.
  ///
  /// In en, this message translates to:
  /// **'This operation will clear all App data and can\'t rollback, continue?'**
  String get clearAllWaring;

  /// No description provided for @clearAllSuccess.
  ///
  /// In en, this message translates to:
  /// **'Clear all data successfully'**
  String get clearAllSuccess;

  /// No description provided for @mainPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Master password is incorrect'**
  String get mainPasswordIncorrect;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Original Password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @pleaseInputOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Please input original password'**
  String get pleaseInputOldPassword;

  /// No description provided for @pleaseInputNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please input new password'**
  String get pleaseInputNewPassword;

  /// No description provided for @modifySuccess.
  ///
  /// In en, this message translates to:
  /// **'Modify successfully'**
  String get modifySuccess;

  /// No description provided for @modifyPasswordFail.
  ///
  /// In en, this message translates to:
  /// **'Password is less than 6 characters or the two password entries do not match'**
  String get modifyPasswordFail;

  /// No description provided for @oldPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'The entered original password is incorrect!'**
  String get oldPasswordIncorrect;

  /// No description provided for @secretKeyUpdateHelp1.
  ///
  /// In en, this message translates to:
  /// **'Please read carefully'**
  String get secretKeyUpdateHelp1;

  /// No description provided for @secretKeyUpdateHelp2.
  ///
  /// In en, this message translates to:
  /// **'Allpass 1.5.0 and later versions use a new key storage method'**
  String get secretKeyUpdateHelp2;

  /// No description provided for @secretKeyUpdateHelp3.
  ///
  /// In en, this message translates to:
  /// **'Allpass will generate a unique key for each user and store it in a system-specific area. This means that even if Allpass is decompiled and the data in the database is obtained through some means, it cannot be easily decrypted'**
  String get secretKeyUpdateHelp3;

  /// No description provided for @secretKeyUpdateHelp4.
  ///
  /// In en, this message translates to:
  /// **'After upgrading, all password encryption and decryption will rely on the newly generated key. Please '**
  String get secretKeyUpdateHelp4;

  /// No description provided for @secretKeyUpdateHelp5.
  ///
  /// In en, this message translates to:
  /// **'keep the newly generated key safe'**
  String get secretKeyUpdateHelp5;

  /// No description provided for @secretKeyUpdateHelp6.
  ///
  /// In en, this message translates to:
  /// **'If you have enabled WebDAV synchronization, your data can still be accessed using the encryption key, even if you uninstall Allpass and the backup files are encrypted'**
  String get secretKeyUpdateHelp6;

  /// No description provided for @secretKeyUpdateHelp7.
  ///
  /// In en, this message translates to:
  /// **'The time required for the upgrade is relatively short, and may vary depending on the device'**
  String get secretKeyUpdateHelp7;

  /// No description provided for @secretKeyUpdateHelp8.
  ///
  /// In en, this message translates to:
  /// **'Please do not exit the program during the upgrade process, as this may cause data loss!'**
  String get secretKeyUpdateHelp8;

  /// No description provided for @secretKeyUpdateHelp9.
  ///
  /// In en, this message translates to:
  /// **'***************** ATTENTION *****************'**
  String get secretKeyUpdateHelp9;

  /// No description provided for @secretKeyUpdateHelp10.
  ///
  /// In en, this message translates to:
  /// **'If you have used Allpass for WebDAV backup, and the \'Encrypt level\' is not the \'Not encrypted\', the old backup files will '**
  String get secretKeyUpdateHelp10;

  /// No description provided for @secretKeyUpdateHelp11.
  ///
  /// In en, this message translates to:
  /// **'no longer '**
  String get secretKeyUpdateHelp11;

  /// No description provided for @secretKeyUpdateHelp12.
  ///
  /// In en, this message translates to:
  /// **'be usable after the encryption key updated. (Local data will not be affected)'**
  String get secretKeyUpdateHelp12;

  /// No description provided for @secretKeyUpdateHelp13.
  ///
  /// In en, this message translates to:
  /// **'For the sake of data security, we still recommend backing up your data by \'Export to CSV File\' function before upgrading!'**
  String get secretKeyUpdateHelp13;

  /// No description provided for @secretKeyUpdateHelp14.
  ///
  /// In en, this message translates to:
  /// **'You can directly edit the input box below and manually input a custom key (32 characters)'**
  String get secretKeyUpdateHelp14;

  /// No description provided for @secretKeyUpdateHint.
  ///
  /// In en, this message translates to:
  /// **'The generated key is displayed here'**
  String get secretKeyUpdateHint;

  /// No description provided for @generateSecretKey.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generateSecretKey;

  /// No description provided for @generateSecretKeyDone.
  ///
  /// In en, this message translates to:
  /// **'Generation complete, please keep the new key safe (long press to copy)'**
  String get generateSecretKeyDone;

  /// No description provided for @startUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Start Upgrade'**
  String get startUpgrade;

  /// No description provided for @upgradeDone.
  ///
  /// In en, this message translates to:
  /// **'Upgrade complete'**
  String get upgradeDone;

  /// No description provided for @pleaseGenerateKeyFirst.
  ///
  /// In en, this message translates to:
  /// **'Please generate a key first'**
  String get pleaseGenerateKeyFirst;

  /// No description provided for @secretKeyLengthRequire.
  ///
  /// In en, this message translates to:
  /// **'The key length must be 32 characters'**
  String get secretKeyLengthRequire;

  /// No description provided for @secretKeyUpgradeResult.
  ///
  /// In en, this message translates to:
  /// **'Upgraded {passwordCount} password items and {cardCount} card items'**
  String secretKeyUpgradeResult(int passwordCount, int cardCount);

  /// No description provided for @secretKeyUpgradeFailed.
  ///
  /// In en, this message translates to:
  /// **'Upgrade failed: {error}'**
  String secretKeyUpgradeFailed(Object error);

  /// No description provided for @feedbackPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you think'**
  String get feedbackPlaceholder;

  /// No description provided for @feedbackContact.
  ///
  /// In en, this message translates to:
  /// **'Please enter your contact information (optional)'**
  String get feedbackContact;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting, please wait'**
  String get submitting;

  /// No description provided for @feedbackContentEmptyWarning.
  ///
  /// In en, this message translates to:
  /// **'Please input your feedback'**
  String get feedbackContentEmptyWarning;

  /// No description provided for @feedbackContentTooLong.
  ///
  /// In en, this message translates to:
  /// **'The feedback content must be less than 1000 characters!'**
  String get feedbackContentTooLong;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'A new version is available for download! Latest version {channel} V{version}'**
  String updateAvailable(String? channel, String? version);

  /// No description provided for @alreadyLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'Your version is up-to-date! {channel} V{version}'**
  String alreadyLatestVersion(String? channel, String? version);

  /// No description provided for @updateContent.
  ///
  /// In en, this message translates to:
  /// **'Update Log: '**
  String get updateContent;

  /// No description provided for @recentlyUpdateContent.
  ///
  /// In en, this message translates to:
  /// **'Recent update log: '**
  String get recentlyUpdateContent;

  /// No description provided for @networkErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Network error: {message}'**
  String networkErrorMsg(String? message);

  /// No description provided for @networkErrorHelp.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred due to network issues. If you have confirmed that your network is not the problem, then it may be due to the following reasons:\n'**
  String get networkErrorHelp;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error: {message}'**
  String unknownError(String? message);

  /// No description provided for @unknownErrorHelp.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred during the check process! Below is the error message, please take a screenshot and send it to sys6511@126.com\n'**
  String get unknownErrorHelp;

  /// No description provided for @downloadUpdate.
  ///
  /// In en, this message translates to:
  /// **'Download Update'**
  String get downloadUpdate;

  /// No description provided for @remindMeLatter.
  ///
  /// In en, this message translates to:
  /// **'Remind me later'**
  String get remindMeLatter;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get themeColorBlue;

  /// No description provided for @themeColorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get themeColorRed;

  /// No description provided for @themeColorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get themeColorTeal;

  /// No description provided for @themeColorDeepPurple.
  ///
  /// In en, this message translates to:
  /// **'Deep Purple'**
  String get themeColorDeepPurple;

  /// No description provided for @themeColorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get themeColorOrange;

  /// No description provided for @themeColorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get themeColorPink;

  /// No description provided for @themeColorBlueGrey.
  ///
  /// In en, this message translates to:
  /// **'Blue Grey'**
  String get themeColorBlueGrey;

  /// No description provided for @selectExportType.
  ///
  /// In en, this message translates to:
  /// **'Select Export Type'**
  String get selectExportType;

  /// No description provided for @exportConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Export'**
  String get exportConfirm;

  /// No description provided for @exportPasswordConfirmWarning.
  ///
  /// In en, this message translates to:
  /// **'The exported password will be displayed in plain text. Please keep it secure'**
  String get exportPasswordConfirmWarning;

  /// No description provided for @exportCardConfirmWarning.
  ///
  /// In en, this message translates to:
  /// **'The exported card items will be displayed in plain text. Please keep it secure'**
  String get exportCardConfirmWarning;

  /// No description provided for @passwordAndCard.
  ///
  /// In en, this message translates to:
  /// **'Both Password and Card'**
  String get passwordAndCard;

  /// No description provided for @exportAllConfirmWarning.
  ///
  /// In en, this message translates to:
  /// **'The exported data will be displayed in plain text. Please keep it secure'**
  String get exportAllConfirmWarning;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export Failed: {message}'**
  String exportFailed(String? message);

  /// No description provided for @importFromChrome.
  ///
  /// In en, this message translates to:
  /// **'Import from Chrome'**
  String get importFromChrome;

  /// No description provided for @importFromCsv.
  ///
  /// In en, this message translates to:
  /// **'Import from CSV File'**
  String get importFromCsv;

  /// No description provided for @importFromClipboard.
  ///
  /// In en, this message translates to:
  /// **'Import from Clipboard'**
  String get importFromClipboard;

  /// No description provided for @exportToCsv.
  ///
  /// In en, this message translates to:
  /// **'Export to CSV File'**
  String get exportToCsv;

  /// No description provided for @selectImportType.
  ///
  /// In en, this message translates to:
  /// **'Select Import Type'**
  String get selectImportType;

  /// No description provided for @importRecordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Importing {count} records'**
  String importRecordSuccess(int count);

  /// No description provided for @importFailedNotCsv.
  ///
  /// In en, this message translates to:
  /// **'Import failed, please make sure the CSV file is exported by Allpass'**
  String get importFailedNotCsv;

  /// No description provided for @importCanceled.
  ///
  /// In en, this message translates to:
  /// **'Import canceled'**
  String get importCanceled;

  /// No description provided for @importFromClipboardHelp1.
  ///
  /// In en, this message translates to:
  /// **'This feature helps you easily import passwords previously saved in Notepad to Allpass;\n'**
  String get importFromClipboardHelp1;

  /// No description provided for @importFromClipboardHelp2.
  ///
  /// In en, this message translates to:
  /// **'The name is a mnemonic for the password item, you can give it any name you like to help you identify what this record is about;\n'**
  String get importFromClipboardHelp2;

  /// No description provided for @importFromClipboardHelp3.
  ///
  /// In en, this message translates to:
  /// **'The account is the username used for login, which may be a phone number, email, or other account you have set up;\n'**
  String get importFromClipboardHelp3;

  /// No description provided for @importFromClipboardHelp4.
  ///
  /// In en, this message translates to:
  /// **'The website address can help Allpass correctly fill in your password on the website, usually the URL address of the website login page;\n'**
  String get importFromClipboardHelp4;

  /// No description provided for @importFromClipboardHelp5.
  ///
  /// In en, this message translates to:
  /// **'Please use a \'space\' as the separator between the two fields, so that Allpass can correctly distinguish which one is the username and which one is the password;\n'**
  String get importFromClipboardHelp5;

  /// No description provided for @importFromClipboardHelp6.
  ///
  /// In en, this message translates to:
  /// **'If you have selected the last two import format, please enter the uniform username. If there are multiple usernames, they can be imported in several times'**
  String get importFromClipboardHelp6;

  /// No description provided for @importFromClipboardSelectFormat.
  ///
  /// In en, this message translates to:
  /// **'Please select import password item format(use \'space\' as the separator)'**
  String get importFromClipboardSelectFormat;

  /// No description provided for @importFromClipboardFormat1.
  ///
  /// In en, this message translates to:
  /// **'Name Account Password WebUrl/Link'**
  String get importFromClipboardFormat1;

  /// No description provided for @importFromClipboardFormat2.
  ///
  /// In en, this message translates to:
  /// **'Name Account Password'**
  String get importFromClipboardFormat2;

  /// No description provided for @importFromClipboardFormat3.
  ///
  /// In en, this message translates to:
  /// **'Account Password WebUrl/Link'**
  String get importFromClipboardFormat3;

  /// No description provided for @importFromClipboardFormat4.
  ///
  /// In en, this message translates to:
  /// **'Account Password'**
  String get importFromClipboardFormat4;

  /// No description provided for @importFromClipboardFormat5.
  ///
  /// In en, this message translates to:
  /// **'Name Password'**
  String get importFromClipboardFormat5;

  /// No description provided for @importFromClipboardFormat6.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get importFromClipboardFormat6;

  /// No description provided for @importFromClipboardFormatHint.
  ///
  /// In en, this message translates to:
  /// **'Please input account(username) here'**
  String get importFromClipboardFormatHint;

  /// No description provided for @importFromClipboardFormatHint2.
  ///
  /// In en, this message translates to:
  /// **'Please input account(username)'**
  String get importFromClipboardFormatHint2;

  /// No description provided for @importFromClipboardFormatHint3.
  ///
  /// In en, this message translates to:
  /// **'Please input records'**
  String get importFromClipboardFormatHint3;

  /// No description provided for @pasteDataHere.
  ///
  /// In en, this message translates to:
  /// **'Paste your data here'**
  String get pasteDataHere;

  /// No description provided for @startImport.
  ///
  /// In en, this message translates to:
  /// **'Start import'**
  String get startImport;

  /// No description provided for @importing.
  ///
  /// In en, this message translates to:
  /// **'Importing, please wait'**
  String get importing;

  /// No description provided for @importComplete.
  ///
  /// In en, this message translates to:
  /// **'Import completed'**
  String get importComplete;

  /// No description provided for @recordFormatIncorrect.
  ///
  /// In en, this message translates to:
  /// **'The format of a {n} row\'s record is incorrect'**
  String recordFormatIncorrect(int n);

  /// No description provided for @importFromExternalPreview.
  ///
  /// In en, this message translates to:
  /// **'Imports Preview'**
  String get importFromExternalPreview;

  /// No description provided for @importFromExternalTips.
  ///
  /// In en, this message translates to:
  /// **'Slide to delete item'**
  String get importFromExternalTips;

  /// No description provided for @confirmImport.
  ///
  /// In en, this message translates to:
  /// **'Continue import'**
  String get confirmImport;

  /// No description provided for @categoryManagement.
  ///
  /// In en, this message translates to:
  /// **'{categoryName} Management'**
  String categoryManagement(String categoryName);

  /// No description provided for @createCategory.
  ///
  /// In en, this message translates to:
  /// **'Create {categoryName}'**
  String createCategory(String categoryName);

  /// No description provided for @createCategorySuccess.
  ///
  /// In en, this message translates to:
  /// **'Create {categoryName} {name} successfully'**
  String createCategorySuccess(String categoryName, String name);

  /// No description provided for @categoryAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'{categoryName} {name} already exists'**
  String categoryAlreadyExists(String categoryName, String name);

  /// No description provided for @folderDisallowModify.
  ///
  /// In en, this message translates to:
  /// **'This folded is not allowed to modify'**
  String get folderDisallowModify;

  /// No description provided for @updateCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit {categoryName}'**
  String updateCategory(String categoryName);

  /// No description provided for @updateCategorySuccess.
  ///
  /// In en, this message translates to:
  /// **'{categoryName} {name} saved'**
  String updateCategorySuccess(Object categoryName, Object name);

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete {categoryName}'**
  String deleteCategory(String categoryName);

  /// No description provided for @deleteLabelWarning.
  ///
  /// In en, this message translates to:
  /// **'Passwords or cards associated with this tag will also delete this tag, continue to delete?'**
  String get deleteLabelWarning;

  /// No description provided for @deleteFolderWarning.
  ///
  /// In en, this message translates to:
  /// **'This operation will move all passwords and cards in this folder to the \'Default\' folder, continue to delete?'**
  String get deleteFolderWarning;

  /// No description provided for @pleaseInputCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Please input {categoryName} name'**
  String pleaseInputCategoryName(String categoryName);

  /// No description provided for @categoryNameRuleRequire.
  ///
  /// In en, this message translates to:
  /// **'{categoryName} name can\'t contains \',\' \'~\' or \'space\''**
  String categoryNameRuleRequire(String categoryName);

  /// No description provided for @categoryNameNotValid.
  ///
  /// In en, this message translates to:
  /// **'input content is not valid, can\'t contains \',\' \'~\' or \'space\''**
  String get categoryNameNotValid;

  /// No description provided for @categoryNameNotAllowEmpty.
  ///
  /// In en, this message translates to:
  /// **'input content is not valid'**
  String get categoryNameNotAllowEmpty;

  /// No description provided for @autofillEnableAllpass.
  ///
  /// In en, this message translates to:
  /// **'Allpass is already your autofill service'**
  String get autofillEnableAllpass;

  /// No description provided for @autofillDisableAllpass.
  ///
  /// In en, this message translates to:
  /// **'Allpass is not your autofill service yet'**
  String get autofillDisableAllpass;

  /// No description provided for @autofillHelp.
  ///
  /// In en, this message translates to:
  /// **'When you enter a password in the application, the autofill service will automatically provide possible password item matching options for you to choose from. Stored password items will be considered as candidates when they meet one of the following conditions:\n\n1. The password item belongs to an app that matches the current app;\n2. The name of the password item matches the current app name;\n\nIf you find that the autofill result is not accurate, you can modify the owner app of the password item on the password editing page to help the autofill function match the password more accurately.'**
  String get autofillHelp;

  /// No description provided for @uploadToRemote.
  ///
  /// In en, this message translates to:
  /// **'Sync to server'**
  String get uploadToRemote;

  /// No description provided for @recoverToLocal.
  ///
  /// In en, this message translates to:
  /// **'Restore to local'**
  String get recoverToLocal;

  /// No description provided for @remoteBackupDirectory.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup directory'**
  String get remoteBackupDirectory;

  /// No description provided for @backupFileMethod.
  ///
  /// In en, this message translates to:
  /// **'Backup file method'**
  String get backupFileMethod;

  /// No description provided for @dataMergeMethod.
  ///
  /// In en, this message translates to:
  /// **'Data recovery method'**
  String get dataMergeMethod;

  /// No description provided for @encryptLevel.
  ///
  /// In en, this message translates to:
  /// **'Encryption Level'**
  String get encryptLevel;

  /// No description provided for @logoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutAccount;

  /// No description provided for @confirmUpload.
  ///
  /// In en, this message translates to:
  /// **'Confirm Upload'**
  String get confirmUpload;

  /// No description provided for @confirmUploadWaring.
  ///
  /// In en, this message translates to:
  /// **'Current encryption level is [{encryptLevel}], continue to upload?'**
  String confirmUploadWaring(String encryptLevel);

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading, please wait and try again when it\'s complete'**
  String get uploading;

  /// No description provided for @confirmRecover.
  ///
  /// In en, this message translates to:
  /// **'Confirm Restore'**
  String get confirmRecover;

  /// No description provided for @confirmRecoverWarning.
  ///
  /// In en, this message translates to:
  /// **'Current data recovery method is [{mergeMethod}], continue to restore?'**
  String confirmRecoverWarning(String mergeMethod);

  /// No description provided for @recovering.
  ///
  /// In en, this message translates to:
  /// **'Restoring, please wait and try again when it\'s complete'**
  String get recovering;

  /// No description provided for @recoverV1FileHelp.
  ///
  /// In en, this message translates to:
  /// **'We have detected that an old backup file is being restored. Please select the type of file, as this will affect the final recovery result. Please make sure to choose the correct type.\n\nEncryption level: {encryptLevel} Filename: {filename}'**
  String recoverV1FileHelp(String encryptLevel, String filename);

  /// No description provided for @pleaseInputCustomSecretKey.
  ///
  /// In en, this message translates to:
  /// **'Please input custom secret key(32 characters)'**
  String get pleaseInputCustomSecretKey;

  /// No description provided for @inputCustomSecretKeyHelp.
  ///
  /// In en, this message translates to:
  /// **'The secret key used for the backup file is not the same as the current key. Please either use another backup file or use the custom secret key'**
  String get inputCustomSecretKeyHelp;

  /// No description provided for @pleaseInputBackupDirectory.
  ///
  /// In en, this message translates to:
  /// **'Please enter the backup directory path'**
  String get pleaseInputBackupDirectory;

  /// No description provided for @encryptHelp1.
  ///
  /// In en, this message translates to:
  /// **'The encryption level refers to the encryption method used for files backed up to WebDAV. For old backup files (generated by Allpass versions 1.7.0 or earlier), please ensure that the encryption level used for upload and recovery is the same\n'**
  String get encryptHelp1;

  /// No description provided for @encryptHelp2.
  ///
  /// In en, this message translates to:
  /// **'Not encrypted: '**
  String get encryptHelp2;

  /// No description provided for @encryptHelp3.
  ///
  /// In en, this message translates to:
  /// **'Data is backed up in plaintext, with password fields visible; this is the least secure but most universal method, as backup files can be opened directly to view passwords\n'**
  String get encryptHelp3;

  /// No description provided for @encryptHelp4.
  ///
  /// In en, this message translates to:
  /// **'Only password: '**
  String get encryptHelp4;

  /// No description provided for @encryptHelp5.
  ///
  /// In en, this message translates to:
  /// **'The default option is to only encrypt the \'password\' field in password and card records, while fields such as name, username, and tags are not encrypted\n'**
  String get encryptHelp5;

  /// No description provided for @encryptHelp6.
  ///
  /// In en, this message translates to:
  /// **'All encrypted: '**
  String get encryptHelp6;

  /// No description provided for @encryptHelp7.
  ///
  /// In en, this message translates to:
  /// **'All fields are encrypted, and the encrypted data is completely unreadable. This is the most secure option, but if the encryption key is lost, it may be impossible to recover the file\n'**
  String get encryptHelp7;

  /// No description provided for @encryptHelp8.
  ///
  /// In en, this message translates to:
  /// **'The last two encryption level strictly rely on the encryption key used by the Allpass application on the device. If the key is lost, the data will be unrecoverable after uninstallation or data deletion!!!'**
  String get encryptHelp8;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @confirmLogoutWaring.
  ///
  /// In en, this message translates to:
  /// **'After logging out, you will need to log in again and all configuration information will be cleared, continue to logout?'**
  String get confirmLogoutWaring;

  /// No description provided for @lastUploadAt.
  ///
  /// In en, this message translates to:
  /// **'Last uploaded on {uploadTimeString}'**
  String lastUploadAt(String uploadTimeString);

  /// No description provided for @lastRecoverAt.
  ///
  /// In en, this message translates to:
  /// **'Last restored on {recoverTimeString}'**
  String lastRecoverAt(String recoverTimeString);

  /// No description provided for @decryptBackupError.
  ///
  /// In en, this message translates to:
  /// **'Failed to decrypt backup file'**
  String get decryptBackupError;

  /// No description provided for @syncAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Account permission expired, please check your network or log out and reconfigure'**
  String get syncAuthFailed;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing, please wait'**
  String get syncing;

  /// No description provided for @webdavConfig.
  ///
  /// In en, this message translates to:
  /// **'WebDAV Config'**
  String get webdavConfig;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port number'**
  String get port;

  /// No description provided for @webdavServerUrl.
  ///
  /// In en, this message translates to:
  /// **'WebDAV server url'**
  String get webdavServerUrl;

  /// No description provided for @webdavServerUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Please start with http:// or https://'**
  String get webdavServerUrlHint;

  /// No description provided for @webdavServerUrlRequire.
  ///
  /// In en, this message translates to:
  /// **'Server url must start with http:// or https://'**
  String get webdavServerUrlRequire;

  /// No description provided for @webdavPortRequire.
  ///
  /// In en, this message translates to:
  /// **'WebDAV port must be a number'**
  String get webdavPortRequire;

  /// No description provided for @webdavLoginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successfully'**
  String get webdavLoginSuccess;

  /// No description provided for @webdavLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed, please try again'**
  String get webdavLoginFailed;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextStep;

  /// No description provided for @inConfiguration.
  ///
  /// In en, this message translates to:
  /// **'In configuration'**
  String get inConfiguration;

  /// No description provided for @webdavHelp1.
  ///
  /// In en, this message translates to:
  /// **'This feature allows you to back up your data to a WebDAV server or recover your data\n'**
  String get webdavHelp1;

  /// No description provided for @webdavHelp2.
  ///
  /// In en, this message translates to:
  /// **'The WebDAV server address should start with http:// or https://, such as the address for Dropbox (click to copy):'**
  String get webdavHelp2;

  /// No description provided for @webdavHelp3.
  ///
  /// In en, this message translates to:
  /// **'Port number represents the port where the service is located. If you are not sure, please do not edit.'**
  String get webdavHelp3;

  /// No description provided for @webdavExample.
  ///
  /// In en, this message translates to:
  /// **'https://dav.dropdav.com/'**
  String get webdavExample;

  /// No description provided for @copySuccess.
  ///
  /// In en, this message translates to:
  /// **'Copy successfully'**
  String get copySuccess;

  /// No description provided for @clickToViewAndEditConfig.
  ///
  /// In en, this message translates to:
  /// **'Click to review or edit config'**
  String get clickToViewAndEditConfig;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @modifyBackupFilename.
  ///
  /// In en, this message translates to:
  /// **'Modify backup filename'**
  String get modifyBackupFilename;

  /// No description provided for @passwordBackupFilename.
  ///
  /// In en, this message translates to:
  /// **'Passwords backup filename'**
  String get passwordBackupFilename;

  /// No description provided for @cardBackupFilename.
  ///
  /// In en, this message translates to:
  /// **'Cards backup filename'**
  String get cardBackupFilename;

  /// No description provided for @extraBackupFilename.
  ///
  /// In en, this message translates to:
  /// **'Tag and folder backup filename'**
  String get extraBackupFilename;

  /// No description provided for @filenameNotAllowSame.
  ///
  /// In en, this message translates to:
  /// **'Filename can\'t be same'**
  String get filenameNotAllowSame;

  /// No description provided for @filenameNotAllowEmpty.
  ///
  /// In en, this message translates to:
  /// **'Filename can\'t be empty'**
  String get filenameNotAllowEmpty;

  /// No description provided for @filenameRuleRequire.
  ///
  /// In en, this message translates to:
  /// **'Filename can\'t contains \\/:*?\"<>|'**
  String get filenameRuleRequire;

  /// No description provided for @selectBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Select Backup File'**
  String get selectBackupFile;

  /// No description provided for @gettingBackupFiles.
  ///
  /// In en, this message translates to:
  /// **'Retrieving backup file, please wait...'**
  String get gettingBackupFiles;

  /// No description provided for @noBackupFileHint.
  ///
  /// In en, this message translates to:
  /// **'There are no files in the current directory, please ensure that the backup directory is correct'**
  String get noBackupFileHint;

  /// No description provided for @currentDirectory.
  ///
  /// In en, this message translates to:
  /// **'Current Directory: {directory}'**
  String currentDirectory(String directory);

  /// No description provided for @uploadFileNotExists.
  ///
  /// In en, this message translates to:
  /// **'Upload file failed, file not exists'**
  String get uploadFileNotExists;

  /// No description provided for @downloadFileFailed.
  ///
  /// In en, this message translates to:
  /// **'Download file failed'**
  String get downloadFileFailed;

  /// No description provided for @fileNotExists.
  ///
  /// In en, this message translates to:
  /// **'File not exists!'**
  String get fileNotExists;

  /// No description provided for @syncNeedReLogin.
  ///
  /// In en, this message translates to:
  /// **'Account have expired, please login again'**
  String get syncNeedReLogin;

  /// No description provided for @getBackupFileFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve file list, please try changing the backup directory to a subfolder and retrying'**
  String get getBackupFileFailed;

  /// No description provided for @getBackupFileFailedCheckNetwork.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve file list, please check the network'**
  String get getBackupFileFailedCheckNetwork;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Upload successfully'**
  String get uploadSuccess;

  /// No description provided for @uploadFileFailedReject.
  ///
  /// In en, this message translates to:
  /// **'Upload failed, please try changing the backup directory to a subfolder and retrying'**
  String get uploadFileFailedReject;

  /// No description provided for @uploadFileFailedCheckNetwork.
  ///
  /// In en, this message translates to:
  /// **'Upload failed, please check the network'**
  String get uploadFileFailedCheckNetwork;

  /// No description provided for @uploadFileFailedUnknown.
  ///
  /// In en, this message translates to:
  /// **'Upload failed, message: {message}'**
  String uploadFileFailedUnknown(String? message);

  /// No description provided for @uploadFileFailedOther.
  ///
  /// In en, this message translates to:
  /// **'Upload failed, {error}'**
  String uploadFileFailedOther(Object error);

  /// No description provided for @downloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get downloadComplete;

  /// No description provided for @unsupportedBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Unsupported backup file'**
  String get unsupportedBackupFile;

  /// No description provided for @backupFileCorrupt.
  ///
  /// In en, this message translates to:
  /// **'Backup file data is corrupt'**
  String get backupFileCorrupt;

  /// No description provided for @backupFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Backup file has been deleted, please reopen the dialog and try again after refreshing'**
  String get backupFileNotFound;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error, please retry later'**
  String get networkError;

  /// No description provided for @downloadFailedUnknown.
  ///
  /// In en, this message translates to:
  /// **'Download failed, message: {message}'**
  String downloadFailedUnknown(String? message);

  /// No description provided for @downloadFailedOther.
  ///
  /// In en, this message translates to:
  /// **'Download failed, {error}'**
  String downloadFailedOther(Object error);

  /// No description provided for @folderLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder and tags'**
  String get folderLabel;

  /// No description provided for @recoverySuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'Recovery {name} successfully'**
  String recoverySuccessMsg(String name);

  /// No description provided for @recoveryFailedMsg.
  ///
  /// In en, this message translates to:
  /// **'Recovery failed, {error}'**
  String recoveryFailedMsg(Object error);

  /// No description provided for @recoverySuccess.
  ///
  /// In en, this message translates to:
  /// **'Recovery successfully'**
  String get recoverySuccess;

  /// No description provided for @mergeMethodLocalFirst.
  ///
  /// In en, this message translates to:
  /// **'Local First'**
  String get mergeMethodLocalFirst;

  /// No description provided for @mergeMethodRemoteFirst.
  ///
  /// In en, this message translates to:
  /// **'Server First'**
  String get mergeMethodRemoteFirst;

  /// No description provided for @mergeMethodOnlyRemote.
  ///
  /// In en, this message translates to:
  /// **'Only Server'**
  String get mergeMethodOnlyRemote;

  /// No description provided for @mergeMethodLocalFirstHelp.
  ///
  /// In en, this message translates to:
  /// **'If local and server records have the same name, username, and link, keep the local record'**
  String get mergeMethodLocalFirstHelp;

  /// No description provided for @mergeMethodRemoteFirstHelp.
  ///
  /// In en, this message translates to:
  /// **'If local and server records have the same name, username, and link, use the server record'**
  String get mergeMethodRemoteFirstHelp;

  /// No description provided for @mergeMethodOnlyRemoteHelp.
  ///
  /// In en, this message translates to:
  /// **'Delete all local data and use only server data'**
  String get mergeMethodOnlyRemoteHelp;

  /// No description provided for @encryptLevelNone.
  ///
  /// In en, this message translates to:
  /// **'Not encrypted'**
  String get encryptLevelNone;

  /// No description provided for @encryptLevelOnlyPassword.
  ///
  /// In en, this message translates to:
  /// **'Only password'**
  String get encryptLevelOnlyPassword;

  /// No description provided for @encryptLevelAll.
  ///
  /// In en, this message translates to:
  /// **'All encrypted'**
  String get encryptLevelAll;

  /// No description provided for @encryptLevelNoneHelp.
  ///
  /// In en, this message translates to:
  /// **'The password in the backup file will be displayed in plain text'**
  String get encryptLevelNoneHelp;

  /// No description provided for @encryptLevelOnlyPasswordHelp.
  ///
  /// In en, this message translates to:
  /// **'Default option, encrypt only password field'**
  String get encryptLevelOnlyPasswordHelp;

  /// No description provided for @encryptLevelAllHelp.
  ///
  /// In en, this message translates to:
  /// **'All fields are encrypted, information cannot be directly retrieved from the backup file'**
  String get encryptLevelAllHelp;

  /// No description provided for @backupMethodCreateNew.
  ///
  /// In en, this message translates to:
  /// **'Create new file every time'**
  String get backupMethodCreateNew;

  /// No description provided for @backupMethodReplaceExists.
  ///
  /// In en, this message translates to:
  /// **'Backup to specified file'**
  String get backupMethodReplaceExists;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, account, notes or tags'**
  String get searchHint;

  /// No description provided for @searchResultEmpty.
  ///
  /// In en, this message translates to:
  /// **'No results found, please try a different keyword.'**
  String get searchResultEmpty;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @copyUsername.
  ///
  /// In en, this message translates to:
  /// **'Copy username'**
  String get copyUsername;

  /// No description provided for @usernameCopied.
  ///
  /// In en, this message translates to:
  /// **'Username has been copied to clipboard'**
  String get usernameCopied;

  /// No description provided for @copyPassword.
  ///
  /// In en, this message translates to:
  /// **'Copy password'**
  String get copyPassword;

  /// No description provided for @deletePassword.
  ///
  /// In en, this message translates to:
  /// **'Delete password'**
  String get deletePassword;

  /// No description provided for @copyOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Copy owner name'**
  String get copyOwnerName;

  /// No description provided for @ownerNameCopied.
  ///
  /// In en, this message translates to:
  /// **'Owner name has been copied to clipboard'**
  String get ownerNameCopied;

  /// No description provided for @copyCardId.
  ///
  /// In en, this message translates to:
  /// **'Copy card number'**
  String get copyCardId;

  /// No description provided for @deleteCard.
  ///
  /// In en, this message translates to:
  /// **'Delete Card'**
  String get deleteCard;

  /// No description provided for @fav.
  ///
  /// In en, this message translates to:
  /// **'Fav'**
  String get fav;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @allpassIntroduction.
  ///
  /// In en, this message translates to:
  /// **'A simple tool for managing private information.'**
  String get allpassIntroduction;

  /// No description provided for @enterDebugMode.
  ///
  /// In en, this message translates to:
  /// **'Enter Debug Mode'**
  String get enterDebugMode;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website: https://allpass.aengus.top'**
  String get website;

  /// No description provided for @contact1.
  ///
  /// In en, this message translates to:
  /// **'Twitter: @AengusSun'**
  String get contact1;

  /// No description provided for @contact1Url.
  ///
  /// In en, this message translates to:
  /// **'https://twitter.com/AengusSun'**
  String get contact1Url;

  /// No description provided for @contact2.
  ///
  /// In en, this message translates to:
  /// **'Email: sys6511@126.com'**
  String get contact2;

  /// No description provided for @contact3.
  ///
  /// In en, this message translates to:
  /// **'Developer Address: https://www.aengus.top'**
  String get contact3;

  /// No description provided for @projectUrl.
  ///
  /// In en, this message translates to:
  /// **'Source Repository: Github'**
  String get projectUrl;

  /// No description provided for @gitee.
  ///
  /// In en, this message translates to:
  /// **'Gitee'**
  String get gitee;

  /// No description provided for @defaultFolder.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultFolder;

  /// No description provided for @folderEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get folderEntertainment;

  /// No description provided for @folderOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get folderOffice;

  /// No description provided for @folderFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get folderFinance;

  /// No description provided for @folderGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get folderGame;

  /// No description provided for @folderForum.
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get folderForum;

  /// No description provided for @folderEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get folderEducation;

  /// No description provided for @folderSocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get folderSocial;

  /// No description provided for @debugListInstalledApp.
  ///
  /// In en, this message translates to:
  /// **'List installed apps'**
  String get debugListInstalledApp;

  /// No description provided for @debugPageTest.
  ///
  /// In en, this message translates to:
  /// **'Page router'**
  String get debugPageTest;

  /// No description provided for @debugListSp.
  ///
  /// In en, this message translates to:
  /// **'List Sp'**
  String get debugListSp;

  /// No description provided for @debugDeleteAllPassword.
  ///
  /// In en, this message translates to:
  /// **'Delete all passwords'**
  String get debugDeleteAllPassword;

  /// No description provided for @debugDeleteAllCard.
  ///
  /// In en, this message translates to:
  /// **'Delete all cards'**
  String get debugDeleteAllCard;

  /// No description provided for @debugDeletePasswordDB.
  ///
  /// In en, this message translates to:
  /// **'Delete password database'**
  String get debugDeletePasswordDB;

  /// No description provided for @debugDeleteCardDB.
  ///
  /// In en, this message translates to:
  /// **'Delete card database'**
  String get debugDeleteCardDB;

  /// No description provided for @debugAllPasswordDeleted.
  ///
  /// In en, this message translates to:
  /// **'All password deleted'**
  String get debugAllPasswordDeleted;

  /// No description provided for @debugAllCardDeleted.
  ///
  /// In en, this message translates to:
  /// **'All card deleted'**
  String get debugAllCardDeleted;

  /// No description provided for @debugPasswordDBDeleted.
  ///
  /// In en, this message translates to:
  /// **'Password database deleted'**
  String get debugPasswordDBDeleted;

  /// No description provided for @debugCardDBDeleted.
  ///
  /// In en, this message translates to:
  /// **'Card database deleted'**
  String get debugCardDBDeleted;

  /// No description provided for @importFromChromeTips1.
  ///
  /// In en, this message translates to:
  /// **'Open the Chrome，and then open \'Google Password Manager\'，click \'Export passwords\''**
  String get importFromChromeTips1;

  /// No description provided for @importFromChromeTips2.
  ///
  /// In en, this message translates to:
  /// **'Find exported password file in File Explorer，click \'Share\''**
  String get importFromChromeTips2;

  /// No description provided for @importFromChromeTips3.
  ///
  /// In en, this message translates to:
  /// **'Click \'Allpass\'，the import page will be open automatically'**
  String get importFromChromeTips3;

  /// No description provided for @storagePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is denied, please goto setting page to allow Allpass to access your storage'**
  String get storagePermissionDenied;
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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
