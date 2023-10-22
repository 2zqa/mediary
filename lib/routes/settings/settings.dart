import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediary/models/settings.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../providers/settings_provider.dart';
import '../../util/radio_button_dialog.dart';

const double optionWidth = 175.0;

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    const locales = AppLocalizations.supportedLocales;
    return Scrollbar(
      child: SettingsList(
        sections: [
          SettingsSection(
            title: Text(
                AppLocalizations.of(context)!.settingsViewCommonSectionTitle),
            tiles: <SettingsTile>[
              _buildThemeTile(),
              _buildLanguageTile(locales),
            ],
          ),
          SettingsSection(
            title: Text(
                AppLocalizations.of(context)!.settingsViewDataSectionTitle),
            tiles: <SettingsTile>[
              _buildImportDrugsTile(),
              _buildExportDrugsTile(),
            ],
          ),
        ],
      ),
    );
  }

  SettingsTile _buildThemeTile() {
    return SettingsTile(
      leading: const Icon(Icons.brightness_6_outlined),
      title: Text(AppLocalizations.of(context)!.settingsViewThemeFieldTitle),
      onPressed: (context) async {
        final ThemeMode? themeMode = await showRadioDialog<ThemeMode>(
          context: context,
          values: ThemeMode.values,
          labelBuilder: (themeMode) {
            var localizations = AppLocalizations.of(context)!;
            return switch (themeMode) {
              ThemeMode.light => localizations.lightThemeText,
              ThemeMode.dark => localizations.darkThemeText,
              ThemeMode.system => localizations.systemThemeText,
            };
          },
          title:
              Text(AppLocalizations.of(context)!.settingsViewThemeFieldTitle),
        );

        if (themeMode == null) return;
        Settings settings = await ref.read(settingsProvider.future);
        Settings updatedSettings =
            settings.nullableCopyWith(themeMode: themeMode);
        return ref
            .read(settingsProvider.notifier)
            .updateSettings(updatedSettings);
      },
    );
  }

  SettingsTile _buildLanguageTile(List<Locale> supportedLocales) {
    return SettingsTile(
      leading: const Icon(Icons.language_outlined),
      title: Text(AppLocalizations.of(context)!.settingsViewLanguageFieldTitle),
      onPressed: (context) async {
        final String? localeString = await showRadioDialog<String>(
          title: Text(
              AppLocalizations.of(context)!.settingsViewLanguageFieldTitle),
          context: context,
          values: ['', ...supportedLocales.map((l) => l.toLanguageTag())],
          labelBuilder: (value) {
            if (value.isEmpty) {
              return AppLocalizations.of(context)!.systemLanguageText;
            }
            return LocaleNamesLocalizationsDelegate.nativeLocaleNames[value] ??
                value;
          },
        );

        if (localeString == null) return;
        Locale? locale = localeString.isNotEmpty ? Locale(localeString) : null;
        Settings settings = await ref.read(settingsProvider.future);
        Settings updatedSettings = settings.nullableCopyWith(locale: locale);
        return ref
            .read(settingsProvider.notifier)
            .updateSettings(updatedSettings);
      },
    );
  }

  SettingsTile _buildImportDrugsTile() {
    return SettingsTile(
      leading: const Icon(Icons.file_download_outlined),
      title:
          Text(AppLocalizations.of(context)!.settingsViewImportDrugsFieldTitle),
    );
  }

  SettingsTile _buildExportDrugsTile() {
    return SettingsTile(
      leading: const Icon(Icons.file_upload_outlined),
      title:
          Text(AppLocalizations.of(context)!.settingsViewExportDrugsFieldTitle),
    );
  }
}
