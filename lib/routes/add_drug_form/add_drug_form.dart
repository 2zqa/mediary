import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../formatting/date_formatter.dart';
import '../../models/drug_entry.dart';
import '../../providers/drug_entries_provider.dart';
import '../../util/date_time_picker.dart';
import '../../util/radio_button_dialog.dart';

class AddDrugForm extends ConsumerStatefulWidget {
  final DateTime initialDate;

  AddDrugForm({DateTime? initialDate, super.key})
      : initialDate = initialDate ?? DateTime.now();

  @override
  AddDrugFormState createState() {
    return AddDrugFormState();
  }
}

class AddDrugFormState extends ConsumerState<AddDrugForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _colorController = TextEditingController();
  String? _name;
  String? _amount;
  DateTime? _timestamp;
  String? _notes;
  DrugColor? _color;

  Set<String> _getAutocompleteSuggestions(
      String text, Iterable<DrugEntry> drugs) {
    if (text.trim().isEmpty) {
      return {};
    }
    return drugs
        .where((drug) => drug.name.toLowerCase().contains(text.toLowerCase()))
        .map((drug) => drug.name)
        .toSet();
  }

  String? requiredFieldValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.requiredFieldError;
    }

    return null;
  }

  Widget _buildNameField(Iterable<DrugEntry> drugs) {
    final title = AppLocalizations.of(context)!.drugNameFieldTitle;
    final nameSuggestion =
        drugs.lastOrNull?.name ?? AppLocalizations.of(context)!.drugExampleName;
    return Autocomplete<String>(
      optionsBuilder: ((textEditingValue) =>
          _getAutocompleteSuggestions(textEditingValue.text, drugs)),
      fieldViewBuilder: (_, controller, focusNode, onFieldSubmitted) =>
          TextFormField(
        controller: controller,
        focusNode: focusNode,
        onFieldSubmitted: (_) => onFieldSubmitted(),
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
          hintText:
              AppLocalizations.of(context)!.drugNameFieldHint(nameSuggestion),
        ),
        maxLength: 25,
        validator: requiredFieldValidator,
        onSaved: (value) => _name = value!,
      ),
    );
  }

  Widget _buildAmountField() {
    final title = AppLocalizations.of(context)!.drugAmountFieldTitle;
    return TextFormField(
      decoration: InputDecoration(
        labelText: title,
        hintText: AppLocalizations.of(context)!.drugAmountFieldHint,
        border: const OutlineInputBorder(),
      ),
      maxLength: 25,
      validator: requiredFieldValidator,
      onSaved: (value) => _amount = value!,
    );
  }

  Widget _buildDateField() {
    final title = AppLocalizations.of(context)!.drugDateAndTimeFieldTitle;
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      validator: requiredFieldValidator,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
      ),
      onTap: () async {
        final localeName = AppLocalizations.of(context)!.localeName;
        final now = DateTime.now();
        final dateTime = await showDateTimePicker(
          context: context,
          initialDate: _timestamp ?? widget.initialDate,
          firstDate: DateTime(2000),
          lastDate: now,
        );
        if (dateTime == null) return;
        _timestamp = dateTime;
        _dateController.text = formatDateTime(dateTime, localeName);
      },
    );
  }

  Widget _buildColorField() {
    final title = AppLocalizations.of(context)!.drugColorFieldTitle;
    return TextFormField(
      controller: _colorController,
      readOnly: true,
      validator: requiredFieldValidator,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
      ),
      onTap: () async {
        final drugColor = await showRadioDialog<DrugColor>(
          title: Text(title),
          context: context,
          values: DrugColor.values,
          labelBuilder: (value) => toBeginningOfSentenceCase(
              AppLocalizations.of(context)!.drugColor(value.name))!,
        );
        if (drugColor == null) return;
        _color = drugColor;
        if (!context.mounted) return;
        _colorController.text = toBeginningOfSentenceCase(
            AppLocalizations.of(context)!.drugColor(drugColor.name))!;
      },
    );
  }

  Widget _buildNotesField() {
    return SizedBox(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.drugNotesFieldTitle,
          counterText: '',
          helperText: AppLocalizations.of(context)!.optionalField,
          border: const OutlineInputBorder(),
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
    final asyncDrugsValue = ref.watch(drugEntriesProvider);
    return asyncDrugsValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (drugs) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addDrugFormTitle),
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
                    _buildNameField(drugs),
                    _buildAmountField(),
                    _buildDateField(),
                    _buildColorField(),
                    _buildNotesField(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            final DrugEntry drug = DrugEntry(
                              name: _name!,
                              amount: _amount!,
                              date: _timestamp!,
                              notes: _notes,
                              color: _color!,
                            );

                            ref.read(drugEntriesProvider.notifier).add(drug);

                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                            AppLocalizations.of(context)!.submitButtonText),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
