import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Chain Reaction Reborn'**
  String get appName;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @playersLabel.
  ///
  /// In en, this message translates to:
  /// **'PLAYERS'**
  String get playersLabel;

  /// No description provided for @gridSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'GRID SIZE'**
  String get gridSizeLabel;

  /// No description provided for @orbsLabel.
  ///
  /// In en, this message translates to:
  /// **'ORBS'**
  String get orbsLabel;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// No description provided for @gridSizeXSmall.
  ///
  /// In en, this message translates to:
  /// **'X Small'**
  String get gridSizeXSmall;

  /// No description provided for @gridSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get gridSizeSmall;

  /// No description provided for @gridSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get gridSizeMedium;

  /// No description provided for @gridSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get gridSizeLarge;

  /// No description provided for @gridSizeXLarge.
  ///
  /// In en, this message translates to:
  /// **'X Large'**
  String get gridSizeXLarge;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// No description provided for @exitGame.
  ///
  /// In en, this message translates to:
  /// **'Exit Game'**
  String get exitGame;

  /// No description provided for @winner.
  ///
  /// In en, this message translates to:
  /// **'Winner!'**
  String get winner;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @mainMenu.
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get mainMenu;

  /// No description provided for @totalMoves.
  ///
  /// In en, this message translates to:
  /// **'Total Moves'**
  String get totalMoves;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @territory.
  ///
  /// In en, this message translates to:
  /// **'Territory'**
  String get territory;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @preferencesHeader.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferencesHeader;

  /// No description provided for @playerSettingsHeader.
  ///
  /// In en, this message translates to:
  /// **'PLAYER SETTINGS'**
  String get playerSettingsHeader;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get hapticFeedback;

  /// No description provided for @hapticFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vibration on touch'**
  String get hapticFeedbackSubtitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch between light and dark'**
  String get darkModeSubtitle;

  /// No description provided for @resetSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetSettings;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get off;

  /// No description provided for @atomRotation.
  ///
  /// In en, this message translates to:
  /// **'Atom Rotation'**
  String get atomRotation;

  /// No description provided for @atomRotationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Spinning animation'**
  String get atomRotationSubtitle;

  /// No description provided for @atomVibration.
  ///
  /// In en, this message translates to:
  /// **'Atom Vibration'**
  String get atomVibration;

  /// No description provided for @atomVibrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Critical mass shake'**
  String get atomVibrationSubtitle;

  /// No description provided for @atomBreathing.
  ///
  /// In en, this message translates to:
  /// **'Atom Breathing'**
  String get atomBreathing;

  /// No description provided for @atomBreathingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pulse animation'**
  String get atomBreathingSubtitle;

  /// No description provided for @cellHighlight.
  ///
  /// In en, this message translates to:
  /// **'Cell Highlight'**
  String get cellHighlight;

  /// No description provided for @cellHighlightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tint occupied cells'**
  String get cellHighlightSubtitle;

  /// No description provided for @editPlayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Player'**
  String get editPlayerTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @themesTitle.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themesTitle;

  /// No description provided for @availableThemesHeader.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE THEMES'**
  String get availableThemesHeader;

  /// No description provided for @getMoreThemes.
  ///
  /// In en, this message translates to:
  /// **'Get More Themes'**
  String get getMoreThemes;

  /// No description provided for @shopTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopTitle;

  /// No description provided for @removeAdsHeader.
  ///
  /// In en, this message translates to:
  /// **'REMOVE ADS'**
  String get removeAdsHeader;

  /// No description provided for @themePacksHeader.
  ///
  /// In en, this message translates to:
  /// **'THEME PACKS'**
  String get themePacksHeader;

  /// No description provided for @purchasesHeader.
  ///
  /// In en, this message translates to:
  /// **'PURCHASES'**
  String get purchasesHeader;

  /// No description provided for @adFreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Ad-Free Experience'**
  String get adFreeTitle;

  /// No description provided for @adFreeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play without interruptions'**
  String get adFreeSubtitle;

  /// No description provided for @restorePurchasesText.
  ///
  /// In en, this message translates to:
  /// **'Already bought items? Restore your previous purchases.'**
  String get restorePurchasesText;

  /// No description provided for @restorePurchasesButton.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchasesButton;

  /// No description provided for @retroThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Retro Theme'**
  String get retroThemeTitle;

  /// No description provided for @retroThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'8-bit style graphics'**
  String get retroThemeSubtitle;

  /// No description provided for @neonThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Neon Nights'**
  String get neonThemeTitle;

  /// No description provided for @neonThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'High contrast glow'**
  String get neonThemeSubtitle;

  /// No description provided for @pastelThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Pastel Dream'**
  String get pastelThemeTitle;

  /// No description provided for @pastelThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Soft color palette'**
  String get pastelThemeSubtitle;

  /// No description provided for @infoTitle.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoTitle;

  /// No description provided for @howToPlayHeader.
  ///
  /// In en, this message translates to:
  /// **'HOW TO PLAY'**
  String get howToPlayHeader;

  /// No description provided for @aboutHeader.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get aboutHeader;

  /// No description provided for @supportHeader.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get supportHeader;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @developerLabel.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developerLabel;

  /// No description provided for @contactMe.
  ///
  /// In en, this message translates to:
  /// **'Contact Me'**
  String get contactMe;

  /// No description provided for @supportMessage.
  ///
  /// In en, this message translates to:
  /// **'Experiencing issues or have a suggestion? I\'d love to hear from you.'**
  String get supportMessage;

  /// No description provided for @htpBullet1.
  ///
  /// In en, this message translates to:
  /// **'Players take turns placing orbs in their cells. Once a cell reaches critical mass, it explodes into surrounding cells.'**
  String get htpBullet1;

  /// No description provided for @htpBullet2.
  ///
  /// In en, this message translates to:
  /// **'Explosions can cause chain reactions. Opponent cells captured by explosions change color to yours.'**
  String get htpBullet2;

  /// No description provided for @htpBullet3.
  ///
  /// In en, this message translates to:
  /// **'Critical Mass: Corner = 2, Edge = 3, Center = 4. The winner is the last player with orbs on the board.'**
  String get htpBullet3;

  /// No description provided for @developerName.
  ///
  /// In en, this message translates to:
  /// **'The Van Tool'**
  String get developerName;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'phantaiduc2005@gmail.com'**
  String get supportEmail;

  /// No description provided for @menuLabel.
  ///
  /// In en, this message translates to:
  /// **'Chain Reaction'**
  String get menuLabel;

  /// No description provided for @aboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutLabel;

  /// No description provided for @viewLabel.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewLabel;

  /// No description provided for @toggleFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Toggle Fullscreen'**
  String get toggleFullscreen;

  /// No description provided for @appLegalese.
  ///
  /// In en, this message translates to:
  /// **'2026 Chain Reaction Reborn'**
  String get appLegalese;

  /// No description provided for @computerThinking.
  ///
  /// In en, this message translates to:
  /// **'Computer Thinking...'**
  String get computerThinking;

  /// No description provided for @unknownGrid.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownGrid;

  /// No description provided for @gameModeLabel.
  ///
  /// In en, this message translates to:
  /// **'GAME MODE'**
  String get gameModeLabel;

  /// No description provided for @localMultiplayer.
  ///
  /// In en, this message translates to:
  /// **'Local Multiplayer'**
  String get localMultiplayer;

  /// No description provided for @vsComputer.
  ///
  /// In en, this message translates to:
  /// **'Vs Computer'**
  String get vsComputer;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @supportDevelopmentHeader.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT DEVELOPMENT'**
  String get supportDevelopmentHeader;

  /// No description provided for @continueGame.
  ///
  /// In en, this message translates to:
  /// **'Continue Game'**
  String get continueGame;

  /// No description provided for @noSavedGameFound.
  ///
  /// In en, this message translates to:
  /// **'No saved game found.'**
  String get noSavedGameFound;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
