import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../models/settings.dart';
import '../../providers/settings_provider.dart';
import '../../util/radio_button_dialog.dart';

class ThemeTile extends AbstractSettingsTile {
  const ThemeTile({
    super.key,
  });

  String _themeModeToString(
      ThemeMode themeMode, AppLocalizations localizations) {
    return switch (themeMode) {
      ThemeMode.light => localizations.lightThemeText,
      ThemeMode.dark => localizations.darkThemeText,
      ThemeMode.system => localizations.systemThemeText,
    };
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, child) {
        final String themeModeLabel =
            _themeModeToString(ref.watch(themeModeProvider), localizations);
        return SettingsTile(
          leading: const Icon(Icons.brightness_6_outlined),
          title: Text(localizations.settingsViewThemeFieldTitle),
          value: Text(themeModeLabel),
          onPressed: (context) async {
            final ThemeMode? themeMode = await showRadioDialog<ThemeMode>(
              context: context,
              values: ThemeMode.values,
              labelBuilder: (themeMode) =>
                  _themeModeToString(themeMode, localizations),
              title: Text(localizations.settingsViewThemeFieldTitle),
            );

            if (themeMode == null) return;
            final Settings settings = ref.read(settingsProvider);
            final Settings updatedSettings = settings.nullableCopyWith(
              themeMode: themeMode,
              locale: settings.locale,
            );
            return ref
                .read(settingsProvider.notifier)
                .updateSettings(updatedSettings);
          },
        );
      },
    );
  }
}
