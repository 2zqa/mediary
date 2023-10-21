import 'package:flutter/material.dart';

/// Shows a dialog with a list of radio buttons. Uses [showDialog] internally.
Future<T?> showRadioDialog<T>({
  required BuildContext context,
  Widget? title,
  required List<T> values,
  String Function(T? value)? labelBuilder,
  int? selected,
}) {
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      T? selectedValue;
      return AlertDialog(
        title: title,
        contentPadding: const EdgeInsets.only(top: 16.0, bottom: 24),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, selectedValue);
            },
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(
                values.length,
                (int index) {
                  T value = values[index];
                  return RadioListTile<T>(
                    title: Text(labelBuilder?.call(value) ?? value.toString()),
                    value: value,
                    groupValue: selectedValue,
                    onChanged: (T? selected) {
                      if (selected == null) return;
                      setState(() => selectedValue = selected);
                    },
                  );
                },
              ),
            );
          },
        ),
      );
    },
  );
}
