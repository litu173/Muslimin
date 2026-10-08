import 'package:flutter/widgets.dart';

/// A language the app can be shown in.
class AppLanguage {
  const AppLanguage(this.code, this.nativeName);

  final String code;

  /// The language's name in itself ("বাংলা", "اردو"…).
  final String nativeName;

  Locale get locale => Locale(code);
  bool get rtl => code == 'ar' || code == 'ur';
}

/// Every app language, in the order of the language picker.
const kAppLanguages = [
  AppLanguage('bn', 'বাংলা'),
  AppLanguage('en', 'English'),
  AppLanguage('ar', 'العربية'),
  AppLanguage('ur', 'اردو'),
  AppLanguage('hi', 'हिन्दी'),
  AppLanguage('id', 'Bahasa Indonesia'),
  AppLanguage('ms', 'Bahasa Melayu'),
  AppLanguage('tr', 'Türkçe'),
  AppLanguage('es', 'Español'),
];

AppLanguage languageOf(String code) => kAppLanguages.firstWhere(
  (l) => l.code == code,
  orElse: () => kAppLanguages[1],
);
