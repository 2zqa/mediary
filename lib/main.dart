import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mediary/providers/settings_provider.dart';

import 'routes/home/home.dart';

void main() {
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    const ProviderScope(
      child: MediaryApp(),
    ),
  );
}

class MediaryApp extends ConsumerWidget {
  const MediaryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsyncValue = ref.watch(themeModeAndLocaleProvider);
    return themeAsyncValue.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (themeModeAndLocale) {
        final (themeMode, locale) = themeModeAndLocale;
        return MaterialApp(
          title: 'Mediary',
          themeMode: themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ),
          home: const HomePage('Mediary'),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
