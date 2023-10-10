import 'package:intl/intl.dart';

formatDate(DateTime dateTime, String localeName) {
  return DateFormat.yMMMMEEEEd(localeName).format(dateTime);
}

formatDateTime(DateTime dateTime, String localeName) {
  return DateFormat.yMMMEd(localeName).add_jm().format(dateTime);
}
