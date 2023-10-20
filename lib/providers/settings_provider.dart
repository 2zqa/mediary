import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/settings.dart';

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, Settings>(() {
  return SettingsNotifier();
});
