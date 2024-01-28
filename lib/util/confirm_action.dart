import 'package:flutter/material.dart';

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
