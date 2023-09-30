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
  Widget _buildList(List<DrugDiaryItem> drugs) {
    final drugStateNotifier = ref.read(drugDiaryItemListProvider.notifier);
    return GroupedListView<DrugDiaryItem, DateTime>(
      elements: drugs,
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

  Widget _buildEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.science_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
            'Niets te zien hier... ',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drugs = ref.watch(drugDiaryItemListProvider);
    return drugs.isEmpty ? _buildEmptyList() : _buildList(drugs);
  }
}
