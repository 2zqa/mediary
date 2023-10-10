import 'package:intl/intl.dart';

final formatter = DateFormat.yMEd();

formatDateTime(DateTime dateTime, String localeName) {
  return DateFormat.yMEd(localeName).add_jm().format(dateTime);
}

final dayFormatter = DateFormat.Hm();
