import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/settings.dart';

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, Settings>(() {
  return SettingsNotifier();
});

final themeModeAndLocaleProvider =
    FutureProvider<(ThemeMode, Locale?)>((ref) async {
  final settings = await ref.watch(settingsProvider.future);
  return (settings.themeMode, settings.locale);
});
