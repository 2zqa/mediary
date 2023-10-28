import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../globals/constants.dart';
import '../../providers/package_info_provider.dart';
import '../../widgets/link_text.dart';
import 'language_tile.dart';
import 'theme_tile.dart';

const double optionWidth = 175.0;

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
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
            title: Text(localizations.settingsViewCommonSectionTitle),
            tiles: const <AbstractSettingsTile>[
              ThemeTile(),
              LanguageTile(),
            ],
          ),
          SettingsSection(
            title: Text(localizations.settingsViewDataSectionTitle),
            tiles: <SettingsTile>[
              _buildImportDrugsTile(localizations),
              _buildExportDrugsTile(localizations),
            ],
          ),
          SettingsSection(
            title: Text(localizations.settingsViewSupportSectionTitle),
            tiles: <SettingsTile>[
              _reportBugButton(localizations),
              _buildAppInfoTile(localizations, ref),
            ],
          ),
        ],
      ),
    );
  }

  SettingsTile _buildAppInfoTile(
      AppLocalizations localizations, WidgetRef ref) {
    return SettingsTile(
      leading: const Icon(Icons.info_outline),
      title: Text(localizations.aboutViewTitle),
      onPressed: (context) async {
        final packageInfo = await ref.read(packageInfoProvider.future);

        if (!context.mounted) return;
        showAboutDialog(
          context: context,
          applicationName: packageInfo.appName,
          applicationVersion: packageInfo.version,
          applicationIcon: Image.asset(
            'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.webp',
            width: 48,
          ),

          // DateTime.now().year — Simple yet elegant, if I do say so myself
          applicationLegalese: "© ${DateTime.now().year} Marijn Kok",

          children: [
            Text("${localizations.appDescription}\n",
                style: const TextStyle(fontStyle: FontStyle.italic)),
            LinkText(
              localizations.sourceCodeInfo,
              uriText: "GitHub",
              uri: Constants.sourceCodeUrl,
            ),
          ],
        );
      },
    );
  }

  SettingsTile _buildImportDrugsTile(AppLocalizations localizations) {
    return SettingsTile(
      leading: const Icon(Icons.file_download_outlined),
      title: Text(localizations.settingsViewImportDrugsFieldTitle),
    );
  }

  SettingsTile _buildExportDrugsTile(AppLocalizations localizations) {
    return SettingsTile(
      leading: const Icon(Icons.file_upload_outlined),
      title: Text(localizations.settingsViewExportDrugsFieldTitle),
    );
  }

  SettingsTile _reportBugButton(AppLocalizations localizations) {
    return SettingsTile(
        leading: const Icon(Icons.mail_outline),
        title: Text(localizations.settingsViewReportBugFieldTitle),
        onPressed: (context) async {
          await showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(localizations.settingsViewReportBugFieldTitle),
                content: Text(localizations
                    .reportBugDialogDescription(localizations.sendButtonLabel)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      unawaited(launchUrl(Constants.supportMail));
                    },
                    child: Text(localizations.sendButtonLabel),
                  ),
                ],
              );
            },
          );
        });
  }
}
