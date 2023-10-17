import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/drug_entry.dart';
import '../../providers/drug_entries_provider.dart';
import '../drug_details/drug_details.dart';

class DrugCalendarView extends ConsumerWidget {
  const DrugCalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<EventController<DrugEntry>> controller =
        ref.watch(drugCalendarEntriesProvider);
    return controller.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (controller) => MonthView(
        controller: controller,
        onEventTap: (eventData, __) {
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
    );
  }
}
