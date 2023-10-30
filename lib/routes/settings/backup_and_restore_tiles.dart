import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

class ExportDrugsTile extends AbstractSettingsTile {
  const ExportDrugsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, child) {
        return SettingsTile(
          leading: const Icon(Icons.file_upload_outlined),
          title: Text(localizations.settingsViewImportDrugsFieldTitle),
        );
      },
    );
  }
}

class ImportDrugsTile extends AbstractSettingsTile {
  const ImportDrugsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, child) {
        return SettingsTile(
          leading: const Icon(Icons.file_download_outlined),
          title: Text(localizations.settingsViewExportDrugsFieldTitle),
        );
      },
    );
  }
}
