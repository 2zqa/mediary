import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediary/models/drug_entry.dart';

final asyncTodosProvider =
    AsyncNotifierProvider<AsyncDrugEntriesNotifier, List<DrugEntry>>(() {
  return AsyncDrugEntriesNotifier();
});
