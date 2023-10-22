import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class SettingsNotifier extends AsyncNotifier<Settings> {
  late final SharedPreferences _prefs;

  @override
  Future<Settings> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _loadSettings();
  }

  Future<Settings> _loadSettings() async {
    final String? localeString = _prefs.getString('locale');
    final String? themeModeString = _prefs.getString('themeMode');

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

  Future<void> updateSettings(Settings settings) async {
    state = const AsyncValue.loading();

    final String? localeString = settings.locale?.languageCode;
    final String themeModeString = switch (settings.themeMode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    state = await AsyncValue.guard(() async {
      // Store all settings in parallel
      final List<Future<void>> futures = [
        _prefs.setString('themeMode', themeModeString),
        _prefs.setString('locale', localeString ?? ''),
      ];
      await Future.wait(futures);

      return _loadSettings();
    });
  }

  /// Parses the given [localeString] and returns a [Locale] object.
  /// Returns null if the [localeString] is null, empty or unsupported.
  Locale? _parseLocale(String? localeString) {
    if (localeString == null) return null;
    if (localeString.isEmpty) return null;

    Locale locale = Locale(localeString);
    if (!AppLocalizations.supportedLocales.contains(locale)) return null;

    return locale;
  }
}
