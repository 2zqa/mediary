import 'package:flutter/material.dart';

class AddDrugRoute extends StatelessWidget {
  const AddDrugRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Drug Use'),
      ),
      body: const Center(
        child: Text('Add Drug'),
      ),
    );
  }
}
