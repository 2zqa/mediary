import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/settings.dart';

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, Settings>(() {
  return SettingsNotifier();
});

final themeModeProvider = FutureProvider<ThemeMode>((ref) async {
  final settings = await ref.watch(settingsProvider.future);
  return settings.themeMode;
});

final localeProvider = FutureProvider<Locale?>((ref) async {
  final settings = await ref.watch(settingsProvider.future);
  return settings.locale;
});
