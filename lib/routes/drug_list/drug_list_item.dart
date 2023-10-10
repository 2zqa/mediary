import 'package:flutter/material.dart';
import 'package:mediary/models/drug_entry.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../drug_details/drug_details.dart';

class DrugListItem extends StatelessWidget {
  final DrugEntry drug;
  final void Function(DrugEntry drug)? onDelete;
  final void Function(DrugEntry drug)? onUndo;

  const DrugListItem({
    required this.drug,
    this.onDelete,
    this.onUndo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) {
        onDelete?.call(drug);
        if (onUndo == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            dismissDirection: DismissDirection.none,
            content: Text(AppLocalizations.of(context)!
                .drugRemovedSnackbarText(drug.name)),
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.undoText,
              onPressed: () => onUndo?.call(drug),
            ),
          ),
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
              builder: (_) => DrugDetails(drug),
            ),
          );
        },
        title: Text(drug.name),
        subtitle: Text(
          AppLocalizations.of(context)!
              .drugUsedSubtitle(drug.amount, drug.date),
        ),
      ),
    );
  }
}
