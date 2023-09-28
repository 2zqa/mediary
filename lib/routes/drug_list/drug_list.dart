import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mediary/formatting/date_formatter.dart';
import 'package:mediary/models/drug_diary_item.dart';

import 'drug_list_item.dart';
import 'group_header.dart';

class DrugList extends StatefulWidget {
  const DrugList({
    super.key,
  });

  @override
  State<DrugList> createState() => _DrugListState();
}

class _DrugListState extends State<DrugList> {
  List<DrugDiaryItem> drugDiaryItems = [
    DrugDiaryItem(
      name: 'Speed',
      amount: 5,
      unit: Unit.mg,
      date: DateTime.parse('2021-09-01 12:01:00'),
    ),
    DrugDiaryItem(
      name: 'Weed',
      amount: 0.3,
      unit: Unit.g,
      date: DateTime.parse('2021-09-02 12:00:00'),
      notes: 'Felt okay, but not great.',
    ),
    DrugDiaryItem(
        name: 'Cocaine',
        amount: 120,
        unit: Unit.mg,
        date: DateTime.parse('2021-09-02 12:30:00'),
        notes: 'Idk more cocaine notes.'),
    DrugDiaryItem(
        name: 'Cocaine',
        amount: 100,
        unit: Unit.mg,
        date: DateTime.parse('2021-09-02 12:00:00'),
        notes: 'Idk more cocaine notes.'),
    DrugDiaryItem(
        name: 'Cocaine',
        amount: 100,
        unit: Unit.mg,
        date: DateTime.parse('2021-09-01 12:00:00'),
        notes: 'Idk more cocaine notes.'),
    DrugDiaryItem(
        name: 'Cocaine',
        amount: 100,
        unit: Unit.mg,
        date: DateTime.parse('2021-09-01 12:00:00'),
        notes: 'Idk more cocaine notes.'),
    DrugDiaryItem(
        name: 'Cocaine',
        amount: 100,
        unit: Unit.mg,
        date: DateTime.parse('2023-09-01 12:00:00'),
        notes: 'Idk more cocaine notes.'),
    DrugDiaryItem(
        name: 'Cocaine',
        amount: 100,
        unit: Unit.mg,
        date: DateTime.parse('2023-09-01 12:00:00'),
        notes: 'Idk more cocaine notes.'),
    DrugDiaryItem(
        name: 'Cocaine',
        amount: 100,
        unit: Unit.mg,
        date: DateTime.parse('2023-09-01 12:00:00'),
        notes: 'Idk more cocaine notes.'),
    DrugDiaryItem(
        name: 'Cocaine',
        amount: 100,
        unit: Unit.mg,
        date: DateTime.parse('2023-09-01 12:00:00'),
        notes: 'Idk more cocaine notes.'),
    DrugDiaryItem(
        name: 'Cocaine',
        amount: 100,
        unit: Unit.mg,
        date: DateTime.parse('2023-09-01 12:00:00'),
        notes: 'Idk more cocaine notes.'),
    DrugDiaryItem(
        name: 'Cocaine',
        amount: 100,
        unit: Unit.mg,
        date: DateTime.parse('2023-09-01 12:00:00'),
        notes: 'Idk more cocaine notes.'),
    DrugDiaryItem(
        name: 'Cocaine',
        amount: 100,
        unit: Unit.mg,
        date: DateTime.parse('2023-09-01 12:00:00'),
        notes: 'Idk more cocaine notes.'),
  ];

  @override
  Widget build(BuildContext context) {
    return GroupedListView<DrugDiaryItem, DateTime>(
      elements: drugDiaryItems,
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
