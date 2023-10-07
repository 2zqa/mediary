import 'package:flutter/material.dart';
import 'package:mediary/routes/add_drug_form/add_drug_form.dart';
import 'package:mediary/routes/drug_list/drug_list.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage(this.title, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Scrollbar(
        child: DrugList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddDrugForm()),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
