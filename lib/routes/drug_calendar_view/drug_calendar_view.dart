import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediary/formatting/date_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/drug_entry.dart';
import '../../providers/drug_entries_provider.dart';
import '../add_drug_form/add_drug_form.dart';
import '../drug_details/drug_details.dart';

class DrugCalendarView extends ConsumerWidget {
  const DrugCalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final AsyncValue<EventController<DrugEntry>> eventControllerAsyncValue =
        ref.watch(drugCalendarEntriesProvider);
    final locale = AppLocalizations.of(context)!.localeName;
    return eventControllerAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (eventController) => MonthView(
        controller: eventController,
        borderColor: colorScheme.outlineVariant,
        borderSize: 0.5,
        useAvailableVerticalSpace: true,
        headerStringBuilder: (date, {secondaryDate}) =>
            formatMonthYear(date, locale),
        onCellTap: (_, date) {
          if (date.isAfter(DateTime.now())) return;

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddDrugForm(initialDate: date)),
          );
        },
        headerBuilder: (date) => MonthPageHeader(
          date: date,
          backgroundColor: colorScheme.primaryContainer,
          iconColor: colorScheme.onPrimaryContainer,
        ),
        weekDayBuilder: (day) => WeekDayTile(
            dayIndex: day,
            backgroundColor: colorScheme.surface,
            textStyle: Theme.of(context).textTheme.bodyMedium,
            // It is currently not supported to specify custom colors for the
            // weekday borders, so disable it for now.
            displayBorder: false,
            weekDayStringBuilder: (day) => getWeekDay(day, locale)),
        cellBuilder: (date, events, isToday, isInMonth) =>
            FilledCell<DrugEntry>(
          date: date,
          events: events,
          shouldHighlight: isToday,
          titleColor:
              isInMonth ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
          backgroundColor:
              isInMonth ? colorScheme.surface : colorScheme.surfaceVariant,
          onTileTap: (eventData, _) {
            final drug = eventData.event;
            if (drug == null) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DrugDetails(drug),
              ),
            );
          },
        ),
      ),
    );
  }
}
