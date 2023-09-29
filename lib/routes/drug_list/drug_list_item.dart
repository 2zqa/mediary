import 'package:flutter/material.dart';
import 'package:mediary/formatting/date_formatter.dart';
import 'package:mediary/models/drug_diary_item.dart';

import '../drug_details/drug_details.dart';

class DrugListItem extends StatelessWidget {
  final DrugDiaryItem drug;
  final void Function()? onDelete;

  const DrugListItem({
    required this.drug,
    this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) => onDelete?.call(),
      key: super.key ?? ValueKey(drug.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
      child: ListTile(
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
          '${drug.amount.toString()} gebruikt om ${dayFormatter.format(drug.date)}',
        ),
      ),
    );
  }
}
