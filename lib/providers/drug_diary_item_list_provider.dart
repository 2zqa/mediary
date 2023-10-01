import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediary/models/drug_diary_item.dart';

/// Creates a [DrugDiaryProvider] and initialise it with pre-defined values.
///
/// We are using [StateNotifierProvider] here as a `List<DrugDiaryItem>` is a complex
/// object, with advanced business logic like how to edit a drugDiaryItem.
final drugDiaryItemListProvider =
    StateNotifierProvider<DrugDiaryProvider, List<DrugDiaryItem>>((ref) {
  return DrugDiaryProvider();
});
