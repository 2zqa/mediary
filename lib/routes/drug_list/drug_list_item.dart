import 'package:flutter/material.dart';
import 'package:mediary/formatting/date_formatter.dart';
import 'package:mediary/models/drug_diary_item.dart';

import '../drug_details/drug_details.dart';

class DrugListItem extends StatelessWidget {
  final DrugDiaryItem drug;

  const DrugListItem(this.drug, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DrugDetails(drug),
            ),
          );
        },
        title: Text(drug.name),
        subtitle: Text(
            '${drug.amount.toString()} ${drug.unit.name} gebruikt om ${dayFormatter.format(drug.date)}'));
  }
}
