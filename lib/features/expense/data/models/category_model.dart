import 'dart:convert';

import 'package:expense_tracker/features/expense/domain/entities/category.dart';

class ExpenseCategoryModel extends ExpenseCategory {
  const ExpenseCategoryModel({
    required super.id,
    required super.name,
  });

  // Method to create an ExpenseModel from a Map
  factory ExpenseCategoryModel.fromMap(Map<String, dynamic> map) {
    return ExpenseCategoryModel(
      id: map['id'],
      name: map['name'],
    );
  }

  // Method to create an ExpenseModel from JSON
  factory ExpenseCategoryModel.fromJson(String source) {
    return ExpenseCategoryModel.fromMap(json.decode(source));
  }

  // Method to convert an ExpenseModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Method to convert an ExpenseModel to JSON
  String toJson() {
    return json.encode(toMap());
  }
}
