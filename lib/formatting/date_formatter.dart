import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
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

/// Gets the weekday for the given [day] in the given [localeName], where 0 is Monday.
String getWeekDay(int day, String localeName) {
  final DateSymbols symbols = dateTimeSymbolMap()[localeName] as DateSymbols;
  // NARROWWEEKDAYS start from Sunday, and we want to start from
  // Monday, so we need to offset by 1.
  final int sundayDayOffset = (day + 1) % 7;
  return symbols.NARROWWEEKDAYS[sundayDayOffset];
}
