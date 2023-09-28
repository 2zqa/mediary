import 'package:uuid/uuid.dart';

const _uuid = Uuid();

enum Unit {
  mg,
  ug,
  g,
  mL,
  L,
}

Unit parseUnit(String unitString) {
  switch (unitString) {
    case 'mg':
      return Unit.mg;
    case 'ug':
      return Unit.ug;
    case 'g':
      return Unit.g;
    case 'mL':
      return Unit.mL;
    case 'L':
      return Unit.L;
    default:
      throw ArgumentError('Invalid unit string: $unitString');
  }
}

class DrugDiaryItem implements Comparable<DrugDiaryItem> {
  final String id;
  final String name;
  final double amount;
  final Unit unit;
  final DateTime date;
  final String? notes;

  DrugDiaryItem({
    String? id,
    required this.name,
    required this.amount,
    required this.unit,
    required this.date,
    this.notes,
  })  : assert(id == null || Uuid.isValidUUID(fromString: id)),
        id = id ?? _uuid.v4();

  factory DrugDiaryItem.fromJson(Map<String, dynamic> json) {
    return DrugDiaryItem(
      name: json['drug'],
      amount: double.parse(json['amount']),
      unit: parseUnit(json['unit']),
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'drug': name,
      'amount': amount,
      'unit': unit,
      'date': date,
      'notes': notes,
    };
  }

  @override
  int compareTo(DrugDiaryItem other) => date.compareTo(other.date);
}
