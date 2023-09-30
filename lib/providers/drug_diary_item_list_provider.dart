import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediary/models/drug_diary_item.dart';

/// Creates a [DrugDiaryItemList] and initialise it with pre-defined values.
///
/// We are using [StateNotifierProvider] here as a `List<DrugDiaryItem>` is a complex
/// object, with advanced business logic like how to edit a drugDiaryItem.
final drugDiaryItemListProvider =
    StateNotifierProvider<DrugDiaryItemList, List<DrugDiaryItem>>((ref) {
  return DrugDiaryItemList([]);
});

final drugDiaryNameIterableProvider = Provider<Iterable<String>>((ref) {
  final drugs = ref.watch(drugDiaryItemListProvider);

  return drugs.map((e) => e.name);
});
