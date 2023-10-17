import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mediary/formatting/date_formatter.dart';
import 'package:mediary/models/drug_entry.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/drug_entries_provider.dart';
import 'drug_list_item.dart';
import 'group_header.dart';

class DrugList extends ConsumerStatefulWidget {
  const DrugList({Key? key}) : super(key: key);

  @override
  DrugListState createState() => DrugListState();
}

class DrugListState extends ConsumerState<DrugList> {
  Widget _buildList(List<DrugEntry> drugs) {
    String locale = AppLocalizations.of(context)!.localeName;
    final drugStateNotifier = ref.read(drugEntriesProvider.notifier);
    return Scrollbar(
      child: GroupedListView<DrugEntry, DateTime>(
        elements: drugs,
        groupBy: (drug) => DateUtils.dateOnly(drug.date),
        sort: true,
        order: GroupedListOrder.DESC,
        groupSeparatorBuilder: (date) =>
            GroupHeader(heading: formatDate(date, locale)),
        indexedItemBuilder: (context, drug, index) {
          return DrugListItem(
            drug: drug,
            onDelete: drugStateNotifier.delete,
            onUndo: drugStateNotifier.add,
          );
        },
      ),
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
            'Niets te zien hier…',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncDrugsValue = ref.watch(drugEntriesProvider);
    return asyncDrugsValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (drugs) => drugs.isEmpty ? _buildEmptyList() : _buildList(drugs),
    );
  }
}
