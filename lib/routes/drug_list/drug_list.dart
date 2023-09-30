import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mediary/formatting/date_formatter.dart';
import 'package:mediary/models/drug_diary_item.dart';

import '../../providers/drug_diary_item_list_provider.dart';
import 'drug_list_item.dart';
import 'group_header.dart';

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
      indexedItemBuilder: (context, drug, index) {
        return DrugListItem(
          drug: drug,
          onDelete: drugStateNotifier.remove,
          onUndo: drugStateNotifier.add,
        );
      },
      // itemCount: drugDiaryItems.length,
      // itemBuilder: (context, index) {
      //   return DrugListItem(drugDiaryItems[index]);
      // },
    );
  }
}
