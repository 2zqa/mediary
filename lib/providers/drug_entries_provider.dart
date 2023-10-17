import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediary/models/drug_entry.dart';

final drugEntriesProvider =
    AsyncNotifierProvider<AsyncDrugEntriesNotifier, List<DrugEntry>>(() {
  return AsyncDrugEntriesNotifier();
});

final drugCalendarEntriesProvider =
    FutureProvider<EventController<DrugEntry>>((ref) async {
  final drugsList = await ref.watch(drugEntriesProvider.future);

  final events = drugsList
      .map((drug) => CalendarEventData<DrugEntry>(
            title: drug.name,
            date: drug.date,
            description: drug.notes ?? '',
            event: drug,
          ))
      .toList();

  return EventController()..addAll(events);
});
