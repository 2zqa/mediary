import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals/shared_preferences.dart';
import 'providers/settings_provider.dart';

import 'routes/home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(
    const ProviderScope(
      child: MediaryApp(),
    ),
  );
}

final _defaultLightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurple,
);

final _defaultDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.deepPurple,
);

class MediaryApp extends ConsumerWidget {
  const MediaryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (themeMode, locale) = ref.watch(themeModeAndLocaleProvider);
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          title: 'Mediary',
          themeMode: themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
            useMaterial3: true,
          ),
          home: const HomePage('Mediary'),
        );
      },
    );
  }
}
