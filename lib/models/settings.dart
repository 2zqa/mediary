import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../globals/shared_preferences.dart';

@immutable
class Settings {
  final Locale? locale;
  final ThemeMode themeMode;

  const Settings({
    this.locale,
    this.themeMode = ThemeMode.system,
  });

  /// Returns a copy of this [Settings] with the given fields replaced with the
  /// new values. If [locale] is omitted, it will be set to null.
  Settings nullableCopyWith({
    Locale? locale,
    ThemeMode? themeMode,
  }) =>
      Settings(
        locale: locale,
        themeMode: themeMode ?? this.themeMode,
      );

  @override
  String toString() {
    return 'Settings(locale: $locale, themeMode: $themeMode)';
  }
}

class SettingsNotifier extends Notifier<Settings> {
  @override
  Settings build() {
    final String? localeString = prefs.getString('locale');
    final String? themeModeString = prefs.getString('themeMode');

    final Locale? locale = _parseLocale(localeString);
    final ThemeMode themeMode = switch (themeModeString) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };

    return Settings(
      locale: locale,
      themeMode: themeMode,
    );
  }

  void updateSettings(Settings settings) async {
    final String? localeString = settings.locale?.languageCode;
    final String themeModeString = switch (settings.themeMode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };

    unawaited(prefs.setString('themeMode', themeModeString));
    unawaited(prefs.setString('locale', localeString ?? ''));
    state = settings;
  }

  /// Parses the given [localeString] and returns a [Locale] object.
  /// Returns null if the [localeString] is null, empty or unsupported.
  Locale? _parseLocale(String? localeString) {
    if (localeString == null) return null;
    if (localeString.isEmpty) return null;

    final Locale locale = Locale(localeString);
    if (!AppLocalizations.supportedLocales.contains(locale)) return null;

    return locale;
  }
}
