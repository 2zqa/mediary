import 'package:flutter/material.dart';
import 'package:mediary/models/drug_diary_item.dart';

class DrugListItem extends StatelessWidget {
  final DrugDiaryItem drug;

  const DrugListItem(this.drug, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(drug.name),
      subtitle: drug.notes != null ? Text(drug.notes!) : null,
    );
  }
}
