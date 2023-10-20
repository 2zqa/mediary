import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediary/models/settings.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../providers/settings_provider.dart';

const double optionWidth = 175.0;

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  /// Returns a list of [DropdownMenuEntry]s for the given [locales], with the
  /// first entry being the system language. Each language is displayed in its
  /// native language.
  List<DropdownMenuEntry<String>> getDropdownMenuEntries(
    BuildContext context,
    List<Locale> locales,
  ) {
    // Create a DropdownMenuEntry for each locale string
    final List<DropdownMenuEntry<String>> localeEntries = locales
        .map((locale) => DropdownMenuEntry<String>(
              value: locale.toLanguageTag(),
              label: LocaleNamesLocalizationsDelegate
                      .nativeLocaleNames[locale.languageCode] ??
                  locale.toLanguageTag(),
            ))
        .toList();

    // Add the system language as the first entry
    localeEntries.insert(
        0,
        DropdownMenuEntry(
          value: '',
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
      trailing: DropdownMenu<ThemeMode>(
        width: optionWidth,
        onSelected: (themeMode) async {
          Settings settings = await ref.read(settingsProvider.future);
          Settings updatedSettings = settings.nullableCopyWith(
              themeMode: themeMode, locale: settings.locale);
          return ref
              .read(settingsProvider.notifier)
              .updateSettings(updatedSettings);
        },
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
      trailing: DropdownMenu<String>(
        width: optionWidth,
        onSelected: (localeString) async {
          if (localeString == null) return;
          Settings settings = await ref.read(settingsProvider.future);
          Settings updatedSettings = settings.nullableCopyWith(
            locale: localeString.isNotEmpty ? Locale(localeString) : null,
          );
          return ref
              .read(settingsProvider.notifier)
              .updateSettings(updatedSettings);
        },
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        ),
        dropdownMenuEntries: getDropdownMenuEntries(context, supportedLocales),
        initialSelection: '', // empty string means system default
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
