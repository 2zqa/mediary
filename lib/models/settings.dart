import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class Settings {
  final Locale? locale;
  final ThemeMode themeMode;

  const Settings({
    this.locale,
    this.themeMode = ThemeMode.system,
  });

  Settings copy({
    Locale? locale,
    ThemeMode? themeMode,
  }) =>
      Settings(
        locale: locale ?? this.locale,
        themeMode: themeMode ?? this.themeMode,
      );
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

    final Locale? locale = localeString != null ? Locale(localeString) : null;
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
      final List<Future<void>> futures = [];
      futures.add(_prefs.setString('themeMode', themeModeString));
      if (localeString != null) {
        futures.add(_prefs.setString('locale', localeString));
      }
      await Future.wait(futures);

      return _loadSettings();
    });
  }
}
