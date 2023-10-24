import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../models/settings.dart';
import '../../providers/settings_provider.dart';
import '../../util/radio_button_dialog.dart';

const double optionWidth = 175.0;

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scrollbar(
      child: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).colorScheme.background,
        ),
        darkTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).colorScheme.background,
        ),
        sections: [
          SettingsSection(
            title: Text(
                AppLocalizations.of(context)!.settingsViewCommonSectionTitle),
            tiles: const <AbstractSettingsTile>[
              ThemeTile(),
              LanguageTile(),
            ],
          ),
          SettingsSection(
            title: Text(
                AppLocalizations.of(context)!.settingsViewDataSectionTitle),
            tiles: <SettingsTile>[
              _buildImportDrugsTile(context),
              _buildExportDrugsTile(context),
            ],
          ),
        ],
      ),
    );
  }

  SettingsTile _buildImportDrugsTile(BuildContext context) {
    return SettingsTile(
      leading: const Icon(Icons.file_download_outlined),
      title:
          Text(AppLocalizations.of(context)!.settingsViewImportDrugsFieldTitle),
    );
  }

  SettingsTile _buildExportDrugsTile(BuildContext context) {
    return SettingsTile(
      leading: const Icon(Icons.file_upload_outlined),
      title:
          Text(AppLocalizations.of(context)!.settingsViewExportDrugsFieldTitle),
    );
  }
}

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
    return Consumer(
      builder: (context, ref, child) {
        final String themeModeLabel = _themeModeToString(
            ref.watch(themeModeProvider), AppLocalizations.of(context)!);
        return SettingsTile(
          leading: const Icon(Icons.brightness_6_outlined),
          title:
              Text(AppLocalizations.of(context)!.settingsViewThemeFieldTitle),
          value: Text(themeModeLabel),
          onPressed: (context) async {
            final ThemeMode? themeMode = await showRadioDialog<ThemeMode>(
              context: context,
              values: ThemeMode.values,
              labelBuilder: (themeMode) =>
                  _themeModeToString(themeMode, AppLocalizations.of(context)!),
              title: Text(
                  AppLocalizations.of(context)!.settingsViewThemeFieldTitle),
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

class LanguageTile extends AbstractSettingsTile {
  const LanguageTile({
    super.key,
  });

  String _localeToNativeName(Locale? locale, AppLocalizations localizations) {
    if (locale == null) return localizations.systemLanguageText;
    return LocaleNamesLocalizationsDelegate
            .nativeLocaleNames[locale.toLanguageTag()] ??
        locale.toLanguageTag();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final String localeLabel = _localeToNativeName(
            ref.watch(localeProvider), AppLocalizations.of(context)!);
        const locales = AppLocalizations.supportedLocales;
        return SettingsTile(
          leading: const Icon(Icons.language_outlined),
          title: Text(
              AppLocalizations.of(context)!.settingsViewLanguageFieldTitle),
          value: Text(localeLabel),
          onPressed: (context) async {
            final String? localeString = await showRadioDialog<String>(
              title: Text(
                  AppLocalizations.of(context)!.settingsViewLanguageFieldTitle),
              context: context,
              values: ['', ...locales.map((l) => l.toLanguageTag())],
              labelBuilder: (value) {
                if (value.isEmpty) {
                  return AppLocalizations.of(context)!.systemLanguageText;
                }
                return LocaleNamesLocalizationsDelegate
                        .nativeLocaleNames[value] ??
                    value;
              },
            );

            if (localeString == null) return;
            final Locale? locale =
                localeString.isNotEmpty ? Locale(localeString) : null;
            final Settings settings = ref.read(settingsProvider);
            final Settings updatedSettings =
                settings.nullableCopyWith(locale: locale);
            return ref
                .read(settingsProvider.notifier)
                .updateSettings(updatedSettings);
          },
        );
      },
    );
  }
}
