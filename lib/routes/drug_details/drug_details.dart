import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../formatting/date_formatter.dart';
import '../../models/drug_entry.dart';
import '../../providers/drug_entries_provider.dart';
import '../../util/colors.dart';
import '../../util/confirm_action.dart';
import '../add_drug_form/drug_form.dart';

class DrugDetails extends ConsumerWidget {
  final String drugId;
  const DrugDetails(this.drugId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drugEntriesAsyncValue = ref.watch(drugEntriesProvider);
    final drugStateNotifier = ref.read(drugEntriesProvider.notifier);
    return drugEntriesAsyncValue.when(
      data: (drugList) {
        final drug = drugList.where((e) => e.id == drugId).firstOrNull;
        if (drug == null) {
          // This should only happen for a short time when the drug is deleted
          return const Scaffold();
        }
        return _Details(
            drug: drug,
            onDelete: drugStateNotifier.delete,
            onUndo: drugStateNotifier.add);
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    required this.drug,
    required this.onDelete,
    required this.onUndo,
  });

  final DrugEntry drug;
  final void Function(DrugEntry drug) onDelete;
  final void Function(DrugEntry drug) onUndo;

  @override
  Widget build(BuildContext context) {
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
                onDelete(drug);
                showDrugDeleteUndoSnackbar(
                  context: context,
                  drug: drug,
                  onUndo: () => onUndo(drug),
                  localizations: localizations,
                );
                Navigator.pop(context);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DrugForm(initialDrug: drug)),
            ),
          )
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(localizations.drugNameFieldTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            Text(drug.name),
            const SizedBox(height: 16),
            Text(localizations.drugAmountFieldTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            Text(drug.amount),
            const SizedBox(height: 16),
            Text(localizations.drugDateAndTimeFieldTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            Text(formatDateTime(drug.date, localizations.localeName)),
            if (drug.notes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16),
                  Text(localizations.drugNotesFieldTitle,
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text(drug.notes),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
