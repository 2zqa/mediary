import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mediary/formatting/date_formatter.dart';
import 'package:mediary/models/drug_diary_item.dart';

import 'drug_list_item.dart';
import 'group_header.dart';

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

class DrugList extends ConsumerStatefulWidget {
  const DrugList({Key? key}) : super(key: key);

  @override
  DrugListState createState() => DrugListState();
}

class DrugListState extends ConsumerState<DrugList> {
  @override
  Widget build(BuildContext context) {
    return GroupedListView<DrugDiaryItem, DateTime>(
      elements: ref.watch(drugDiaryItemListProvider),
      groupBy: (drug) => DateUtils.dateOnly(drug.date),
      sort: true,
      groupSeparatorBuilder: (date) =>
          GroupHeader(heading: formatter.format(date)),
      indexedItemBuilder: (context, element, index) {
        return DrugListItem(element);
      },
      // itemCount: drugDiaryItems.length,
      // itemBuilder: (context, index) {
      //   return DrugListItem(drugDiaryItems[index]);
      // },
    );
  }
}
