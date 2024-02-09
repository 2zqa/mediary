import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/drug_entry.dart';

import '../../util/colors.dart';
import '../../util/confirm_action.dart';
import '../drug_details/drug_details.dart';

class DrugListItem extends StatelessWidget {
  final DrugEntry drug;
  final void Function(DrugEntry drug) onDelete;
  final void Function(DrugEntry drug) onUndo;

  const DrugListItem({
    required this.drug,
    required this.onDelete,
    required this.onUndo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = getDrugColor(drug.color, Theme.of(context).colorScheme);
    final localizations = AppLocalizations.of(context)!;
    return Dismissible(
      onDismissed: (_) {
        onDelete(drug);
        showDrugDeleteUndoSnackbar(
          context: context,
          drug: drug,
          onUndo: () => onUndo(drug),
          localizations: localizations,
        );
      },
      key: super.key ?? ValueKey(drug.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete_outlined,
              color: Colors.white,
            ),
          ],
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DrugDetails(drug.id),
            ),
          );
        },
        leading: CircleAvatar(
          backgroundColor: color,
          foregroundColor: getTextColor(color),
          child: Text(drug.name[0].toUpperCase()),
        ),
        title: Text(drug.name),
        subtitle: Text(
          AppLocalizations.of(context)!
              .drugUsedSubtitle(drug.amount, drug.date),
        ),
      ),
    );
  }
}
