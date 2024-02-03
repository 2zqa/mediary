import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../formatting/date_formatter.dart';
import '../../models/drug_entry.dart';
import '../../providers/drug_entries_provider.dart';
import '../../util/colors.dart';
import '../../util/confirm_action.dart';

class DrugDetails extends ConsumerWidget {
  final DrugEntry drug;
  const DrugDetails(this.drug, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drugStateNotifier = ref.read(drugEntriesProvider.notifier);
    final localizations = AppLocalizations.of(context)!;
    final titleFontSize = Theme.of(context).textTheme.titleMedium!.fontSize;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showConfirmAction(
              context: context,
              title: Text(localizations.drugDeleteConfirmTitle),
              icon: const Icon(Icons.delete),
              description: Text(localizations.drugDeleteConfirmDescription(
                  drug.name, localizations.delete.toLowerCase())),
              confirmText: Text(localizations.delete),
              onConfirm: () {
                drugStateNotifier.delete(drug);
                showDrugDeleteUndoSnackbar(
                  context: context,
                  drug: drug,
                  onUndo: () => drugStateNotifier.add(drug),
                  localizations: localizations,
                );
                Navigator.pop(context);
              },
            ),
          ),
        ],
        title: Row(
          children: [
            Container(
              width: titleFontSize,
              height: titleFontSize,
              decoration: BoxDecoration(
                color: getDrugColor(drug.color, Theme.of(context).colorScheme),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(drug.name),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "N.B. Ontwerp van dit scherm is nog niet af!",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 32),
            const Text('Naam:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(drug.name),
            const SizedBox(height: 8),
            const Text('Hoeveelheid:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(drug.amount),
            const SizedBox(height: 8),
            const Text('Datum:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(formatDateTime(drug.date, localizations.localeName)),
            const SizedBox(height: 8),
            const Text('Notities:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(drug.notes ?? ''),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
