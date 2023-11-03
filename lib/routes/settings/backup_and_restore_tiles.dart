import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../migrations/drug_entry_migrations.dart';
import '../../models/drug_entry.dart';
import '../../providers/drug_entries_provider.dart';
import '../../util/show_snackbar_shorthand.dart';

class ImportException implements Exception {
  String cause;
  ImportException(this.cause);
}

class ImportVersionMismatchException extends ImportException {
  ImportVersionMismatchException() : super('Version mismatch');
}

class ExportException implements Exception {
  String cause;
  ExportException(this.cause);
}

/// Saves a backup to a file. Silently fails if the user cancels the file picker.
/// Returns whether the backup was successful.
Future<bool> saveBackupToFile(List<DrugEntry> drugs) async {
  final export = {
    'version': DrugEntriesDatabase.version,
    'data': drugs.map((drug) => drug.toMap()).toList(),
  };
  final jsonString = jsonEncode(export);
  final Uint8List data = Uint8List.fromList(utf8.encode(jsonString));

  if (!await FlutterFileDialog.isPickDirectorySupported()) {
    throw ExportException('Pick directory not supported');
  }

  final pickedDirectory = await FlutterFileDialog.pickDirectory();
  if (pickedDirectory == null) {
    return false;
  }

  await FlutterFileDialog.saveFileToDirectory(
    directory: pickedDirectory,
    data: data,
    mimeType: "application/json",
    fileName: "mediary_export.json",
  );
  return true;
}

/// Tries to import a backup from a file. Throws an exception if the file is
/// invalid or the version does not match.
Future<List<DrugEntry>?> importBackupFromFile() async {
  final filePath = await FlutterFileDialog.pickFile();
  if (filePath == null) {
    return null;
  }

  final fileData = File(filePath).readAsBytesSync();
  final decoded = jsonDecode(utf8.decode(fileData));
  final version = decoded['version'] as int;
  if (version != DrugEntriesDatabase.version) {
    return Future.error(ImportVersionMismatchException());
  }
  final data = decoded['data'] as List<dynamic>;

  final List<DrugEntry> drugEntries =
      data.map((e) => DrugEntry.fromMap(e)).toList();
  return drugEntries;
}

class ExportDrugsTile extends AbstractSettingsTile {
  const ExportDrugsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, child) {
        return SettingsTile(
          leading: const Icon(Icons.file_upload_outlined),
          title: Text(localizations.settingsViewExportDrugsFieldTitle),
          onPressed: (context) async {
            final drugs = await ref.read(drugEntriesProvider.future);

            bool success = false;
            try {
              success = await saveBackupToFile(drugs);
            } catch (_) {
              if (!context.mounted) return;
              showSnackbarText(context, localizations.exportDrugsError);
              return;
            }
            if (!success) return;
            if (!context.mounted) return;
            showSnackbarText(
                context, localizations.exportDrugsSuccess(drugs.length));
          },
        );
      },
    );
  }
}

class ImportDrugsTile extends AbstractSettingsTile {
  const ImportDrugsTile({super.key});

  Future<void> onPressed(BuildContext context, AppLocalizations localizations,
      WidgetRef ref) async {
    List<DrugEntry>? drugs;
    try {
      drugs = await importBackupFromFile();
    } on ImportVersionMismatchException {
      if (!context.mounted) return;
      showSnackbarText(context, 'Version mismatch');
    } catch (_) {
      if (!context.mounted) return;
      showSnackbarText(context, localizations.importDrugsError);
    }
    if (drugs == null) return;
    await ref.read(drugEntriesProvider.notifier).import(drugs);

    if (!context.mounted) return;
    showSnackbarText(context, localizations.importDrugsSuccess(drugs.length));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, child) {
        return SettingsTile(
          leading: const Icon(Icons.file_download_outlined),
          title: Text(localizations.settingsViewImportDrugsFieldTitle),
          onPressed: (context) => onPressed(context, localizations, ref),
        );
      },
    );
  }
}
