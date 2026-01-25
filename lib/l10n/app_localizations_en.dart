// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get allpass => 'Allpass';

  @override
  String get appError => 'Occurs error';

  @override
  String get appErrorHint1 =>
      'App occurs unexpected error, please report to author';

  @override
  String get appErrorHint2 =>
      'Please see below for the error message. Kindly take a screenshot and send it to the email address sys6511@126.com.';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get unlock => 'Unlock';

  @override
  String get unlockAllpass => 'Unlock Allpass';

  @override
  String get pleaseInputMainPassword => 'Please input master password';

  @override
  String get useBiometrics => 'Use Biometrics to unlock';

  @override
  String get notEnableBiometricsYet =>
      'You have not yet enabled biometric recognition';

  @override
  String lockingRemains(int lockSeconds) {
    return 'Locked, $lockSeconds seconds remaining';
  }

  @override
  String get errorExceedThreshold =>
      'Locked for 30 seconds due to five consecutive errors';

  @override
  String get clickToUseBiometrics =>
      'To unlock using biometrics, simply tap here';

  @override
  String get usePassword => 'Use password to unlock';

  @override
  String get inputMainPasswordTimingHint =>
      'To ensure you don\'t forget your master password, Allpass will periodically prompt you to enter it';

  @override
  String get verificationSuccess => 'Verification successful';

  @override
  String get mainPasswordErrorHint =>
      'It seems like you may have forgotten your master password';

  @override
  String get biometricsRecognizedFailed =>
      'Recognition failed, please try again';

  @override
  String get pleaseInputMainPasswordFirst =>
      'Please input master password first';

  @override
  String get unlockSuccess => 'Unlock successfully';

  @override
  String mainPasswordError(int inputErrorTimes) {
    return 'Main password incorrect, has been entered incorrectly $inputErrorTimes times, consecutive errors exceeding five times will result in a 30-second lockout';
  }

  @override
  String get notSetupYet =>
      'Allpass has not been set up yet, please set it up first';

  @override
  String get appHasForceLock =>
      'Allpass has been locked, please use password to unlock';

  @override
  String get setupAllpass => 'Setup Allpass';

  @override
  String get pleaseInputAgain => 'Please input again';

  @override
  String get setup => 'Setup';

  @override
  String get passwordNotSame => 'The two passwords are not the same';

  @override
  String get passwordTooShort => 'Main password length must be greater than 6';

  @override
  String get setupSuccess => 'Setup successfully';

  @override
  String get alreadySetup => 'Already setup, only allow to setup once';

  @override
  String get serviceTerms => 'Service Terms';

  @override
  String get confirmServiceTerms => 'Agree and continue';

  @override
  String get cancel => 'Cancel';

  @override
  String get password => 'Password';

  @override
  String get passwords => 'passwords';

  @override
  String get addPasswordItem => 'Add Password Item';

  @override
  String get passwordEmptyHint =>
      'Here stores your password information, such as\nGoogle account, Twitter account, etc.';

  @override
  String get selectOnePasswordAtLeast =>
      'Please select at least one password item';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String deletePasswordsWarning(int count) {
    return 'You will delete $count password items, continue to delete?';
  }

  @override
  String deletePasswordsSuccess(int count) {
    return '$count password(s) deleted';
  }

  @override
  String movePasswordsSuccess(int count, String folder) {
    return 'Moved $count password(s) to $folder folder';
  }

  @override
  String searchButton(String type) {
    return 'Search $type';
  }

  @override
  String get emptyDataHint => 'Oops, it seems like there\'s nothing here!';

  @override
  String get delete => 'Delete';

  @override
  String get move => 'Move';

  @override
  String get card => 'Card';

  @override
  String get cards => 'cards';

  @override
  String get addCardItem => 'Add Card Item';

  @override
  String get cardEmptyHint =>
      'This is where your card information such as ID cards, bank cards, or VIP cards are stored.';

  @override
  String get selectOneCardAtLeast => 'Please select at least one card item';

  @override
  String deleteCardsWarning(int count) {
    return 'You will delete $count card items, continue to delete?';
  }

  @override
  String deleteCardsSuccess(int count) {
    return '$count card(s) deleted';
  }

  @override
  String moveCardsSuccess(int count, String folder) {
    return 'Moved $count card(s) to $folder folder';
  }

  @override
  String get unknownErrorOccur => 'An error has occurred.';

  @override
  String get account => 'Account';

  @override
  String get copy => 'Copy';

  @override
  String get accountCopied => 'Account has been copied to clipboard';

  @override
  String get passwordCopied => 'Password has been copied to clipboard';

  @override
  String get url => 'Link';

  @override
  String get urlCopied => 'Link has been copied to clipboard';

  @override
  String get ownerApp => 'Belongs to app';

  @override
  String get openAppFailed =>
      'Failed to open app, please ensure that the app is installed';

  @override
  String get notes => 'Notes';

  @override
  String get emptyNotes => 'No notes';

  @override
  String get label => 'tag';

  @override
  String get labels => 'Tags';

  @override
  String accountPassword(String account, String password) {
    return 'Account: $account\nPassword: $password';
  }

  @override
  String get accountPasswordCopied =>
      'Account and Password has been copied to clipboard';

  @override
  String get deletePasswordWaring =>
      'You are about to permanently delete this password item. continue to delete?';

  @override
  String get deleteSuccess => 'Delete Successfully';

  @override
  String get viewPassword => 'Password Detail';

  @override
  String get emptyLabel => 'No tags';

  @override
  String get none => 'None';

  @override
  String get viewCard => 'Card Detail';

  @override
  String get ownerName => 'Owner Name';

  @override
  String get nameCopied => 'Name has been copied to clipboard';

  @override
  String get cardId => 'Card Number';

  @override
  String get cardIdCopied => 'Card number has been copied to clipboard';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberCopied => 'Phone number has been copied to clipboard';

  @override
  String get deleteCardWarning =>
      'You are about to permanently delete this card item. continue to delete?';

  @override
  String get createPassword => 'Create Password';

  @override
  String get updatePassword => 'Edit Password';

  @override
  String get createSuccess => 'Create successfully';

  @override
  String get updateSuccess => 'Update successfully';

  @override
  String get upsertPasswordRule => 'Name, Account and Password can\'t be empty';

  @override
  String get name => 'Name';

  @override
  String get folder => 'folder';

  @override
  String get folderTitle => 'Folder';

  @override
  String createLabelSuccess(String tag) {
    return 'Create Tag $tag successfully';
  }

  @override
  String labelAlreadyExists(String tag) {
    return 'Tag $tag already exists';
  }

  @override
  String get setToNone => 'Set to none';

  @override
  String get addNotes => 'Add notes';

  @override
  String get passwordGenerator => 'Password Generator';

  @override
  String get symbols => 'Symbols';

  @override
  String get generate => 'Generate';

  @override
  String get pleaseSelectOneItemAtLeast => 'Please select one item at least';

  @override
  String get close => 'Close';

  @override
  String get createCard => 'Create Card';

  @override
  String get updateCard => 'Update Card';

  @override
  String get cardPasswordEmptyAutoGen =>
      'No password entered, automatically initialized as 00000';

  @override
  String get upsertCardRule => 'Owner Name and Card Number can\'t be empty';

  @override
  String get settings => 'Settings';

  @override
  String get mainPasswordManager => 'Primary account management';

  @override
  String get biometricAuthentication => 'Biometric authentication';

  @override
  String get enableBiometricSuccess =>
      'Enable biometric authentication successfully';

  @override
  String get disableBiometricSuccess =>
      'Disable biometric authentication successfully';

  @override
  String get biometricNotAvailable =>
      'Biometric recognition is unavailable, please go to system settings to enable it and retry';

  @override
  String get authorizationFailed => 'Authorization failed';

  @override
  String get biometricNotSupport => 'Your device not support biometric';

  @override
  String get autoLock => 'Auto-lock';

  @override
  String get autoLockDialogTitle => 'Lock app when quit';

  @override
  String get autoLockImmediate => 'Immediately';

  @override
  String get autoLock30s => 'In 30s';

  @override
  String get autoLockDisable => 'Disabled';

  @override
  String get longPressToCopy => 'Long Press to Copy';

  @override
  String get appTheme => 'App Theme';

  @override
  String get labelManager => 'Tag Management';

  @override
  String get folderManager => 'Folder Management';

  @override
  String get webDavSync => 'WebDAV Sync';

  @override
  String get importExport => 'Import/Export';

  @override
  String get autofill => 'Autofill Service';

  @override
  String get shareToFriends => 'Share Allpass';

  @override
  String get feedback => 'Feedback';

  @override
  String get checkUpdate => 'Check Update';

  @override
  String get about => 'About';

  @override
  String shareAllpassDesc(String downloadUrl) {
    return '[Allpass] is a simple and easy-to-use tool for managing private information. [DownloadUrl] $downloadUrl';
  }

  @override
  String get shareAllpassSubject => 'Software recommendation - Allpass';

  @override
  String get pleaseSelect => 'Please Select an Item';

  @override
  String get authorizeToUnlock => 'Authorize to unlock Allpass';

  @override
  String get gotoSettings => 'Go to Settings';

  @override
  String get iosGoToSettingsDescFace =>
      'Face ID is currently disabled. Please go to settings to enable Face ID and try again';

  @override
  String get iosGoToSettingsDescFingerprint =>
      'Fingerprint unlock is currently disabled. Please go to settings to enable fingerprint unlock and try again';

  @override
  String get iosGoToSettingsDescIris =>
      'Biometric recognition is currently disabled. Please go to settings to enable it and try again';

  @override
  String get iosGoToSettingsDescDefault =>
      'Biometric authorization is currently disabled. Please go to settings to enable Touch ID or Face ID and try again';

  @override
  String get iosLogoutFace =>
      'Face ID has been disabled. Please lock and unlock your device to enable Face ID';

  @override
  String get iosLogoutFingerprint =>
      'Touch ID has been disabled. Please lock and unlock your device to enable Touch ID';

  @override
  String get iosLogoutIris =>
      'Biometric recognition has been disabled. Please lock and unlock your device to enable biometric recognition';

  @override
  String get androidGoToSettingsDesc =>
      'Fingerprint unlock is currently disabled. Please go to settings to enable it and try again';

  @override
  String get biometricRequiredTitle =>
      'Biometric recognition is not enabled yet';

  @override
  String get signInTitle => 'Please verify';

  @override
  String get biometricHint => 'Use fingerprint to unlock';

  @override
  String get modifyMainPassword => 'Modify master password';

  @override
  String get inputMainPasswordTiming => 'Regularly require master password';

  @override
  String get secretKeyUpdate => 'Update encrypt secret key';

  @override
  String get clearAllData => 'Clear all data';

  @override
  String get lockAllpass => 'Lock Allpass';

  @override
  String get never => 'Never';

  @override
  String get sevenDays => '7 Days';

  @override
  String get tenDays => '10 Days';

  @override
  String get fifteenDays => '15 Days';

  @override
  String get thirtyDays => '30 Days';

  @override
  String nDays(int n) {
    return '$n Days';
  }

  @override
  String get confirmSelect => 'Confirm Select';

  @override
  String get selectNeverWarning =>
      'After selecting this option, Allpass will no longer regularly ask you to enter the master password. Please keep your master password safe';

  @override
  String get confirmClearAll => 'Confirm Clear';

  @override
  String get clearAllWaring =>
      'This operation will clear all App data and can\'t rollback, continue?';

  @override
  String get clearAllSuccess => 'Clear all data successfully';

  @override
  String get mainPasswordIncorrect => 'Master password is incorrect';

  @override
  String get oldPassword => 'Original Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get pleaseInputOldPassword => 'Please input original password';

  @override
  String get pleaseInputNewPassword => 'Please input new password';

  @override
  String get modifySuccess => 'Modify successfully';

  @override
  String get modifyPasswordFail =>
      'Password is less than 6 characters or the two password entries do not match';

  @override
  String get oldPasswordIncorrect =>
      'The entered original password is incorrect!';

  @override
  String get secretKeyUpdateHelp1 => 'Please read carefully';

  @override
  String get secretKeyUpdateHelp2 =>
      'Allpass 1.5.0 and later versions use a new key storage method';

  @override
  String get secretKeyUpdateHelp3 =>
      'Allpass will generate a unique key for each user and store it in a system-specific area. This means that even if Allpass is decompiled and the data in the database is obtained through some means, it cannot be easily decrypted';

  @override
  String get secretKeyUpdateHelp4 =>
      'After upgrading, all password encryption and decryption will rely on the newly generated key. Please ';

  @override
  String get secretKeyUpdateHelp5 => 'keep the newly generated key safe';

  @override
  String get secretKeyUpdateHelp6 =>
      'If you have enabled WebDAV synchronization, your data can still be accessed using the encryption key, even if you uninstall Allpass and the backup files are encrypted';

  @override
  String get secretKeyUpdateHelp7 =>
      'The time required for the upgrade is relatively short, and may vary depending on the device';

  @override
  String get secretKeyUpdateHelp8 =>
      'Please do not exit the program during the upgrade process, as this may cause data loss!';

  @override
  String get secretKeyUpdateHelp9 =>
      '***************** ATTENTION *****************';

  @override
  String get secretKeyUpdateHelp10 =>
      'If you have used Allpass for WebDAV backup, and the \'Encrypt level\' is not the \'Not encrypted\', the old backup files will ';

  @override
  String get secretKeyUpdateHelp11 => 'no longer ';

  @override
  String get secretKeyUpdateHelp12 =>
      'be usable after the encryption key updated. (Local data will not be affected)';

  @override
  String get secretKeyUpdateHelp13 =>
      'For the sake of data security, we still recommend backing up your data by \'Export to CSV File\' function before upgrading!';

  @override
  String get secretKeyUpdateHelp14 =>
      'You can directly edit the input box below and manually input a custom key (32 characters)';

  @override
  String get secretKeyUpdateHint => 'The generated key is displayed here';

  @override
  String get generateSecretKey => 'Generate';

  @override
  String get generateSecretKeyDone =>
      'Generation complete, please keep the new key safe (long press to copy)';

  @override
  String get startUpgrade => 'Start Upgrade';

  @override
  String get upgradeDone => 'Upgrade complete';

  @override
  String get pleaseGenerateKeyFirst => 'Please generate a key first';

  @override
  String get secretKeyLengthRequire => 'The key length must be 32 characters';

  @override
  String secretKeyUpgradeResult(int passwordCount, int cardCount) {
    return 'Upgraded $passwordCount password items and $cardCount card items';
  }

  @override
  String secretKeyUpgradeFailed(Object error) {
    return 'Upgrade failed: $error';
  }

  @override
  String get feedbackPlaceholder => 'Tell us what you think';

  @override
  String get feedbackContact =>
      'Please enter your contact information (optional)';

  @override
  String get submit => 'Submit';

  @override
  String get submitting => 'Submitting, please wait';

  @override
  String get feedbackContentEmptyWarning => 'Please input your feedback';

  @override
  String get feedbackContentTooLong =>
      'The feedback content must be less than 1000 characters!';

  @override
  String updateAvailable(String? channel, String? version) {
    return 'A new version is available for download! Latest version $channel V$version';
  }

  @override
  String alreadyLatestVersion(String? channel, String? version) {
    return 'Your version is up-to-date! $channel V$version';
  }

  @override
  String get updateContent => 'Update Log: ';

  @override
  String get recentlyUpdateContent => 'Recent update log: ';

  @override
  String networkErrorMsg(String? message) {
    return 'Network error: $message';
  }

  @override
  String get networkErrorHelp =>
      'An error has occurred due to network issues. If you have confirmed that your network is not the problem, then it may be due to the following reasons:\n';

  @override
  String unknownError(String? message) {
    return 'Unknown error: $message';
  }

  @override
  String get unknownErrorHelp =>
      'An error has occurred during the check process! Below is the error message, please take a screenshot and send it to sys6511@126.com\n';

  @override
  String get downloadUpdate => 'Download Update';

  @override
  String get remindMeLatter => 'Remind me later';

  @override
  String get confirm => 'Confirm';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeColorBlue => 'Blue';

  @override
  String get themeColorRed => 'Red';

  @override
  String get themeColorTeal => 'Teal';

  @override
  String get themeColorDeepPurple => 'Deep Purple';

  @override
  String get themeColorOrange => 'Orange';

  @override
  String get themeColorPink => 'Pink';

  @override
  String get themeColorBlueGrey => 'Blue Grey';

  @override
  String get selectExportType => 'Select Export Type';

  @override
  String get exportConfirm => 'Confirm Export';

  @override
  String get exportPasswordConfirmWarning =>
      'The exported password will be displayed in plain text. Please keep it secure';

  @override
  String get exportCardConfirmWarning =>
      'The exported card items will be displayed in plain text. Please keep it secure';

  @override
  String get passwordAndCard => 'Both Password and Card';

  @override
  String get exportAllConfirmWarning =>
      'The exported data will be displayed in plain text. Please keep it secure';

  @override
  String exportFailed(String? message) {
    return 'Export Failed: $message';
  }

  @override
  String get importFromChrome => 'Import from Chrome';

  @override
  String get importFromCsv => 'Import from CSV File';

  @override
  String get importFromClipboard => 'Import from Clipboard';

  @override
  String get exportToCsv => 'Export to CSV File';

  @override
  String get selectImportType => 'Select Import Type';

  @override
  String importRecordSuccess(int count) {
    return 'Importing $count records';
  }

  @override
  String get importFailedNotCsv =>
      'Import failed, please make sure the CSV file is exported by Allpass';

  @override
  String get importCanceled => 'Import canceled';

  @override
  String get importFromClipboardHelp1 =>
      'This feature helps you easily import passwords previously saved in Notepad to Allpass;\n';

  @override
  String get importFromClipboardHelp2 =>
      'The name is a mnemonic for the password item, you can give it any name you like to help you identify what this record is about;\n';

  @override
  String get importFromClipboardHelp3 =>
      'The account is the username used for login, which may be a phone number, email, or other account you have set up;\n';

  @override
  String get importFromClipboardHelp4 =>
      'The website address can help Allpass correctly fill in your password on the website, usually the URL address of the website login page;\n';

  @override
  String get importFromClipboardHelp5 =>
      'Please use a \'space\' as the separator between the two fields, so that Allpass can correctly distinguish which one is the username and which one is the password;\n';

  @override
  String get importFromClipboardHelp6 =>
      'If you have selected the last two import format, please enter the uniform username. If there are multiple usernames, they can be imported in several times';

  @override
  String get importFromClipboardSelectFormat =>
      'Please select import password item format(use \'space\' as the separator)';

  @override
  String get importFromClipboardFormat1 => 'Name Account Password WebUrl/Link';

  @override
  String get importFromClipboardFormat2 => 'Name Account Password';

  @override
  String get importFromClipboardFormat3 => 'Account Password WebUrl/Link';

  @override
  String get importFromClipboardFormat4 => 'Account Password';

  @override
  String get importFromClipboardFormat5 => 'Name Password';

  @override
  String get importFromClipboardFormat6 => 'Password';

  @override
  String get importFromClipboardFormatHint =>
      'Please input account(username) here';

  @override
  String get importFromClipboardFormatHint2 => 'Please input account(username)';

  @override
  String get importFromClipboardFormatHint3 => 'Please input records';

  @override
  String get pasteDataHere => 'Paste your data here';

  @override
  String get startImport => 'Start import';

  @override
  String get importing => 'Importing, please wait';

  @override
  String get importComplete => 'Import completed';

  @override
  String recordFormatIncorrect(int n) {
    return 'The format of a $n row\'s record is incorrect';
  }

  @override
  String get importFromExternalPreview => 'Imports Preview';

  @override
  String get importFromExternalTips => 'Slide to delete item';

  @override
  String get confirmImport => 'Continue import';

  @override
  String categoryManagement(String categoryName) {
    return '$categoryName Management';
  }

  @override
  String createCategory(String categoryName) {
    return 'Create $categoryName';
  }

  @override
  String createCategorySuccess(String categoryName, String name) {
    return 'Create $categoryName $name successfully';
  }

  @override
  String categoryAlreadyExists(String categoryName, String name) {
    return '$categoryName $name already exists';
  }

  @override
  String get folderDisallowModify => 'This folded is not allowed to modify';

  @override
  String updateCategory(String categoryName) {
    return 'Edit $categoryName';
  }

  @override
  String updateCategorySuccess(Object categoryName, Object name) {
    return '$categoryName $name saved';
  }

  @override
  String deleteCategory(String categoryName) {
    return 'Delete $categoryName';
  }

  @override
  String get deleteLabelWarning =>
      'Passwords or cards associated with this tag will also delete this tag, continue to delete?';

  @override
  String get deleteFolderWarning =>
      'This operation will move all passwords and cards in this folder to the \'Default\' folder, continue to delete?';

  @override
  String pleaseInputCategoryName(String categoryName) {
    return 'Please input $categoryName name';
  }

  @override
  String categoryNameRuleRequire(String categoryName) {
    return '$categoryName name can\'t contains \',\' \'~\' or \'space\'';
  }

  @override
  String get categoryNameNotValid =>
      'input content is not valid, can\'t contains \',\' \'~\' or \'space\'';

  @override
  String get categoryNameNotAllowEmpty => 'input content is not valid';

  @override
  String get autofillEnableAllpass =>
      'Allpass is already your autofill service';

  @override
  String get autofillDisableAllpass =>
      'Allpass is not your autofill service yet';

  @override
  String get autofillHelp =>
      'When you enter a password in the application, the autofill service will automatically provide possible password item matching options for you to choose from. Stored password items will be considered as candidates when they meet one of the following conditions:\n\n1. The password item belongs to an app that matches the current app;\n2. The name of the password item matches the current app name;\n\nIf you find that the autofill result is not accurate, you can modify the owner app of the password item on the password editing page to help the autofill function match the password more accurately.';

  @override
  String get uploadToRemote => 'Sync to server';

  @override
  String get recoverToLocal => 'Restore to local';

  @override
  String get remoteBackupDirectory => 'Cloud backup directory';

  @override
  String get backupFileMethod => 'Backup file method';

  @override
  String get dataMergeMethod => 'Data recovery method';

  @override
  String get encryptLevel => 'Encryption Level';

  @override
  String get logoutAccount => 'Logout';

  @override
  String get confirmUpload => 'Confirm Upload';

  @override
  String confirmUploadWaring(String encryptLevel) {
    return 'Current encryption level is [$encryptLevel], continue to upload?';
  }

  @override
  String get uploading =>
      'Uploading, please wait and try again when it\'s complete';

  @override
  String get confirmRecover => 'Confirm Restore';

  @override
  String confirmRecoverWarning(String mergeMethod) {
    return 'Current data recovery method is [$mergeMethod], continue to restore?';
  }

  @override
  String get recovering =>
      'Restoring, please wait and try again when it\'s complete';

  @override
  String recoverV1FileHelp(String encryptLevel, String filename) {
    return 'We have detected that an old backup file is being restored. Please select the type of file, as this will affect the final recovery result. Please make sure to choose the correct type.\n\nEncryption level: $encryptLevel Filename: $filename';
  }

  @override
  String get pleaseInputCustomSecretKey =>
      'Please input custom secret key(32 characters)';

  @override
  String get inputCustomSecretKeyHelp =>
      'The secret key used for the backup file is not the same as the current key. Please either use another backup file or use the custom secret key';

  @override
  String get pleaseInputBackupDirectory =>
      'Please enter the backup directory path';

  @override
  String get encryptHelp1 =>
      'The encryption level refers to the encryption method used for files backed up to WebDAV. For old backup files (generated by Allpass versions 1.7.0 or earlier), please ensure that the encryption level used for upload and recovery is the same\n';

  @override
  String get encryptHelp2 => 'Not encrypted: ';

  @override
  String get encryptHelp3 =>
      'Data is backed up in plaintext, with password fields visible; this is the least secure but most universal method, as backup files can be opened directly to view passwords\n';

  @override
  String get encryptHelp4 => 'Only password: ';

  @override
  String get encryptHelp5 =>
      'The default option is to only encrypt the \'password\' field in password and card records, while fields such as name, username, and tags are not encrypted\n';

  @override
  String get encryptHelp6 => 'All encrypted: ';

  @override
  String get encryptHelp7 =>
      'All fields are encrypted, and the encrypted data is completely unreadable. This is the most secure option, but if the encryption key is lost, it may be impossible to recover the file\n';

  @override
  String get encryptHelp8 =>
      'The last two encryption level strictly rely on the encryption key used by the Allpass application on the device. If the key is lost, the data will be unrecoverable after uninstallation or data deletion!!!';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get confirmLogoutWaring =>
      'After logging out, you will need to log in again and all configuration information will be cleared, continue to logout?';

  @override
  String lastUploadAt(String uploadTimeString) {
    return 'Last uploaded on $uploadTimeString';
  }

  @override
  String lastRecoverAt(String recoverTimeString) {
    return 'Last restored on $recoverTimeString';
  }

  @override
  String get decryptBackupError => 'Failed to decrypt backup file';

  @override
  String get syncAuthFailed =>
      'Account permission expired, please check your network or log out and reconfigure';

  @override
  String get syncing => 'Syncing, please wait';

  @override
  String get webdavConfig => 'WebDAV Config';

  @override
  String get port => 'Port number';

  @override
  String get webdavServerUrl => 'WebDAV server url';

  @override
  String get webdavServerUrlHint => 'Please start with http:// or https://';

  @override
  String get webdavServerUrlRequire =>
      'Server url must start with http:// or https://';

  @override
  String get webdavPortRequire => 'WebDAV port must be a number';

  @override
  String get webdavLoginSuccess => 'Login successfully';

  @override
  String get webdavLoginFailed => 'Login failed, please try again';

  @override
  String get nextStep => 'Next';

  @override
  String get inConfiguration => 'In configuration';

  @override
  String get webdavHelp1 =>
      'This feature allows you to back up your data to a WebDAV server or recover your data\n';

  @override
  String get webdavHelp2 =>
      'The WebDAV server address should start with http:// or https://, such as the address for Dropbox (click to copy):';

  @override
  String get webdavHelp3 =>
      'Port number represents the port where the service is located. If you are not sure, please do not edit.';

  @override
  String get webdavExample => 'https://dav.dropdav.com/';

  @override
  String get copySuccess => 'Copy successfully';

  @override
  String get clickToViewAndEditConfig => 'Click to review or edit config';

  @override
  String get help => 'Help';

  @override
  String get modifyBackupFilename => 'Modify backup filename';

  @override
  String get passwordBackupFilename => 'Passwords backup filename';

  @override
  String get cardBackupFilename => 'Cards backup filename';

  @override
  String get extraBackupFilename => 'Tag and folder backup filename';

  @override
  String get filenameNotAllowSame => 'Filename can\'t be same';

  @override
  String get filenameNotAllowEmpty => 'Filename can\'t be empty';

  @override
  String get filenameRuleRequire => 'Filename can\'t contains \\/:*?\"<>|';

  @override
  String get selectBackupFile => 'Select Backup File';

  @override
  String get gettingBackupFiles => 'Retrieving backup file, please wait...';

  @override
  String get noBackupFileHint =>
      'There are no files in the current directory, please ensure that the backup directory is correct';

  @override
  String currentDirectory(String directory) {
    return 'Current Directory: $directory';
  }

  @override
  String get uploadFileNotExists => 'Upload file failed, file not exists';

  @override
  String get downloadFileFailed => 'Download file failed';

  @override
  String get fileNotExists => 'File not exists!';

  @override
  String get syncNeedReLogin => 'Account have expired, please login again';

  @override
  String get getBackupFileFailed =>
      'Failed to retrieve file list, please try changing the backup directory to a subfolder and retrying';

  @override
  String get getBackupFileFailedCheckNetwork =>
      'Failed to retrieve file list, please check the network';

  @override
  String get uploadSuccess => 'Upload successfully';

  @override
  String get uploadFileFailedReject =>
      'Upload failed, please try changing the backup directory to a subfolder and retrying';

  @override
  String get uploadFileFailedCheckNetwork =>
      'Upload failed, please check the network';

  @override
  String uploadFileFailedUnknown(String? message) {
    return 'Upload failed, message: $message';
  }

  @override
  String uploadFileFailedOther(Object error) {
    return 'Upload failed, $error';
  }

  @override
  String get downloadComplete => 'Download complete';

  @override
  String get unsupportedBackupFile => 'Unsupported backup file';

  @override
  String get backupFileCorrupt => 'Backup file data is corrupt';

  @override
  String get backupFileNotFound =>
      'Backup file has been deleted, please reopen the dialog and try again after refreshing';

  @override
  String get networkError => 'Network error, please retry later';

  @override
  String downloadFailedUnknown(String? message) {
    return 'Download failed, message: $message';
  }

  @override
  String downloadFailedOther(Object error) {
    return 'Download failed, $error';
  }

  @override
  String get folderLabel => 'Folder and tags';

  @override
  String recoverySuccessMsg(String name) {
    return 'Recovery $name successfully';
  }

  @override
  String recoveryFailedMsg(Object error) {
    return 'Recovery failed, $error';
  }

  @override
  String get recoverySuccess => 'Recovery successfully';

  @override
  String get mergeMethodLocalFirst => 'Local First';

  @override
  String get mergeMethodRemoteFirst => 'Server First';

  @override
  String get mergeMethodOnlyRemote => 'Only Server';

  @override
  String get mergeMethodLocalFirstHelp =>
      'If local and server records have the same name, username, and link, keep the local record';

  @override
  String get mergeMethodRemoteFirstHelp =>
      'If local and server records have the same name, username, and link, use the server record';

  @override
  String get mergeMethodOnlyRemoteHelp =>
      'Delete all local data and use only server data';

  @override
  String get encryptLevelNone => 'Not encrypted';

  @override
  String get encryptLevelOnlyPassword => 'Only password';

  @override
  String get encryptLevelAll => 'All encrypted';

  @override
  String get encryptLevelNoneHelp =>
      'The password in the backup file will be displayed in plain text';

  @override
  String get encryptLevelOnlyPasswordHelp =>
      'Default option, encrypt only password field';

  @override
  String get encryptLevelAllHelp =>
      'All fields are encrypted, information cannot be directly retrieved from the backup file';

  @override
  String get backupMethodCreateNew => 'Create new file every time';

  @override
  String get backupMethodReplaceExists => 'Backup to specified file';

  @override
  String get searchHint => 'Search by name, account, notes or tags';

  @override
  String get searchResultEmpty =>
      'No results found, please try a different keyword.';

  @override
  String get view => 'View';

  @override
  String get edit => 'Edit';

  @override
  String get copyUsername => 'Copy username';

  @override
  String get usernameCopied => 'Username has been copied to clipboard';

  @override
  String get copyPassword => 'Copy password';

  @override
  String get deletePassword => 'Delete password';

  @override
  String get copyOwnerName => 'Copy owner name';

  @override
  String get ownerNameCopied => 'Owner name has been copied to clipboard';

  @override
  String get copyCardId => 'Copy card number';

  @override
  String get deleteCard => 'Delete Card';

  @override
  String get fav => 'Fav';

  @override
  String get favorites => 'Favorites';

  @override
  String get allpassIntroduction =>
      'A simple tool for managing private information.';

  @override
  String get enterDebugMode => 'Enter Debug Mode';

  @override
  String get contact => 'Contact';

  @override
  String get website => 'Website: https://allpass.aengus.top';

  @override
  String get contact1 => 'Twitter: @AengusSun';

  @override
  String get contact1Url => 'https://twitter.com/AengusSun';

  @override
  String get contact2 => 'Email: sys6511@126.com';

  @override
  String get contact3 => 'Developer Address: https://www.aengus.top';

  @override
  String get projectUrl => 'Source Repository: Github';

  @override
  String get gitee => 'Gitee';

  @override
  String get defaultFolder => 'Default';

  @override
  String get folderEntertainment => 'Entertainment';

  @override
  String get folderOffice => 'Office';

  @override
  String get folderFinance => 'Finance';

  @override
  String get folderGame => 'Game';

  @override
  String get folderForum => 'Forum';

  @override
  String get folderEducation => 'Education';

  @override
  String get folderSocial => 'Social';

  @override
  String get debugListInstalledApp => 'List installed apps';

  @override
  String get debugPageTest => 'Page router';

  @override
  String get debugListSp => 'List Sp';

  @override
  String get debugDeleteAllPassword => 'Delete all passwords';

  @override
  String get debugDeleteAllCard => 'Delete all cards';

  @override
  String get debugDeletePasswordDB => 'Delete password database';

  @override
  String get debugDeleteCardDB => 'Delete card database';

  @override
  String get debugAllPasswordDeleted => 'All password deleted';

  @override
  String get debugAllCardDeleted => 'All card deleted';

  @override
  String get debugPasswordDBDeleted => 'Password database deleted';

  @override
  String get debugCardDBDeleted => 'Card database deleted';

  @override
  String get importFromChromeTips1 =>
      'Open the Chrome，and then open \'Google Password Manager\'，click \'Export passwords\'';

  @override
  String get importFromChromeTips2 =>
      'Find exported password file in File Explorer，click \'Share\'';

  @override
  String get importFromChromeTips3 =>
      'Click \'Allpass\'，the import page will be open automatically';

  @override
  String get storagePermissionDenied =>
      'Storage permission is denied, please goto setting page to allow Allpass to access your storage';
}
