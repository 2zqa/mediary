import 'package:flutter/material.dart';
import 'package:mediary/formatting/date_formatter.dart';
import 'package:mediary/models/drug_diary_item.dart';

class DrugDetails extends StatelessWidget {
  final DrugDiaryItem drug;
  const DrugDetails(this.drug, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(drug.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Naam:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(drug.name),
            const SizedBox(height: 8),
            const Text('Hoeveelheid:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(drug.amount),
            const SizedBox(height: 8),
            const Text('Datum:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(formatter.format(drug.date)),
            const SizedBox(height: 8),
            const Text('Notities:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(drug.notes ?? ''),
          ],
        ),
      ),
    );
  }
}
