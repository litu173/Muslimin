# Muslimin Beta — Masjid jamat times

> **Public beta.** During the beta any signed-in account can register a masjid without SMS verification. The phone number is typed in and marked *not verified* for the admin. Set `kBeta = false` in `muslimin_app/lib/core/config.dart` for the stable release, which also needs Phone auth on the Blaze plan.

Free Android and iPhone app, in English and Bangla. It shows the masjids near you with each masjid's own jamat times, reminds you before jamat and shows masjid notices. Masjid authorities register their own masjid, and an admin verifies every profile before it goes public.

**Website & downloads:** https://litu173.github.io/Muslimin/

```
Muslimin/
├── muslimin_app/   Flutter app (Android, iOS, and a web build for the admin panel)
├── firebase/       Firestore rules + indexes, Cloud Functions (push for notices)
└── docs/           Landing page (GitHub Pages) with download links + QR code
```

## Accounts

| Who | How | Can do |
|---|---|---|
| User | Signs in after onboarding with email or Google (required by default; set `kRequireAccount = false` in `lib/core/config.dart` to allow guests) | Browse nearby masjids, follow them (More → Followed Masjids), get reminders and notices |
| Account | Email + password or **Google** (sign up, sign in, forgot password, change password, delete account) | Same as guest, plus followed masjids and reminders are saved in the cloud and synced across phones |
| Masjid authority | Account + phone (OTP-verified, or typed during beta) + registration rules | Manage their masjid's jamat, maktab, staff, live link and notices (after approval) |
| Super admin | `users/{uid}.role = "superAdmin"` set in the Firestore console | Approve, reject, suspend or restore masjids |

Data lives in **Firebase**, project `muslimin-app-bd`, with Firestore in `asia-south1`:
* `users/{uid}` holds name, email, phone, role, follows and FCM tokens. A user can read and write only their own document and can't change their own role.
* `masjids/{id}` is readable by everyone once approved. Pending profiles are visible only to the owner and admins.
* `notices/{id}` is public to read. Only the approved masjid's owner can write.

The rules are in [`firebase/firestore.rules`](firebase/firestore.rules). Deploy them with:

```bash
cd firebase
firebase deploy --only firestore
```

### One-time console steps
1. **Authentication**: Email/Password and Google are enabled. Password-reset and verification emails are sent by Firebase. You can edit the templates under *Authentication → Templates*.
2. **Phone sign-in** (OTP for masjid authorities) and **Cloud Functions** (push notifications for notices) need the **Blaze** (pay-as-you-go) plan. Both have a free monthly allowance. After upgrading, enable *Phone* in Authentication and deploy the functions:
   ```bash
   cd firebase/functions && npm install
   cd .. && firebase deploy --only functions
   ```
3. Make yourself admin: sign up in the app, then in *Firestore → users → your uid* set `role` to `superAdmin`.
4. iOS push and phone auth: upload an APNs key in *Project settings → Cloud Messaging*.

## Run locally

```bash
cd muslimin_app
flutter run                        # uses the real Firebase project
flutter run --dart-define=DEMO=true
```

`DEMO=true` uses offline sample data. In demo mode:
* Accounts: `demo@muslimin.app` / `demo1234` (owns a masjid) and `admin@muslimin.app` / `admin1234` (super admin)
* OTP code: `123456`

## Making a release

Android users can also update from inside the app: *More → About the App → App version* checks the latest GitHub release and offers the new APK.

The landing page always links to `releases/latest/download/Muslimin.apk` and `Muslimin-iOS.ipa`, so publishing a new GitHub release updates the website automatically.

```bash
cd muslimin_app
flutter build apk --release
flutter build ios --release --no-codesign
cd build/ios/iphoneos && mkdir -p Payload && cp -r Runner.app Payload/ && zip -qr Muslimin-iOS.ipa Payload && cd -
cp build/app/outputs/flutter-apk/app-release.apk Muslimin.apk
gh release create v1.0.1 Muslimin.apk build/ios/iphoneos/Muslimin-iOS.ipa --title "Muslimin v1.0.1" --notes "…"
```

* **Android signing:** `android/key.properties` and `android/app/upload-keystore.jks` exist only on the build machine and are git-ignored. **Back them up.** Without them you can't publish updates that install over the existing app.
* **iOS:** the IPA is unsigned and is meant for sideloading (AltStore or Sideloadly). Public iPhone distribution needs an Apple Developer account and the App Store or TestFlight. Once it's live, point `IOS_URL` in `docs/index.html` to the App Store link.

## Design system

The tokens come from the Figma file and live in `lib/core/theme/`:

| Token | Value |
|---|---|
| ink | `#002828` |
| gold | `#BB8907` |
| goldLight | `#FFC940` |
| cream | `#F3EED5` |
| card | `#FFFDF5` |
| teal | `#74C5B3` |

Other values:
* Radius: 20 for cards, 7 for buttons.
* Dark mode: *More → App Settings → Appearance* (System / Light / Dark). Every token in `app_colors.dart` has a light and a dark value.
* Fonts: Poppins (Latin), Hind Siliguri (Bangla), Grenze Gotisch at weight 800 (wordmark and prayer names) and Galada (Bangla prayer names).

## Credits

Fonts bundled with the app are free under the [SIL Open Font License 1.1](https://openfontlicense.org). The licence texts are in `muslimin_app/assets/licenses/` and also appear in the app under *About → Open-source licences*.

| Font | Used for | Author |
|---|---|---|
| [Grenze Gotisch](https://github.com/Omnibus-Type/Grenze-Gotisch) | Logo and prayer names | Omnibus-Type (Renata Polastri, Pablo Cosgaya) |
| [Poppins](https://github.com/itfoundry/Poppins) | Latin text | Indian Type Foundry, Jonny Pinhorn |
| [Hind Siliguri](https://github.com/itfoundry/hind-siliguri) | Bangla text | Indian Type Foundry |
| [Anek Bangla](https://github.com/EkType/Anek) | Bangla digits (times, dates) – cut to `BanglaDigits` by `tool/build_bangla_digits.py` | Ek Type |
| [Galada](https://fonts.google.com/specimen/Galada) | Bangla prayer names | Black Foundry |
| [Amiri](https://github.com/aliftype/amiri) | Quranic ayat | Khaled Hosny |

The design asks for **Li Ador Noirrit** (Lipighor) for Bangla times. Lipighor's free licence does not allow redistributing the font file, which bundling it in an app would do, so Anek Bangla is used until Lipighor grants permission (admin@lipighor.com); then replace the `BanglaDigits` files.

The logo and English prayer names are vector artwork from the design (`assets/brand`, `assets/prayers`).

The Figma design uses **Hidayatullah** by Anthonie Van Hayu (ARToni). Its free DEMO version is licensed for personal use only, so the app uses Grenze Gotisch instead. To use the original, buy a licence from [MyFonts](https://www.myfonts.com/collections/hidayatullah-font-artoni) and replace the `GrenzeGotisch` family in `pubspec.yaml` and `lib/core/theme/app_text.dart`.

## Notes
* Prayer times use the Karachi method with Hanafi Asr. Users can change both in Settings.
* The Bangla hadith and ayah translations should be reviewed by a scholar.
* Jamat reminders are local, repeating notifications, so they work offline and cover up to 5 followed masjids (the iOS limit is 64 pending notifications).
