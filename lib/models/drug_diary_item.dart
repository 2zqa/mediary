import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class DrugDiaryItem implements Comparable<DrugDiaryItem> {
  final String id;
  final String name;
  final String amount;
  final DateTime date;
  final String? notes;

  DrugDiaryItem({
    String? id,
    required this.name,
    required this.amount,
    required this.date,
    this.notes,
  })  : assert(id == null || Uuid.isValidUUID(fromString: id)),
        id = id ?? _uuid.v4();

  factory DrugDiaryItem.fromJson(Map<String, dynamic> json) {
    return DrugDiaryItem(
      name: json['drug'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  @override
  int compareTo(DrugDiaryItem other) => date.compareTo(other.date);
}

/// An object that controls a list of [DrugDiaryItem].
class DrugDiaryItemList extends StateNotifier<List<DrugDiaryItem>> {
  DrugDiaryItemList([List<DrugDiaryItem>? initialDrugDiaryItems])
      : super(initialDrugDiaryItems ?? []);

  void add(DrugDiaryItem drugDiaryItem) {
    state = [
      ...state,
      drugDiaryItem,
    ];
  }

  void remove(DrugDiaryItem target) {
    state = state.where((drug) => drug.id != target.id).toList();
  }

  void update(DrugDiaryItem drugDiaryItem) {
    state = [
      for (final drug in state)
        if (drug.id == drugDiaryItem.id) drugDiaryItem else drug,
    ];
  }
}
