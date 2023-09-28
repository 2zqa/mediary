import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mediary/models/drug_diary_item.dart';
import 'package:mediary/routes/drug_list/drug_list_item.dart';

class DrugList extends StatefulWidget {
  const DrugList({
    super.key,
  });

  @override
  State<DrugList> createState() => _DrugListState();
}

class _DrugListState extends State<DrugList> {
  List drugDiaryItems = <DrugDiaryItem>[
    DrugDiaryItem(
      name: 'Speed',
      amount: 5,
      unit: Unit.mg,
      date: DateTime.parse('2021-09-01 12:00:00'),
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
        amount: 100,
        unit: Unit.mg,
        date: DateTime.parse('2021-09-02 12:00:00'),
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
    return GroupedListView(
      elements: drugDiaryItems,
      groupBy: (element) => element.date,
      useStickyGroupSeparators: true,
      groupSeparatorBuilder: (date) => Text(date.toString()),
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
