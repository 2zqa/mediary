import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/settings.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, Settings>(() {
  return SettingsNotifier();
});

final themeModeAndLocaleProvider = Provider<(ThemeMode, Locale?)>((ref) {
  final settings = ref.watch(settingsProvider);
  return (settings.themeMode, settings.locale);
});
