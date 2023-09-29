import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediary/models/drug_diary_item.dart';

/// Creates a [DrugDiaryItemList] and initialise it with pre-defined values.
///
/// We are using [StateNotifierProvider] here as a `List<DrugDiaryItem>` is a complex
/// object, with advanced business logic like how to edit a drugDiaryItem.
final drugDiaryItemListProvider =
    StateNotifierProvider<DrugDiaryItemList, List<DrugDiaryItem>>((ref) {
  return DrugDiaryItemList([
    DrugDiaryItem(
      name: 'Speed',
      amount: '2 gram',
      date: DateTime.utc(2023, 28, 9),
      notes: 'I feel great!',
    ),
    DrugDiaryItem(
      name: 'Wiet',
      amount: '1 joint',
      date: DateTime.utc(2023, 28, 9),
      notes: 'I feel great!',
    ),
    DrugDiaryItem(
      name: 'XTC',
      amount: '1 pil',
      date: DateTime.utc(2023, 28, 9, 12, 30),
      notes: 'I feel great!',
    ),
  ]);
});

final drugDiaryNameIterableProvider = Provider<Iterable<String>>((ref) {
  final drugs = ref.watch(drugDiaryItemListProvider);

  return drugs.map((e) => e.name);
});
