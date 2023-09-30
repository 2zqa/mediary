import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediary/models/drug_diary_item.dart';
import 'package:mediary/providers/drug_diary_item_list_provider.dart';

class AddDrugForm extends ConsumerStatefulWidget {
  const AddDrugForm({super.key});

  @override
  AddDrugFormState createState() {
    return AddDrugFormState();
  }
}

class AddDrugFormState extends ConsumerState<AddDrugForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _amount;
  DateTime? _date;
  String? _notes;

  Iterable<DrugDiaryItem> _getAutocompleteSuggestions(
      String text, Iterable<DrugDiaryItem> drugs) {
    if (text.trim().isEmpty) {
      return const Iterable.empty();
    }
    return drugs.where((drug) {
      return drug.name.toLowerCase().contains(text.toLowerCase());
    });
  }

  Widget _buildNameField() {
    final Iterable<DrugDiaryItem> drugs = ref.watch(drugDiaryItemListProvider);
    return Autocomplete<DrugDiaryItem>(
      optionsBuilder: ((textEditingValue) =>
          _getAutocompleteSuggestions(textEditingValue.text, drugs)),
      displayStringForOption: (drug) => drug.name,
      fieldViewBuilder: (_, controller, focusNode, onFieldSubmitted) =>
          TextFormField(
        controller: controller,
        focusNode: focusNode,
        onFieldSubmitted: (_) => onFieldSubmitted(),
        decoration: InputDecoration(
          labelText: 'Naam',
          border: const OutlineInputBorder(),
          hintText: 'e.g. ${drugs.lastOrNull?.name ?? 'Alcohol'}',
        ),
        maxLength: 25,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Naam is vereist.';
          }

          return null;
        },
        onSaved: (value) => _name = value!,
      ),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Hoeveelheid',
        hintText: 'e.g. 1 glas',
        border: OutlineInputBorder(),
      ),
      maxLength: 25,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Hoeveelheid is vereist.';
        }

        return null;
      },
      onSaved: (value) => _amount = value!,
    );
  }

  Widget _buildDateField() {
    return InputDatePickerFormField(
      fieldLabelText: 'Datum gebruik',
      lastDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime(2000),
      acceptEmptyDate: false,
      onDateSaved: (value) => _date = value,
      initialDate: DateTime.now(),
    );
  }

  Widget _buildNotesField() {
    return SizedBox(
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Notities',
          counterText: '',
          helperText: 'Optioneel',
          border: OutlineInputBorder(),
        ),
        minLines: 2,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        maxLength: 1000,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        onSaved: (value) => _notes = value!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drug toevoegen'),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: <Widget>[
                  _buildNameField(),
                  _buildAmountField(),
                  _buildDateField(),
                  _buildNotesField(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          DrugDiaryItem item = DrugDiaryItem(
                            name: _name!,
                            amount: _amount!,
                            date: _date!,
                            notes: _notes,
                          );

                          ref
                              .read(drugDiaryItemListProvider.notifier)
                              .add(item);

                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
