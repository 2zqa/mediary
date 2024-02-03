import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/drug_entry.dart';

/// Shows a dialog allowing people to confirm executing [onAction].
Future<T?> showConfirmAction<T>(
    {required BuildContext context,
    Widget? title,
    Widget? icon,
    Widget? description,
    required void Function() onConfirm,
    void Function()? onCancel,
    Widget? confirmText}) {
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: title,
      icon: icon,
      // contentPadding: const EdgeInsets.only(top: 16.0, bottom: 24),
      content: description,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: confirmText ??
              Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    ),
  );
}

void showDrugDeleteUndoSnackbar({
  required BuildContext context,
  required AppLocalizations localizations,
  required DrugEntry drug,
  required void Function() onUndo,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.none,
      content: Text(
          AppLocalizations.of(context)!.drugRemovedSnackbarText(drug.name)),
      action: SnackBarAction(
        label: localizations.undoText,
        onPressed: onUndo,
      ),
    ),
  );
}
