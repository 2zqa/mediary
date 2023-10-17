import 'package:intl/intl.dart';

String formatDate(DateTime dateTime, String localeName) {
  return DateFormat.yMMMMEEEEd(localeName).format(dateTime);
}

String formatMonthYear(DateTime dateTime, String localeName) {
  return DateFormat.yMMMM(localeName).format(dateTime);
}

String formatDateTime(DateTime dateTime, String localeName) {
  return DateFormat.yMMMEd(localeName).add_jm().format(dateTime);
}
