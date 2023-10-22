import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/drug_entry.dart';

final drugEntriesProvider =
    AsyncNotifierProvider<DrugEntriesNotifier, List<DrugEntry>>(() {
  return DrugEntriesNotifier();
});

final drugCalendarEntriesProvider =
    FutureProvider<EventController<DrugEntry>>((ref) async {
  final drugsList = await ref.watch(drugEntriesProvider.future);

  final events = drugsList
      .map((drug) => CalendarEventData<DrugEntry>(
            title: drug.name,
            date: drug.date,
            startTime: drug.date,
            endDate: drug.date,
            endTime: drug.date.add(const Duration(hours: 1)),
            description: drug.notes ?? '',
            event: drug,
          ))
      .toList(growable: false);

  return EventController()..addAll(events);
});
