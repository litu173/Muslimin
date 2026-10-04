import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
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
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

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
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Muslimin'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'A day of a Muslim ummah'**
  String get tagline;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @dontShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Show Again'**
  String get dontShowAgain;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @somethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWrong;

  /// No description provided for @onb1Title.
  ///
  /// In en, this message translates to:
  /// **'Share Jamat Time'**
  String get onb1Title;

  /// No description provided for @onb1Body.
  ///
  /// In en, this message translates to:
  /// **'People nearby will be able to view masjid jamat time in this app.'**
  String get onb1Body;

  /// No description provided for @onb2Title.
  ///
  /// In en, this message translates to:
  /// **'Post Masjid Notice'**
  String get onb2Title;

  /// No description provided for @onb2Body.
  ///
  /// In en, this message translates to:
  /// **'People can find masjid notice in this app which will help them to get involve in different occasion.'**
  String get onb2Body;

  /// No description provided for @permTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow access to continue'**
  String get permTitle;

  /// No description provided for @permBody.
  ///
  /// In en, this message translates to:
  /// **'Muslimin needs your location to find the masjids around you, and notifications to remind you before jamat.'**
  String get permBody;

  /// No description provided for @permLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get permLocation;

  /// No description provided for @permLocationBody.
  ///
  /// In en, this message translates to:
  /// **'Find the nearest masjids and calculate accurate prayer times.'**
  String get permLocationBody;

  /// No description provided for @permNotification.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permNotification;

  /// No description provided for @permNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Jamat reminders and notices from masjids you follow.'**
  String get permNotificationBody;

  /// No description provided for @permAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get permAllow;

  /// No description provided for @permGranted.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get permGranted;

  /// No description provided for @permOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get permOpenSettings;

  /// No description provided for @permLocationServiceOff.
  ///
  /// In en, this message translates to:
  /// **'Please turn on location (GPS) on your phone.'**
  String get permLocationServiceOff;

  /// No description provided for @permDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Permission was denied. Please enable it from Settings.'**
  String get permDeniedForever;

  /// No description provided for @permContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get permContinue;

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time left'**
  String get timeLeft;

  /// No description provided for @startsIn.
  ///
  /// In en, this message translates to:
  /// **'Starts in'**
  String get startsIn;

  /// No description provided for @allPrayers.
  ///
  /// In en, this message translates to:
  /// **'All Prayers'**
  String get allPrayers;

  /// No description provided for @nearestMasjid.
  ///
  /// In en, this message translates to:
  /// **'Nearest Masjid'**
  String get nearestMasjid;

  /// No description provided for @noMasjidNearby.
  ///
  /// In en, this message translates to:
  /// **'No verified masjid found near you yet.'**
  String get noMasjidNearby;

  /// No description provided for @noMasjidNearbyHint.
  ///
  /// In en, this message translates to:
  /// **'Know a masjid authority? Ask them to register the masjid in Muslimin.'**
  String get noMasjidNearbyHint;

  /// No description provided for @minWalk.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min walk'**
  String minWalk(String minutes);

  /// No description provided for @kmAway.
  ///
  /// In en, this message translates to:
  /// **'{km} km away'**
  String kmAway(String km);

  /// No description provided for @jamatNotSet.
  ///
  /// In en, this message translates to:
  /// **'Jamat time not set'**
  String get jamatNotSet;

  /// No description provided for @nextJamat.
  ///
  /// In en, this message translates to:
  /// **'Next jamat'**
  String get nextJamat;

  /// No description provided for @notice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get notice;

  /// No description provided for @notices.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get notices;

  /// No description provided for @noNotices.
  ///
  /// In en, this message translates to:
  /// **'No notices yet.'**
  String get noNotices;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @authorityTitle.
  ///
  /// In en, this message translates to:
  /// **'Masjid Authorities'**
  String get authorityTitle;

  /// No description provided for @authorityBody.
  ///
  /// In en, this message translates to:
  /// **'Register your masjid & let Muslims nearby discover in this app.'**
  String get authorityBody;

  /// No description provided for @yourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your Location'**
  String get yourLocation;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Locating…'**
  String get locating;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get useCurrentLocation;

  /// No description provided for @searchMasjid.
  ///
  /// In en, this message translates to:
  /// **'Search masjid'**
  String get searchMasjid;

  /// No description provided for @nearbyMasjids.
  ///
  /// In en, this message translates to:
  /// **'Nearby Masjids'**
  String get nearbyMasjids;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Duhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @jumuah.
  ///
  /// In en, this message translates to:
  /// **'Jum\'ah'**
  String get jumuah;

  /// No description provided for @forbiddenTime.
  ///
  /// In en, this message translates to:
  /// **'Forbidden Time'**
  String get forbiddenTime;

  /// No description provided for @forbiddenInfo.
  ///
  /// In en, this message translates to:
  /// **'Salah is not offered during these times: while the sun is rising, at its zenith and while it is setting.'**
  String get forbiddenInfo;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @noon.
  ///
  /// In en, this message translates to:
  /// **'Noon'**
  String get noon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @naflPrayers.
  ///
  /// In en, this message translates to:
  /// **'Nafl Prayers'**
  String get naflPrayers;

  /// No description provided for @tahajjud.
  ///
  /// In en, this message translates to:
  /// **'Tahajjud'**
  String get tahajjud;

  /// No description provided for @duha.
  ///
  /// In en, this message translates to:
  /// **'Salatul Duha'**
  String get duha;

  /// No description provided for @tahajjudHadith.
  ///
  /// In en, this message translates to:
  /// **'Allah\'s Messenger (ﷺ) said, \"Our Lord, the Blessed, the Superior, comes every night down on the nearest Heaven to us when the last third of the night remains, saying: \'Is there anyone to invoke Me, so that I may respond to invocation? Is there anyone to ask Me, so that I may grant him his request? Is there anyone seeking My forgiveness, so that I may forgive him?\'\"'**
  String get tahajjudHadith;

  /// No description provided for @tahajjudSource.
  ///
  /// In en, this message translates to:
  /// **'Sahih al-Bukhari 1145'**
  String get tahajjudSource;

  /// No description provided for @duhaHadith1.
  ///
  /// In en, this message translates to:
  /// **'Abu Hurairah said: \"My friend, the Messenger of Allah (ﷺ) advised me to do three things: fasting three days of every month, praying the duha prayer, and praying the witr prayer before I sleep.\"'**
  String get duhaHadith1;

  /// No description provided for @duhaSource1.
  ///
  /// In en, this message translates to:
  /// **'Sahih al-Bukhari & Muslim'**
  String get duhaSource1;

  /// No description provided for @duhaHadith2.
  ///
  /// In en, this message translates to:
  /// **'Nu\'aym ibn Hammar reported: The Messenger of Allah (ﷺ) said, \"Allah Almighty says: O son of Adam, do not be frustrated to perform four cycles of prayer for me at the beginning of your day. I will suffice you for the rest of it.\"'**
  String get duhaHadith2;

  /// No description provided for @duhaSource2.
  ///
  /// In en, this message translates to:
  /// **'Sunan Abi Dawud 1289'**
  String get duhaSource2;

  /// No description provided for @calcMethodNote.
  ///
  /// In en, this message translates to:
  /// **'Times are calculated for your location. Jamat times are set by each masjid.'**
  String get calcMethodNote;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get tabNotice;

  /// No description provided for @tabLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get tabLive;

  /// No description provided for @tabAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get tabAbout;

  /// No description provided for @jamatTime.
  ///
  /// In en, this message translates to:
  /// **'Jamat Time'**
  String get jamatTime;

  /// No description provided for @maktabTime.
  ///
  /// In en, this message translates to:
  /// **'Maktab Time'**
  String get maktabTime;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {when}'**
  String lastUpdated(String when);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(String count);

  /// No description provided for @khatib.
  ///
  /// In en, this message translates to:
  /// **'Khatib'**
  String get khatib;

  /// No description provided for @imam.
  ///
  /// In en, this message translates to:
  /// **'Imam'**
  String get imam;

  /// No description provided for @muazzin.
  ///
  /// In en, this message translates to:
  /// **'Moazzin'**
  String get muazzin;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact: {phone}'**
  String contact(String phone);

  /// No description provided for @notAdded.
  ///
  /// In en, this message translates to:
  /// **'Not added yet'**
  String get notAdded;

  /// No description provided for @jamatReminder.
  ///
  /// In en, this message translates to:
  /// **'Jamat Reminder'**
  String get jamatReminder;

  /// No description provided for @notifyBefore.
  ///
  /// In en, this message translates to:
  /// **'Notify before'**
  String get notifyBefore;

  /// No description provided for @minsBefore.
  ///
  /// In en, this message translates to:
  /// **'{minutes} mins'**
  String minsBefore(String minutes);

  /// No description provided for @reminderOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off reminder'**
  String get reminderOff;

  /// No description provided for @reminderSet.
  ///
  /// In en, this message translates to:
  /// **'You will be reminded {minutes} minutes before each jamat.'**
  String reminderSet(String minutes);

  /// No description provided for @followedToast.
  ///
  /// In en, this message translates to:
  /// **'You are now following {name}.'**
  String followedToast(String name);

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @liveNow.
  ///
  /// In en, this message translates to:
  /// **'Live now'**
  String get liveNow;

  /// No description provided for @noLive.
  ///
  /// In en, this message translates to:
  /// **'No live session right now'**
  String get noLive;

  /// No description provided for @noLiveHint.
  ///
  /// In en, this message translates to:
  /// **'When the masjid streams a khutbah or bayan, it will appear here.'**
  String get noLiveHint;

  /// No description provided for @watchLive.
  ///
  /// In en, this message translates to:
  /// **'Watch live'**
  String get watchLive;

  /// No description provided for @liveLink.
  ///
  /// In en, this message translates to:
  /// **'Live stream link (YouTube / Facebook)'**
  String get liveLink;

  /// No description provided for @liveToggle.
  ///
  /// In en, this message translates to:
  /// **'We are live now'**
  String get liveToggle;

  /// No description provided for @maktabDays.
  ///
  /// In en, this message translates to:
  /// **'Maktab days'**
  String get maktabDays;

  /// No description provided for @weekdaysShort.
  ///
  /// In en, this message translates to:
  /// **'Sat,Sun,Mon,Tue,Wed,Thu,Fri'**
  String get weekdaysShort;

  /// No description provided for @weekdaysLong.
  ///
  /// In en, this message translates to:
  /// **'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday'**
  String get weekdaysLong;

  /// No description provided for @dayRange.
  ///
  /// In en, this message translates to:
  /// **'{from} ~ {to}'**
  String dayRange(String from, String to);

  /// No description provided for @tapToSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get tapToSet;

  /// No description provided for @khatibName.
  ///
  /// In en, this message translates to:
  /// **'Khatib Name'**
  String get khatibName;

  /// No description provided for @imamName.
  ///
  /// In en, this message translates to:
  /// **'Imam Name'**
  String get imamName;

  /// No description provided for @muazzinName.
  ///
  /// In en, this message translates to:
  /// **'Moazzin Name'**
  String get muazzinName;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updated;

  /// No description provided for @writeNotice.
  ///
  /// In en, this message translates to:
  /// **'Write Notice'**
  String get writeNotice;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @deleteNoticeQ.
  ///
  /// In en, this message translates to:
  /// **'Delete this notice?'**
  String get deleteNoticeQ;

  /// No description provided for @catJanaza.
  ///
  /// In en, this message translates to:
  /// **'Janaza'**
  String get catJanaza;

  /// No description provided for @catRecruitment.
  ///
  /// In en, this message translates to:
  /// **'Recruitment'**
  String get catRecruitment;

  /// No description provided for @catQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran Class'**
  String get catQuran;

  /// No description provided for @catQuranShort.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get catQuranShort;

  /// No description provided for @catMahfil.
  ///
  /// In en, this message translates to:
  /// **'Mahfil'**
  String get catMahfil;

  /// No description provided for @catTalim.
  ///
  /// In en, this message translates to:
  /// **'Talim'**
  String get catTalim;

  /// No description provided for @catTafsir.
  ///
  /// In en, this message translates to:
  /// **'Tafsir'**
  String get catTafsir;

  /// No description provided for @catGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get catGeneral;

  /// No description provided for @janazaNotice.
  ///
  /// In en, this message translates to:
  /// **'Janaza Notice'**
  String get janazaNotice;

  /// No description provided for @noticeFormTitle.
  ///
  /// In en, this message translates to:
  /// **'{category} Notice'**
  String noticeFormTitle(String category);

  /// No description provided for @enterCarefully.
  ///
  /// In en, this message translates to:
  /// **'Please enter below information carefully.'**
  String get enterCarefully;

  /// No description provided for @personName.
  ///
  /// In en, this message translates to:
  /// **'Person Name'**
  String get personName;

  /// No description provided for @fathersName.
  ///
  /// In en, this message translates to:
  /// **'Father\'s Name'**
  String get fathersName;

  /// No description provided for @diedOn.
  ///
  /// In en, this message translates to:
  /// **'Died On'**
  String get diedOn;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @janazaTime.
  ///
  /// In en, this message translates to:
  /// **'Janaza Time'**
  String get janazaTime;

  /// No description provided for @janazaDate.
  ///
  /// In en, this message translates to:
  /// **'Janaza Date'**
  String get janazaDate;

  /// No description provided for @noticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get noticeTitle;

  /// No description provided for @noticeDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get noticeDetails;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline: {date}'**
  String deadline(String date);

  /// No description provided for @startingDate.
  ///
  /// In en, this message translates to:
  /// **'Starting Date: {date}'**
  String startingDate(String date);

  /// No description provided for @timeAndDate.
  ///
  /// In en, this message translates to:
  /// **'Time & Date: {value}'**
  String timeAndDate(String value);

  /// No description provided for @janazaOf.
  ///
  /// In en, this message translates to:
  /// **'Janaza of {name}'**
  String janazaOf(String name);

  /// No description provided for @sonOf.
  ///
  /// In en, this message translates to:
  /// **'Son/Daughter of {name}'**
  String sonOf(String name);

  /// No description provided for @noticePosted.
  ///
  /// In en, this message translates to:
  /// **'Notice posted'**
  String get noticePosted;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @userAuth.
  ///
  /// In en, this message translates to:
  /// **'User Authentication'**
  String get userAuth;

  /// No description provided for @userAuthBody.
  ///
  /// In en, this message translates to:
  /// **'Please read & agree if below meets.'**
  String get userAuthBody;

  /// No description provided for @rule1.
  ///
  /// In en, this message translates to:
  /// **'I am a masjid committee member or masjid khadem/moazzin/imam'**
  String get rule1;

  /// No description provided for @rule2.
  ///
  /// In en, this message translates to:
  /// **'I am able to update masjid jamat time regularly'**
  String get rule2;

  /// No description provided for @rule3.
  ///
  /// In en, this message translates to:
  /// **'I understand the benefit of this app'**
  String get rule3;

  /// No description provided for @rule4.
  ///
  /// In en, this message translates to:
  /// **'I am physically inside the masjid right now'**
  String get rule4;

  /// No description provided for @agreeAll.
  ///
  /// In en, this message translates to:
  /// **'Please confirm all the statements to continue.'**
  String get agreeAll;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @verifyMobile.
  ///
  /// In en, this message translates to:
  /// **'Verify your mobile number'**
  String get verifyMobile;

  /// No description provided for @yourMobile.
  ///
  /// In en, this message translates to:
  /// **'Your Mobile Number'**
  String get yourMobile;

  /// No description provided for @otpWillBeSent.
  ///
  /// In en, this message translates to:
  /// **'One Time Password (OTP) will be sent to this phone number for verification'**
  String get otpWillBeSent;

  /// No description provided for @getOtp.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get getOtp;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Bangladeshi mobile number (01XXXXXXXXX).'**
  String get invalidPhone;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @typeOtp.
  ///
  /// In en, this message translates to:
  /// **'Please type the OTP code sent to your phone number'**
  String get typeOtp;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'One Time Password (OTP)'**
  String get otp;

  /// No description provided for @didntGetOtp.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the OTP?'**
  String get didntGetOtp;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(String seconds);

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'The code is not correct. Please try again.'**
  String get invalidOtp;

  /// No description provided for @demoOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: use code 123456'**
  String get demoOtpHint;

  /// No description provided for @createMasjidProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Masjid Profile'**
  String get createMasjidProfile;

  /// No description provided for @stayInside.
  ///
  /// In en, this message translates to:
  /// **'Stay inside of the masjid & enter below information carefully.'**
  String get stayInside;

  /// No description provided for @masjidName.
  ///
  /// In en, this message translates to:
  /// **'Masjid Name'**
  String get masjidName;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @thana.
  ///
  /// In en, this message translates to:
  /// **'Thana / Upazila'**
  String get thana;

  /// No description provided for @latLng.
  ///
  /// In en, this message translates to:
  /// **'Latitude & Longitude'**
  String get latLng;

  /// No description provided for @load.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get load;

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// No description provided for @stayInsideLoading.
  ///
  /// In en, this message translates to:
  /// **'Stay inside of the masjid during loading.'**
  String get stayInsideLoading;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy ±{meters} m'**
  String accuracy(String meters);

  /// No description provided for @accuracyTooLow.
  ///
  /// In en, this message translates to:
  /// **'Location is not accurate enough (±{meters} m). Move to an open area inside the masjid and reload.'**
  String accuracyTooLow(String meters);

  /// No description provided for @loadLocationFirst.
  ///
  /// In en, this message translates to:
  /// **'Please load the masjid location.'**
  String get loadLocationFirst;

  /// No description provided for @nidNumber.
  ///
  /// In en, this message translates to:
  /// **'Your NID Number'**
  String get nidNumber;

  /// No description provided for @invalidNid.
  ///
  /// In en, this message translates to:
  /// **'NID must be 10, 13 or 17 digits.'**
  String get invalidNid;

  /// No description provided for @yourRole.
  ///
  /// In en, this message translates to:
  /// **'Your Role'**
  String get yourRole;

  /// No description provided for @roleCommittee.
  ///
  /// In en, this message translates to:
  /// **'Committee member'**
  String get roleCommittee;

  /// No description provided for @roleKhadem.
  ///
  /// In en, this message translates to:
  /// **'Khadem'**
  String get roleKhadem;

  /// No description provided for @roleMuazzin.
  ///
  /// In en, this message translates to:
  /// **'Moazzin'**
  String get roleMuazzin;

  /// No description provided for @roleImam.
  ///
  /// In en, this message translates to:
  /// **'Imam'**
  String get roleImam;

  /// No description provided for @roleKhatib.
  ///
  /// In en, this message translates to:
  /// **'Khatib'**
  String get roleKhatib;

  /// No description provided for @agreeTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I\'ve read & I agree to the '**
  String get agreeTermsPrefix;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @mustAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms & Conditions.'**
  String get mustAgreeTerms;

  /// No description provided for @duplicateFound.
  ///
  /// In en, this message translates to:
  /// **'A masjid named \"{name}\" is already registered at this location. If you are its authority, please contact support.'**
  String duplicateFound(String name);

  /// No description provided for @limitReached.
  ///
  /// In en, this message translates to:
  /// **'You can have at most {count} masjid profiles.'**
  String limitReached(String count);

  /// No description provided for @submittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Submitted for review'**
  String get submittedTitle;

  /// No description provided for @submittedBody.
  ///
  /// In en, this message translates to:
  /// **'Jazakallahu khairan! Your masjid profile will be visible to everyone after our team verifies it. You will get a notification when it is approved.'**
  String get submittedBody;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @termsBody.
  ///
  /// In en, this message translates to:
  /// **'1. Only masjid committee members, imam, khatib, moazzin or khadem may create a masjid profile.\n2. The profile must be created from inside the masjid so its location is correct.\n3. Your NID and phone number are used only for verification and are never shown publicly.\n4. Jamat times and notices must be accurate and kept up to date.\n5. Notices must be related to masjid activities. Political, commercial or hateful content is not allowed.\n6. A profile stays hidden until it is verified by the Muslimin team. Profiles with false information will be removed.'**
  String get termsBody;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get statusPending;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get statusSuspended;

  /// No description provided for @pendingBanner.
  ///
  /// In en, this message translates to:
  /// **'This profile is waiting for verification. Only you can see it.'**
  String get pendingBanner;

  /// No description provided for @rejectedBanner.
  ///
  /// In en, this message translates to:
  /// **'This profile was not approved: {reason}'**
  String rejectedBanner(String reason);

  /// No description provided for @myMasjids.
  ///
  /// In en, this message translates to:
  /// **'My Masjids'**
  String get myMasjids;

  /// No description provided for @registerMasjid.
  ///
  /// In en, this message translates to:
  /// **'Register a Masjid'**
  String get registerMasjid;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share this app'**
  String get shareApp;

  /// No description provided for @shareAppBody.
  ///
  /// In en, this message translates to:
  /// **'This app might help your family & friends as well. Please share.'**
  String get shareAppBody;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'Find jamat times of masjids near you with Muslimin: {url}'**
  String shareText(String url);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @calcMethod.
  ///
  /// In en, this message translates to:
  /// **'Prayer time calculation'**
  String get calcMethod;

  /// No description provided for @asrMethod.
  ///
  /// In en, this message translates to:
  /// **'Asr calculation'**
  String get asrMethod;

  /// No description provided for @hanafi.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get hanafi;

  /// No description provided for @shafi.
  ///
  /// In en, this message translates to:
  /// **'Shafi\'i / Maliki / Hanbali'**
  String get shafi;

  /// No description provided for @hijriAdjust.
  ///
  /// In en, this message translates to:
  /// **'Hijri date adjustment'**
  String get hijriAdjust;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String days(String count);

  /// No description provided for @defaultReminder.
  ///
  /// In en, this message translates to:
  /// **'Default jamat reminder'**
  String get defaultReminder;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {phone}'**
  String signedInAs(String phone);

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {v}'**
  String version(String v);

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Muslimin helps Muslims find the jamat times of the masjids around them. Every masjid profile is created by its own authority and verified by our team before it becomes public.'**
  String get aboutBody;

  /// No description provided for @faqQ1.
  ///
  /// In en, this message translates to:
  /// **'Where do the jamat times come from?'**
  String get faqQ1;

  /// No description provided for @faqA1.
  ///
  /// In en, this message translates to:
  /// **'Each masjid\'s authority sets and updates its own jamat times. Prayer start times are calculated for your location.'**
  String get faqA1;

  /// No description provided for @faqQ2.
  ///
  /// In en, this message translates to:
  /// **'Why is location mandatory?'**
  String get faqQ2;

  /// No description provided for @faqA2.
  ///
  /// In en, this message translates to:
  /// **'Location is used to show masjids near you and to calculate accurate prayer times. It is never shared with anyone.'**
  String get faqA2;

  /// No description provided for @faqQ3.
  ///
  /// In en, this message translates to:
  /// **'How can I add my masjid?'**
  String get faqQ3;

  /// No description provided for @faqA3.
  ///
  /// In en, this message translates to:
  /// **'Go to More → Register a Masjid. You must be a committee member, imam, moazzin, khatib or khadem, and you must be inside the masjid while registering.'**
  String get faqA3;

  /// No description provided for @faqQ4.
  ///
  /// In en, this message translates to:
  /// **'Why is my masjid not visible?'**
  String get faqQ4;

  /// No description provided for @faqA4.
  ///
  /// In en, this message translates to:
  /// **'New profiles are verified by our team before they become public. This usually takes 1–2 days.'**
  String get faqA4;

  /// No description provided for @faqQ5.
  ///
  /// In en, this message translates to:
  /// **'How do jamat reminders work?'**
  String get faqQ5;

  /// No description provided for @faqA5.
  ///
  /// In en, this message translates to:
  /// **'Open a masjid and tap the bell on Jamat Time. You will be notified 15, 30 or 45 minutes before each jamat, even when the app is closed.'**
  String get faqA5;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'Follow masjids to see their notices here.'**
  String get noNotifications;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @adminPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminPending;

  /// No description provided for @adminApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get adminApproved;

  /// No description provided for @adminRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get adminRejected;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @suspend.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get suspend;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @rejectReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for rejection'**
  String get rejectReason;

  /// No description provided for @submittedBy.
  ///
  /// In en, this message translates to:
  /// **'Submitted by'**
  String get submittedBy;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @nid.
  ///
  /// In en, this message translates to:
  /// **'NID'**
  String get nid;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// No description provided for @submittedOn.
  ///
  /// In en, this message translates to:
  /// **'Submitted on'**
  String get submittedOn;

  /// No description provided for @nothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get nothingHere;

  /// No description provided for @approvedToast.
  ///
  /// In en, this message translates to:
  /// **'Masjid approved'**
  String get approvedToast;

  /// No description provided for @rejectedToast.
  ///
  /// In en, this message translates to:
  /// **'Masjid rejected'**
  String get rejectedToast;

  /// No description provided for @verifiedChecklist.
  ///
  /// In en, this message translates to:
  /// **'Before approving, call the submitter and check the location on the map.'**
  String get verifiedChecklist;

  /// No description provided for @verse1Ar.
  ///
  /// In en, this message translates to:
  /// **'وَٱسْتَعِينُوا۟ بِٱلصَّبْرِ وَٱلصَّلَوٰةِ'**
  String get verse1Ar;

  /// No description provided for @verse1.
  ///
  /// In en, this message translates to:
  /// **'And seek help through patience and prayer'**
  String get verse1;

  /// No description provided for @verse1Ref.
  ///
  /// In en, this message translates to:
  /// **'Al-Baqarah 2:45'**
  String get verse1Ref;

  /// No description provided for @verse2Ar.
  ///
  /// In en, this message translates to:
  /// **'إِنَّ ٱلصَّلَوٰةَ كَانَتْ عَلَى ٱلْمُؤْمِنِينَ كِتَـٰبًا مَّوْقُوتًا'**
  String get verse2Ar;

  /// No description provided for @verse2.
  ///
  /// In en, this message translates to:
  /// **'Indeed, prayer has been decreed upon the believers a decree of specified times'**
  String get verse2;

  /// No description provided for @verse2Ref.
  ///
  /// In en, this message translates to:
  /// **'An-Nisa\' 4:103'**
  String get verse2Ref;

  /// No description provided for @verse3Ar.
  ///
  /// In en, this message translates to:
  /// **'حَـٰفِظُوا۟ عَلَى ٱلصَّلَوَٰتِ وَٱلصَّلَوٰةِ ٱلْوُسْطَىٰ'**
  String get verse3Ar;

  /// No description provided for @verse3.
  ///
  /// In en, this message translates to:
  /// **'Maintain with care the [obligatory] prayers and [in particular] the middle prayer'**
  String get verse3;

  /// No description provided for @verse3Ref.
  ///
  /// In en, this message translates to:
  /// **'Al-Baqarah 2:238'**
  String get verse3Ref;

  /// No description provided for @hijriMonths.
  ///
  /// In en, this message translates to:
  /// **'Muharram,Safar,Rabi al-Awwal,Rabi al-Thani,Jumada al-Ula,Jumada al-Thani,Rajab,Sha\'ban,Ramadan,Shawwal,Dhul Qa\'dah,Dhul Hijjah'**
  String get hijriMonths;

  /// No description provided for @deadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadlineLabel;

  /// No description provided for @startingDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Starting Date'**
  String get startingDateLabel;

  /// No description provided for @masjidNameBn.
  ///
  /// In en, this message translates to:
  /// **'Masjid Name in Bangla (optional)'**
  String get masjidNameBn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @signUpBody.
  ///
  /// In en, this message translates to:
  /// **'Create your account to follow masjids and keep your settings safe.'**
  String get signUpBody;

  /// No description provided for @signInBody.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Sign in to continue.'**
  String get signInBody;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the email you signed up with. We will send you a link to set a new password.'**
  String get resetBody;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @resetSent.
  ///
  /// In en, this message translates to:
  /// **'A password reset link has been sent to {email}. Please check your inbox (and spam folder).'**
  String resetSent(String email);

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get passwordTooShort;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match.'**
  String get passwordsDontMatch;

  /// No description provided for @errEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email. Try signing in.'**
  String get errEmailInUse;

  /// No description provided for @errInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect.'**
  String get errInvalidCredential;

  /// No description provided for @errWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Please choose a stronger password (at least 6 characters).'**
  String get errWeakPassword;

  /// No description provided for @errTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a few minutes and try again.'**
  String get errTooManyRequests;

  /// No description provided for @errNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please try again.'**
  String get errNetwork;

  /// No description provided for @errPhoneInUse.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already linked to another account.'**
  String get errPhoneInUse;

  /// No description provided for @errUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled. Please contact support.'**
  String get errUserDisabled;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @signInPrompt.
  ///
  /// In en, this message translates to:
  /// **'For masjid authorities'**
  String get signInPrompt;

  /// No description provided for @signInPromptBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account to register and manage your masjid. Regular users don\'t need an account.'**
  String get signInPromptBody;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email not verified'**
  String get emailNotVerified;

  /// No description provided for @emailVerified.
  ///
  /// In en, this message translates to:
  /// **'Email verified'**
  String get emailVerified;

  /// No description provided for @resendVerification.
  ///
  /// In en, this message translates to:
  /// **'Send verification email'**
  String get resendVerification;

  /// No description provided for @verificationSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent to {email}.'**
  String verificationSent(String email);

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully.'**
  String get passwordChanged;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and saved data. Masjid profiles you manage will stay but you will lose access. Enter your password to confirm.'**
  String get deleteAccountBody;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get accountDeleted;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneNumber;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get notVerified;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeUser(String name);

  /// No description provided for @signInToRegister.
  ///
  /// In en, this message translates to:
  /// **'Please sign in or create an account to register a masjid.'**
  String get signInToRegister;

  /// No description provided for @verifyPhoneToContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone number to register a masjid.'**
  String get verifyPhoneToContinue;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created! We sent a verification link to {email}.'**
  String accountCreated(String email);

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get nameRequired;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @fontCredits.
  ///
  /// In en, this message translates to:
  /// **'Logo & English prayer names: lettering from the Muslimin design, based on Hidayatullah by Anthonie Van Hayu (ARToni). Fonts: Grenze Gotisch by Omnibus-Type, Poppins by Indian Type Foundry & Jonny Pinhorn, Hind Siliguri by Indian Type Foundry, Anek Bangla (Bangla digits) by Ek Type, Galada by Black Foundry, Scheherazade New by SIL International. All fonts are free under the SIL Open Font License 1.1.'**
  String get fontCredits;

  /// No description provided for @designInspired.
  ///
  /// In en, this message translates to:
  /// **'Original design font: Hidayatullah by Anthonie Van Hayu (ARToni).'**
  String get designInspired;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licences'**
  String get openSourceLicenses;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

  /// No description provided for @onb3Title.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times & Reminders'**
  String get onb3Title;

  /// No description provided for @onb3Body.
  ///
  /// In en, this message translates to:
  /// **'Accurate prayer times for your location, and a reminder before every jamat at the masjids you follow.'**
  String get onb3Body;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @checkingUpdates.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates…'**
  String get checkingUpdates;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'You have the latest version.'**
  String get upToDate;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version {version} is available'**
  String updateAvailable(String version);

  /// No description provided for @downloadLatestApk.
  ///
  /// In en, this message translates to:
  /// **'Download latest APK'**
  String get downloadLatestApk;

  /// No description provided for @updateApkHint.
  ///
  /// In en, this message translates to:
  /// **'Open the downloaded file to install it over this version. Your settings are kept.'**
  String get updateApkHint;

  /// No description provided for @updateIosButton.
  ///
  /// In en, this message translates to:
  /// **'How to update on iPhone'**
  String get updateIosButton;

  /// No description provided for @updateCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t check for updates. Check your internet connection.'**
  String get updateCheckFailed;

  /// No description provided for @releaseNotes.
  ///
  /// In en, this message translates to:
  /// **'Release notes'**
  String get releaseNotes;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to follow your masjids, get jamat reminders and keep everything synced across your phones.'**
  String get welcomeBody;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuest;

  /// No description provided for @editMasjidInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit Masjid Info'**
  String get editMasjidInfo;

  /// No description provided for @editMasjidInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Update the details shown on your masjid profile. To correct the location, stand inside the masjid and tap Reload.'**
  String get editMasjidInfoBody;

  /// No description provided for @followedMasjids.
  ///
  /// In en, this message translates to:
  /// **'Followed Masjids'**
  String get followedMasjids;

  /// No description provided for @noFollowed.
  ///
  /// In en, this message translates to:
  /// **'You are not following any masjid yet.'**
  String get noFollowed;

  /// No description provided for @noFollowedHint.
  ///
  /// In en, this message translates to:
  /// **'Open a masjid and tap Follow to see it here and get its notices.'**
  String get noFollowedHint;

  /// No description provided for @reminderBadge.
  ///
  /// In en, this message translates to:
  /// **'Reminder {minutes} min'**
  String reminderBadge(String minutes);

  /// No description provided for @manageMasjids.
  ///
  /// In en, this message translates to:
  /// **'Manage Masjids'**
  String get manageMasjids;

  /// No description provided for @noMyMasjids.
  ///
  /// In en, this message translates to:
  /// **'You haven’t registered a masjid yet.'**
  String get noMyMasjids;

  /// No description provided for @noMyMasjidsHint.
  ///
  /// In en, this message translates to:
  /// **'Committee members, imam, khatib, moazzin or khadem can register their masjid. Our team verifies it before it goes public.'**
  String get noMyMasjidsHint;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

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

  /// No description provided for @appearanceHint.
  ///
  /// In en, this message translates to:
  /// **'Dark mode is easier on the eyes at Fajr and Isha.'**
  String get appearanceHint;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get pullToRefresh;

  /// No description provided for @verifyAutoCheck.
  ///
  /// In en, this message translates to:
  /// **'Open the link we emailed you — this page updates by itself once you\'re verified.'**
  String get verifyAutoCheck;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutTitle;

  /// No description provided for @signOutBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to see your followed masjids and get jamat reminders on this phone.'**
  String get signOutBody;

  /// No description provided for @jamatLine.
  ///
  /// In en, this message translates to:
  /// **'{prayer} Jamat {time}'**
  String jamatLine(String prayer, String time);

  /// No description provided for @scanBoard.
  ///
  /// In en, this message translates to:
  /// **'Scan time board'**
  String get scanBoard;

  /// No description provided for @scanBoardHint.
  ///
  /// In en, this message translates to:
  /// **'Snap the masjid\'s time board and all jamat times fill in by themselves — or tap a time to set it manually.'**
  String get scanBoardHint;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseGallery;

  /// No description provided for @scanStage1.
  ///
  /// In en, this message translates to:
  /// **'Looking at the time board…'**
  String get scanStage1;

  /// No description provided for @scanStage2.
  ///
  /// In en, this message translates to:
  /// **'Reading the digits…'**
  String get scanStage2;

  /// No description provided for @scanStage3.
  ///
  /// In en, this message translates to:
  /// **'Matching Fajr to Isha…'**
  String get scanStage3;

  /// No description provided for @scanStage4.
  ///
  /// In en, this message translates to:
  /// **'Checking Jum\'ah…'**
  String get scanStage4;

  /// No description provided for @scanFound.
  ///
  /// In en, this message translates to:
  /// **'Found {count} times'**
  String scanFound(String count);

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read this photo. Try a clear, straight photo of the board, or enter the times manually.'**
  String get scanFailed;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get enterManually;

  /// No description provided for @scanReview.
  ///
  /// In en, this message translates to:
  /// **'Times filled in from the photo (marked ✦). Check them, then tap Update.'**
  String get scanReview;

  /// No description provided for @tabRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get tabRead;

  /// No description provided for @readQuran.
  ///
  /// In en, this message translates to:
  /// **'Read Quran'**
  String get readQuran;

  /// No description provided for @journeySub.
  ///
  /// In en, this message translates to:
  /// **'Your journey through all 114 surahs'**
  String get journeySub;

  /// No description provided for @surahsProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of 114 surahs'**
  String surahsProgress(String done);

  /// No description provided for @versesRead.
  ///
  /// In en, this message translates to:
  /// **'verses read'**
  String get versesRead;

  /// No description provided for @phasesDone.
  ///
  /// In en, this message translates to:
  /// **'phases done'**
  String get phasesDone;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueReading;

  /// No description provided for @startReading.
  ///
  /// In en, this message translates to:
  /// **'Start reading'**
  String get startReading;

  /// No description provided for @phaseN.
  ///
  /// In en, this message translates to:
  /// **'Phase {n}'**
  String phaseN(String n);

  /// No description provided for @versesN.
  ///
  /// In en, this message translates to:
  /// **'{n} verses'**
  String versesN(String n);

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @ayahOf.
  ///
  /// In en, this message translates to:
  /// **'Ayah {n} of {total}'**
  String ayahOf(String n, String total);

  /// No description provided for @unlockHint.
  ///
  /// In en, this message translates to:
  /// **'Finish {surah} to unlock this surah.'**
  String unlockHint(String surah);

  /// No description provided for @quizUnlockHint.
  ///
  /// In en, this message translates to:
  /// **'Read every surah of this phase to unlock its quiz.'**
  String get quizUnlockHint;

  /// No description provided for @phaseQuiz.
  ///
  /// In en, this message translates to:
  /// **'Phase {n} quiz'**
  String phaseQuiz(String n);

  /// No description provided for @quizOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional · test what you read'**
  String get quizOptional;

  /// No description provided for @bestScore.
  ///
  /// In en, this message translates to:
  /// **'Best {score}%'**
  String bestScore(String score);

  /// No description provided for @makki.
  ///
  /// In en, this message translates to:
  /// **'Makki'**
  String get makki;

  /// No description provided for @madani.
  ///
  /// In en, this message translates to:
  /// **'Madani'**
  String get madani;

  /// No description provided for @loadingSurah.
  ///
  /// In en, this message translates to:
  /// **'Getting the surah…'**
  String get loadingSurah;

  /// No description provided for @completeSurah.
  ///
  /// In en, this message translates to:
  /// **'I\'ve finished this surah'**
  String get completeSurah;

  /// No description provided for @nextSurah.
  ///
  /// In en, this message translates to:
  /// **'Next surah'**
  String get nextSurah;

  /// No description provided for @surahDone.
  ///
  /// In en, this message translates to:
  /// **'MashaAllah! You finished Surah {name}.'**
  String surahDone(String name);

  /// No description provided for @nextUnlocked.
  ///
  /// In en, this message translates to:
  /// **'{name} is now unlocked.'**
  String nextUnlocked(String name);

  /// No description provided for @takeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take the phase quiz'**
  String get takeQuiz;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @wordByWord.
  ///
  /// In en, this message translates to:
  /// **'Word by word'**
  String get wordByWord;

  /// No description provided for @quranSource.
  ///
  /// In en, this message translates to:
  /// **'Mushaf text & word-by-word: quran.com (King Fahd Complex Uthmani script) · Translation: Saheeh International'**
  String get quranSource;

  /// No description provided for @startHere.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get startHere;

  /// No description provided for @quizWordMeaning.
  ///
  /// In en, this message translates to:
  /// **'What does this word mean?'**
  String get quizWordMeaning;

  /// No description provided for @quizAyahMeaning.
  ///
  /// In en, this message translates to:
  /// **'What does this ayah mean?'**
  String get quizAyahMeaning;

  /// No description provided for @quizWhichSurah.
  ///
  /// In en, this message translates to:
  /// **'Which surah is this ayah from?'**
  String get quizWhichSurah;

  /// No description provided for @quizRevealed.
  ///
  /// In en, this message translates to:
  /// **'Where was Surah {name} revealed?'**
  String quizRevealed(String name);

  /// No description provided for @makkah.
  ///
  /// In en, this message translates to:
  /// **'Makkah'**
  String get makkah;

  /// No description provided for @madinah.
  ///
  /// In en, this message translates to:
  /// **'Madinah'**
  String get madinah;

  /// No description provided for @quizVerses.
  ///
  /// In en, this message translates to:
  /// **'How many verses are in Surah {name}?'**
  String quizVerses(String name);

  /// No description provided for @quizNameMeans.
  ///
  /// In en, this message translates to:
  /// **'What does the name “{name}” mean?'**
  String quizNameMeans(String name);

  /// No description provided for @kindVocabulary.
  ///
  /// In en, this message translates to:
  /// **'VOCABULARY'**
  String get kindVocabulary;

  /// No description provided for @kindMeaning.
  ///
  /// In en, this message translates to:
  /// **'MEANING'**
  String get kindMeaning;

  /// No description provided for @kindSurah.
  ///
  /// In en, this message translates to:
  /// **'WHICH SURAH'**
  String get kindSurah;

  /// No description provided for @kindFacts.
  ///
  /// In en, this message translates to:
  /// **'SURAH FACTS'**
  String get kindFacts;

  /// No description provided for @quizCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct — MashaAllah!'**
  String get quizCorrect;

  /// No description provided for @quizWrong.
  ///
  /// In en, this message translates to:
  /// **'Not quite — the right answer is highlighted.'**
  String get quizWrong;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @quizScore.
  ///
  /// In en, this message translates to:
  /// **'You scored {score}%'**
  String quizScore(String score);

  /// No description provided for @quizDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Quizzes are optional — they help you remember what you read.'**
  String get quizDoneBody;

  /// No description provided for @quizLoading.
  ///
  /// In en, this message translates to:
  /// **'Preparing your quiz…'**
  String get quizLoading;

  /// No description provided for @tabQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get tabQuran;

  /// No description provided for @tabDua.
  ///
  /// In en, this message translates to:
  /// **'Dua'**
  String get tabDua;

  /// No description provided for @specialSurahs.
  ///
  /// In en, this message translates to:
  /// **'Recommended to read'**
  String get specialSurahs;

  /// No description provided for @chipMulk.
  ///
  /// In en, this message translates to:
  /// **'Al-Mulk'**
  String get chipMulk;

  /// No description provided for @chipMulkWhen.
  ///
  /// In en, this message translates to:
  /// **'Before sleep'**
  String get chipMulkWhen;

  /// No description provided for @chipSajdah.
  ///
  /// In en, this message translates to:
  /// **'As-Sajdah'**
  String get chipSajdah;

  /// No description provided for @chipKahf.
  ///
  /// In en, this message translates to:
  /// **'Al-Kahf'**
  String get chipKahf;

  /// No description provided for @chipKahfWhen.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get chipKahfWhen;

  /// No description provided for @chipKursi.
  ///
  /// In en, this message translates to:
  /// **'Ayatul Kursi'**
  String get chipKursi;

  /// No description provided for @chipKursiWhen.
  ///
  /// In en, this message translates to:
  /// **'After salah & sleep'**
  String get chipKursiWhen;

  /// No description provided for @chipBaqarahEnd.
  ///
  /// In en, this message translates to:
  /// **'Last 2 of Al-Baqarah'**
  String get chipBaqarahEnd;

  /// No description provided for @chipNight.
  ///
  /// In en, this message translates to:
  /// **'At night'**
  String get chipNight;

  /// No description provided for @chipYasin.
  ///
  /// In en, this message translates to:
  /// **'Ya-Sin'**
  String get chipYasin;

  /// No description provided for @chipQuls.
  ///
  /// In en, this message translates to:
  /// **'3 Quls'**
  String get chipQuls;

  /// No description provided for @chipQulsWhen.
  ///
  /// In en, this message translates to:
  /// **'Morning & evening'**
  String get chipQulsWhen;

  /// No description provided for @chipAnytime.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get chipAnytime;

  /// No description provided for @chipToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get chipToday;

  /// No description provided for @chipTonight.
  ///
  /// In en, this message translates to:
  /// **'Tonight'**
  String get chipTonight;

  /// No description provided for @revealedMakkah.
  ///
  /// In en, this message translates to:
  /// **'Revealed in Makkah'**
  String get revealedMakkah;

  /// No description provided for @revealedMadinah.
  ///
  /// In en, this message translates to:
  /// **'Revealed in Madinah'**
  String get revealedMadinah;

  /// No description provided for @reciter.
  ///
  /// In en, this message translates to:
  /// **'Reciter'**
  String get reciter;

  /// No description provided for @chooseReciter.
  ///
  /// In en, this message translates to:
  /// **'Choose a reciter'**
  String get chooseReciter;

  /// No description provided for @playAyah.
  ///
  /// In en, this message translates to:
  /// **'Play from this ayah'**
  String get playAyah;

  /// No description provided for @recitingAyah.
  ///
  /// In en, this message translates to:
  /// **'Ayah {n} of {total}'**
  String recitingAyah(String n, String total);

  /// No description provided for @audioError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the recitation. Check your internet.'**
  String get audioError;

  /// No description provided for @dailyQuran.
  ///
  /// In en, this message translates to:
  /// **'Daily Quran'**
  String get dailyQuran;

  /// No description provided for @energy0.
  ///
  /// In en, this message translates to:
  /// **'Your heart is waiting for light today'**
  String get energy0;

  /// No description provided for @energy1.
  ///
  /// In en, this message translates to:
  /// **'Charging… a few more ayat'**
  String get energy1;

  /// No description provided for @energy2.
  ///
  /// In en, this message translates to:
  /// **'Almost full — keep going!'**
  String get energy2;

  /// No description provided for @energy3.
  ///
  /// In en, this message translates to:
  /// **'Full of light — MashaAllah!'**
  String get energy3;

  /// No description provided for @energy4.
  ///
  /// In en, this message translates to:
  /// **'Shining bright today ✨'**
  String get energy4;

  /// No description provided for @versesToday.
  ///
  /// In en, this message translates to:
  /// **'{n} / {goal} ayat today'**
  String versesToday(String n, String goal);

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{n}-day streak'**
  String streakDays(String n);

  /// No description provided for @readNow.
  ///
  /// In en, this message translates to:
  /// **'Read now'**
  String get readNow;

  /// No description provided for @keepReading.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get keepReading;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @achievementsCount.
  ///
  /// In en, this message translates to:
  /// **'{n} of {total} earned'**
  String achievementsCount(String n, String total);

  /// No description provided for @achievementEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned on {date}'**
  String achievementEarned(String date);

  /// No description provided for @achievementLocked.
  ///
  /// In en, this message translates to:
  /// **'In progress · {done}/{target}'**
  String achievementLocked(String done, String target);

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement unlocked: {name}'**
  String achievementUnlocked(String name);

  /// No description provided for @ach_bismillah.
  ///
  /// In en, this message translates to:
  /// **'Bismillah'**
  String get ach_bismillah;

  /// No description provided for @ach_bismillah_desc.
  ///
  /// In en, this message translates to:
  /// **'Read your first ayah'**
  String get ach_bismillah_desc;

  /// No description provided for @ach_fatiha.
  ///
  /// In en, this message translates to:
  /// **'The Opener'**
  String get ach_fatiha;

  /// No description provided for @ach_fatiha_desc.
  ///
  /// In en, this message translates to:
  /// **'Complete Surah Al-Fatihah'**
  String get ach_fatiha_desc;

  /// No description provided for @ach_quls.
  ///
  /// In en, this message translates to:
  /// **'Three Quls'**
  String get ach_quls;

  /// No description provided for @ach_quls_desc.
  ///
  /// In en, this message translates to:
  /// **'Complete Al-Ikhlas, Al-Falaq and An-Nas'**
  String get ach_quls_desc;

  /// No description provided for @ach_streak3.
  ///
  /// In en, this message translates to:
  /// **'Steady Steps'**
  String get ach_streak3;

  /// No description provided for @ach_streak3_desc.
  ///
  /// In en, this message translates to:
  /// **'Read Quran 3 days in a row'**
  String get ach_streak3_desc;

  /// No description provided for @ach_streak7.
  ///
  /// In en, this message translates to:
  /// **'Week of Light'**
  String get ach_streak7;

  /// No description provided for @ach_streak7_desc.
  ///
  /// In en, this message translates to:
  /// **'Read Quran 7 days in a row'**
  String get ach_streak7_desc;

  /// No description provided for @ach_streak30.
  ///
  /// In en, this message translates to:
  /// **'Month of Noor'**
  String get ach_streak30;

  /// No description provided for @ach_streak30_desc.
  ///
  /// In en, this message translates to:
  /// **'Read Quran 30 days in a row'**
  String get ach_streak30_desc;

  /// No description provided for @ach_verses100.
  ///
  /// In en, this message translates to:
  /// **'Hundred Ayat'**
  String get ach_verses100;

  /// No description provided for @ach_verses100_desc.
  ///
  /// In en, this message translates to:
  /// **'Read 100 ayat'**
  String get ach_verses100_desc;

  /// No description provided for @ach_verses1000.
  ///
  /// In en, this message translates to:
  /// **'Thousand Ayat'**
  String get ach_verses1000;

  /// No description provided for @ach_verses1000_desc.
  ///
  /// In en, this message translates to:
  /// **'Read 1,000 ayat'**
  String get ach_verses1000_desc;

  /// No description provided for @ach_kahf.
  ///
  /// In en, this message translates to:
  /// **'Friday Light'**
  String get ach_kahf;

  /// No description provided for @ach_kahf_desc.
  ///
  /// In en, this message translates to:
  /// **'Complete Al-Kahf on a Friday'**
  String get ach_kahf_desc;

  /// No description provided for @ach_mulk.
  ///
  /// In en, this message translates to:
  /// **'Night Guardian'**
  String get ach_mulk;

  /// No description provided for @ach_mulk_desc.
  ///
  /// In en, this message translates to:
  /// **'Complete Al-Mulk at night'**
  String get ach_mulk_desc;

  /// No description provided for @ach_yasin.
  ///
  /// In en, this message translates to:
  /// **'Ya-Sin'**
  String get ach_yasin;

  /// No description provided for @ach_yasin_desc.
  ///
  /// In en, this message translates to:
  /// **'Complete Surah Ya-Sin'**
  String get ach_yasin_desc;

  /// No description provided for @ach_listener.
  ///
  /// In en, this message translates to:
  /// **'Attentive Listener'**
  String get ach_listener;

  /// No description provided for @ach_listener_desc.
  ///
  /// In en, this message translates to:
  /// **'Listen to a whole surah recitation'**
  String get ach_listener_desc;

  /// No description provided for @ach_quiz100.
  ///
  /// In en, this message translates to:
  /// **'Sharp Mind'**
  String get ach_quiz100;

  /// No description provided for @ach_quiz100_desc.
  ///
  /// In en, this message translates to:
  /// **'Score 100% in a phase quiz'**
  String get ach_quiz100_desc;

  /// No description provided for @ach_juzamma.
  ///
  /// In en, this message translates to:
  /// **'Juz \'Amma'**
  String get ach_juzamma;

  /// No description provided for @ach_juzamma_desc.
  ///
  /// In en, this message translates to:
  /// **'Complete all 37 surahs of the 30th juz'**
  String get ach_juzamma_desc;

  /// No description provided for @ach_phases10.
  ///
  /// In en, this message translates to:
  /// **'Ten Phases'**
  String get ach_phases10;

  /// No description provided for @ach_phases10_desc.
  ///
  /// In en, this message translates to:
  /// **'Complete 10 phases of the journey'**
  String get ach_phases10_desc;

  /// No description provided for @ach_khatm.
  ///
  /// In en, this message translates to:
  /// **'Khatm al-Quran'**
  String get ach_khatm;

  /// No description provided for @ach_khatm_desc.
  ///
  /// In en, this message translates to:
  /// **'Complete all 114 surahs'**
  String get ach_khatm_desc;

  /// No description provided for @duaHeader.
  ///
  /// In en, this message translates to:
  /// **'A day with the remembrance of Allah'**
  String get duaHeader;

  /// No description provided for @duaSub.
  ///
  /// In en, this message translates to:
  /// **'From waking up to sleeping — the duas the Prophet ﷺ taught for every moment.'**
  String get duaSub;

  /// No description provided for @repeatTimes.
  ///
  /// In en, this message translates to:
  /// **'Say {n}×'**
  String repeatTimes(String n);

  /// No description provided for @duaSource.
  ///
  /// In en, this message translates to:
  /// **'Hisn al-Muslim #{n}'**
  String duaSource(String n);

  /// No description provided for @duaCredit.
  ///
  /// In en, this message translates to:
  /// **'Duas from Hisn al-Muslim (Fortress of the Muslim) by Sa’id bin Ali al-Qahtani, via its official site hisnmuslim.com.'**
  String get duaCredit;

  /// No description provided for @nowLabel.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get nowLabel;

  /// No description provided for @scene_wake.
  ///
  /// In en, this message translates to:
  /// **'Waking up'**
  String get scene_wake;

  /// No description provided for @scene_wake_story.
  ///
  /// In en, this message translates to:
  /// **'The day begins with thanks — Allah returned the soul after sleep.'**
  String get scene_wake_story;

  /// No description provided for @scene_restroom.
  ///
  /// In en, this message translates to:
  /// **'Restroom'**
  String get scene_restroom;

  /// No description provided for @scene_restroom_story.
  ///
  /// In en, this message translates to:
  /// **'Even the smallest routine begins by seeking Allah’s protection.'**
  String get scene_restroom_story;

  /// No description provided for @scene_wudu.
  ///
  /// In en, this message translates to:
  /// **'Wudu'**
  String get scene_wudu;

  /// No description provided for @scene_wudu_story.
  ///
  /// In en, this message translates to:
  /// **'Water on the hands, His name on the tongue — getting ready to stand before Allah.'**
  String get scene_wudu_story;

  /// No description provided for @scene_dress.
  ///
  /// In en, this message translates to:
  /// **'Getting dressed'**
  String get scene_dress;

  /// No description provided for @scene_dress_story.
  ///
  /// In en, this message translates to:
  /// **'Every garment is a gift — thank the One who clothed you.'**
  String get scene_dress_story;

  /// No description provided for @scene_athan.
  ///
  /// In en, this message translates to:
  /// **'The adhan'**
  String get scene_athan;

  /// No description provided for @scene_athan_story.
  ///
  /// In en, this message translates to:
  /// **'The call rises over the neighbourhood — answer it, then ask for the Prophet ﷺ.'**
  String get scene_athan_story;

  /// No description provided for @scene_masjid.
  ///
  /// In en, this message translates to:
  /// **'To the masjid'**
  String get scene_masjid;

  /// No description provided for @scene_masjid_story.
  ///
  /// In en, this message translates to:
  /// **'Each step toward the masjid is light — enter and leave with dua.'**
  String get scene_masjid_story;

  /// No description provided for @scene_after_salah.
  ///
  /// In en, this message translates to:
  /// **'After salah'**
  String get scene_after_salah;

  /// No description provided for @scene_after_salah_story.
  ///
  /// In en, this message translates to:
  /// **'Before rushing off, sit a moment with the remembrance after salah.'**
  String get scene_after_salah_story;

  /// No description provided for @scene_morning.
  ///
  /// In en, this message translates to:
  /// **'Morning adhkar'**
  String get scene_morning;

  /// No description provided for @scene_morning_story.
  ///
  /// In en, this message translates to:
  /// **'Words that guard you until evening.'**
  String get scene_morning_story;

  /// No description provided for @scene_eating.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get scene_eating;

  /// No description provided for @scene_eating_story.
  ///
  /// In en, this message translates to:
  /// **'Begin with His name, end with His praise.'**
  String get scene_eating_story;

  /// No description provided for @scene_leave_home.
  ///
  /// In en, this message translates to:
  /// **'Stepping out'**
  String get scene_leave_home;

  /// No description provided for @scene_leave_home_story.
  ///
  /// In en, this message translates to:
  /// **'At the door, hand your day over to Allah.'**
  String get scene_leave_home_story;

  /// No description provided for @scene_travel.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get scene_travel;

  /// No description provided for @scene_travel_story.
  ///
  /// In en, this message translates to:
  /// **'Bus, rickshaw or car — Allahu Akbar going up, SubhanAllah coming down.'**
  String get scene_travel_story;

  /// No description provided for @scene_meeting.
  ///
  /// In en, this message translates to:
  /// **'Meeting people'**
  String get scene_meeting;

  /// No description provided for @scene_meeting_story.
  ///
  /// In en, this message translates to:
  /// **'Spread salam and answer a brother’s sneeze.'**
  String get scene_meeting_story;

  /// No description provided for @scene_good_news.
  ///
  /// In en, this message translates to:
  /// **'When good things happen'**
  String get scene_good_news;

  /// No description provided for @scene_good_news_story.
  ///
  /// In en, this message translates to:
  /// **'Joy is a reminder of the Giver — praise Him, and thank the people too.'**
  String get scene_good_news_story;

  /// No description provided for @scene_hardship.
  ///
  /// In en, this message translates to:
  /// **'When it gets hard'**
  String get scene_hardship;

  /// No description provided for @scene_hardship_story.
  ///
  /// In en, this message translates to:
  /// **'Worry, difficulty or a plan that failed — turn to Him first.'**
  String get scene_hardship_story;

  /// No description provided for @scene_patience.
  ///
  /// In en, this message translates to:
  /// **'Loss and patience'**
  String get scene_patience;

  /// No description provided for @scene_patience_story.
  ///
  /// In en, this message translates to:
  /// **'When something is taken, remember that we belong to Allah.'**
  String get scene_patience_story;

  /// No description provided for @scene_anger.
  ///
  /// In en, this message translates to:
  /// **'Holding back anger'**
  String get scene_anger;

  /// No description provided for @scene_anger_story.
  ///
  /// In en, this message translates to:
  /// **'Seek refuge before words you may regret.'**
  String get scene_anger_story;

  /// No description provided for @scene_pain.
  ///
  /// In en, this message translates to:
  /// **'Pain and sickness'**
  String get scene_pain;

  /// No description provided for @scene_pain_story.
  ///
  /// In en, this message translates to:
  /// **'For your own pain, and for a friend you visit.'**
  String get scene_pain_story;

  /// No description provided for @scene_rain.
  ///
  /// In en, this message translates to:
  /// **'When it rains'**
  String get scene_rain;

  /// No description provided for @scene_rain_story.
  ///
  /// In en, this message translates to:
  /// **'Rain is mercy — ask for it to be beneficial.'**
  String get scene_rain_story;

  /// No description provided for @scene_home.
  ///
  /// In en, this message translates to:
  /// **'Back home'**
  String get scene_home;

  /// No description provided for @scene_home_story.
  ///
  /// In en, this message translates to:
  /// **'Enter with His name and greet your family.'**
  String get scene_home_story;

  /// No description provided for @scene_gathering.
  ///
  /// In en, this message translates to:
  /// **'Leaving a gathering'**
  String get scene_gathering;

  /// No description provided for @scene_gathering_story.
  ///
  /// In en, this message translates to:
  /// **'Before you stand up, wipe away the slips of the tongue.'**
  String get scene_gathering_story;

  /// No description provided for @scene_forgiveness.
  ///
  /// In en, this message translates to:
  /// **'Seeking forgiveness'**
  String get scene_forgiveness;

  /// No description provided for @scene_forgiveness_story.
  ///
  /// In en, this message translates to:
  /// **'The day’s mistakes, washed in istighfar.'**
  String get scene_forgiveness_story;

  /// No description provided for @scene_sleep.
  ///
  /// In en, this message translates to:
  /// **'Before sleep'**
  String get scene_sleep;

  /// No description provided for @scene_sleep_story.
  ///
  /// In en, this message translates to:
  /// **'End the day as it began — in His name, under His protection.'**
  String get scene_sleep_story;

  /// No description provided for @scene_night.
  ///
  /// In en, this message translates to:
  /// **'In the night'**
  String get scene_night;

  /// No description provided for @scene_night_story.
  ///
  /// In en, this message translates to:
  /// **'If you wake or have a bad dream, He is near.'**
  String get scene_night_story;

  /// No description provided for @part_dawn.
  ///
  /// In en, this message translates to:
  /// **'Dawn'**
  String get part_dawn;

  /// No description provided for @part_morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get part_morning;

  /// No description provided for @part_day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get part_day;

  /// No description provided for @part_evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get part_evening;

  /// No description provided for @part_night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get part_night;

  /// No description provided for @removeSession.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeSession;

  /// No description provided for @addSession.
  ///
  /// In en, this message translates to:
  /// **'Add {session}'**
  String addSession(String session);

  /// No description provided for @duaSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search duas'**
  String get duaSearchHint;

  /// No description provided for @duaPartCount.
  ///
  /// In en, this message translates to:
  /// **'{topics} topics · {duas} duas'**
  String duaPartCount(String topics, String duas);

  /// No description provided for @duaNoResults.
  ///
  /// In en, this message translates to:
  /// **'No dua found for “{q}”'**
  String duaNoResults(String q);

  /// No description provided for @duaResults.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 dua found} other{{n} duas found}}'**
  String duaResults(int n);

  /// No description provided for @part_dawn_sub.
  ///
  /// In en, this message translates to:
  /// **'Waking, wudu and Fajr'**
  String get part_dawn_sub;

  /// No description provided for @part_morning_sub.
  ///
  /// In en, this message translates to:
  /// **'Adhkar, food and going out'**
  String get part_morning_sub;

  /// No description provided for @part_day_sub.
  ///
  /// In en, this message translates to:
  /// **'People, joys and trials'**
  String get part_day_sub;

  /// No description provided for @part_evening_sub.
  ///
  /// In en, this message translates to:
  /// **'Home, gatherings, istighfar'**
  String get part_evening_sub;

  /// No description provided for @part_night_sub.
  ///
  /// In en, this message translates to:
  /// **'Sleep and the night'**
  String get part_night_sub;

  /// No description provided for @duaCount.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 dua} other{{n} duas}}'**
  String duaCount(int n);
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return L10nBn();
    case 'en':
      return L10nEn();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
