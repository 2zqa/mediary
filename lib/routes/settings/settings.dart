import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:settings_ui/settings_ui.dart';

const double optionWidth = 175.0;

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  /// Returns a list of [DropdownMenuEntry]s for the given [locales], with the
  /// first entry being the system language. Each language is displayed in its
  /// native language.
  List<DropdownMenuEntry<Locale?>> getDropdownMenuEntries(
      BuildContext context, List<Locale> locales) {
    var localeEntries = locales
        .map((locale) => DropdownMenuEntry<Locale?>(
            value: locale,
            label: LocaleNamesLocalizationsDelegate
                    .nativeLocaleNames[locale.languageCode] ??
                locale.toLanguageTag()))
        .toList();
    localeEntries.insert(
        0,
        DropdownMenuEntry<Locale?>(
          value: null,
          label: AppLocalizations.of(context)!.systemLanguageText,
        ));
    return localeEntries;
  }

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
              _buildLanguageTile(locales),
              _buildThemeTile(),
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
      leading: const Icon(Icons.format_paint_outlined),
      title: Text(AppLocalizations.of(context)!.settingsViewThemeFieldTitle),
      trailing: DropdownMenu<ThemeMode>(
        width: optionWidth,
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        ),
        dropdownMenuEntries: [
          DropdownMenuEntry<ThemeMode>(
            value: ThemeMode.system,
            label: AppLocalizations.of(context)!.systemThemeText,
          ),
          DropdownMenuEntry<ThemeMode>(
            value: ThemeMode.light,
            label: AppLocalizations.of(context)!.lightThemeText,
          ),
          DropdownMenuEntry<ThemeMode>(
            value: ThemeMode.dark,
            label: AppLocalizations.of(context)!.darkThemeText,
          ),
        ],
        initialSelection: ThemeMode.system,
      ),
    );
  }

  SettingsTile _buildLanguageTile(List<Locale> supportedLocales) {
    return SettingsTile(
      leading: const Icon(Icons.language_outlined),
      title: Text(AppLocalizations.of(context)!.settingsViewLanguageFieldTitle),
      trailing: DropdownMenu<Locale?>(
        width: optionWidth,
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        ),
        dropdownMenuEntries: getDropdownMenuEntries(context, supportedLocales),
        initialSelection: null, // null means System language
      ),
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
