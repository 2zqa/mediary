import 'package:flutter/material.dart';

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );
  if (selectedDate == null) return null;

  // Check is to prevent warnings about using context across async gaps
  if (!context.mounted) return null;
  final TimeOfDay? selectedTime = await showTimePicker(
      context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
  if (selectedTime == null) return null;

  return DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );
}
