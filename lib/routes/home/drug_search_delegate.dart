import 'package:flutter/material.dart';

import '../../models/drug_entry.dart';
import '../drug_list/drug_list_item.dart';

class DrugSearchDelegate extends SearchDelegate<String> {
  final DrugEntriesNotifier notifier;
  DrugSearchDelegate({
    required String hintText,
    required this.notifier,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      );

  @override
  Widget buildSuggestions(BuildContext context) =>
      FutureBuilder<List<DrugEntry>>(
        future: notifier.search(query),
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          }

          final drugs = snapshot.requireData;
          final drugStrings = drugs.map((drug) => drug.name).toSet();
          return ListView(
            children: drugStrings
                .map((drugString) => ListTile(
                      title: Text(drugString),
                      onTap: () {
                        query = drugString;
                        showResults(context);
                      },
                    ))
                .toList(),
          );
        },
      );

  @override
  Widget buildResults(BuildContext context) {
    final drugs = notifier.search(query);
    return FutureBuilder<List<DrugEntry>>(
      future: drugs,
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        final drugs = snapshot.requireData;
        return ListView.builder(
          itemCount: drugs.length,
          itemBuilder: (context, index) => DrugListItem(drug: drugs[index]),
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: query.isNotEmpty
            ? () {
                query = '';
              }
            : null,
      ),
    ];
  }
}
