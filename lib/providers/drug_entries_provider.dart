import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediary/models/drug_entry.dart';

/// Creates a [DrugEntriesProvider] and initialise it with pre-defined values.
///
/// We are using [StateNotifierProvider] here as a `List<DrugEntry>` is a complex
/// object, with advanced business logic like how to edit a drug entry.
final drugEntriesProvider =
    StateNotifierProvider<DrugEntriesProvider, List<DrugEntry>>((ref) {
  return DrugEntriesProvider();
});
