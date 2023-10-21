import 'package:flutter/material.dart';

/// Shows a dialog with a list of radio buttons. Supports null values.
Future<T?> showRadioDialog<T>({
  required BuildContext context,
  Widget? title,
  required List<T?> values,
  required String Function(T? value) labelBuilder,
  int? selected,
}) {
  return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        int? selectedRadio = selected;
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
                print(selectedRadio);
                if (selectedRadio == null) Navigator.pop(context, null);
                Navigator.pop(context, values[selectedRadio!]);
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
                    T? value = values[index];
                    return RadioListTile<int>(
                      title: Text(labelBuilder(value)),
                      value: index,
                      groupValue: selectedRadio,
                      onChanged: (int? value) {
                        if (value == null) return;
                        setState(() => selectedRadio = value);
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      });
}
