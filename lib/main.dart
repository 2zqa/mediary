import 'dart:async';
import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals/shared_preferences.dart';
import 'providers/settings_provider.dart';
import 'routes/home/home.dart';

/// Returns the [RenderView] associated with the implicit [FlutterView], if any.
/// Call this function after runApp has been called.
///
/// Does not support multi-window support.
/// Taken from: https://github.com/flutter/packages/blob/5f44e3d/packages/url_launcher/url_launcher/lib/src/legacy_api.dart#L157
RenderView? _findImplicitRenderView(WidgetsBinding binding) {
  final FlutterView? implicitFlutterView =
      binding.platformDispatcher.implicitView;
  if (implicitFlutterView == null) {
    return null;
  }
  return binding.renderViews
      .where((RenderView v) => v.flutterView == implicitFlutterView)
      .firstOrNull;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  runApp(
    const ProviderScope(
      child: MediaryApp(),
    ),
  );
}

/// Makes the navigation bar transparent.
///
/// This function takes a [RenderView] as a parameter and makes the navigation bar transparent.
/// The [RenderView] is used to access the current view and modify its properties.
/// If the [RenderView] is null, no action is taken.
void _makeNavBarTransparent(RenderView? renderView) {
  unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  renderView?.automaticSystemUiAdjustment = false;
}

final _defaultLightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurple,
);

final _defaultDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.deepPurple,
);

class MediaryApp extends ConsumerStatefulWidget {
  const MediaryApp({super.key});

  @override
  ConsumerState<MediaryApp> createState() => _MediaryAppState();
}

class _MediaryAppState extends ConsumerState<MediaryApp> {
  @override
  void initState() {
    final renderView = _findImplicitRenderView(WidgetsBinding.instance);
    _makeNavBarTransparent(renderView);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          ),
          home: const HomePage('Mediary'),
        );
      },
    );
  }
}
