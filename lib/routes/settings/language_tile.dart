import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../models/settings.dart';
import '../../providers/settings_provider.dart';
import '../../util/radio_button_dialog.dart';

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
    final localizations = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, child) {
        final String localeLabel =
            _localeToNativeName(ref.watch(localeProvider), localizations);
        const locales = AppLocalizations.supportedLocales;
        return SettingsTile(
          leading: const Icon(Icons.language_outlined),
          title: Text(localizations.settingsViewLanguageFieldTitle),
          value: Text(localeLabel),
          onPressed: (context) async {
            final String? localeString = await showRadioDialog<String>(
              title: Text(localizations.settingsViewLanguageFieldTitle),
              context: context,
              values: ['', ...locales.map((l) => l.toLanguageTag())],
              labelBuilder: (value) {
                if (value.isEmpty) {
                  return localizations.systemLanguageText;
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
