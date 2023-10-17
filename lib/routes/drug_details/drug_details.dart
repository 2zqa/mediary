import 'package:flutter/material.dart';
import 'package:mediary/formatting/date_formatter.dart';
import 'package:mediary/models/drug_entry.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrugDetails extends StatelessWidget {
  final DrugEntry drug;
  const DrugDetails(this.drug, {super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!.localeName;
    return Scaffold(
      appBar: AppBar(
        title: Text(drug.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "N.B. Ontwerp van dit scherm is nog niet af!",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 32),
            const Text('Naam:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(drug.name),
            const SizedBox(height: 8),
            const Text('Hoeveelheid:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(drug.amount),
            const SizedBox(height: 8),
            const Text('Datum:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(formatDateTime(drug.date, locale)),
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
