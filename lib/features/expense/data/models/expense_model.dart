import 'dart:convert';

import 'package:expense_tracker/features/expense/domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.amount,
    required super.categoryId,
    required super.date,
    required super.description,
  });

  // Method to create an ExpenseModel from a Map
  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      amount: map['amount'].toDouble(),
      category: map['category'],
      date: DateTime.parse(map['date']),
      description: map['description'],
    );
  }

  // Method to create an ExpenseModel from JSON
  factory ExpenseModel.fromJson(String source) {
    return ExpenseModel.fromMap(json.decode(source));
  }

  // Method to convert an ExpenseModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': categoryId,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  // Method to convert an ExpenseModel to JSON
  String toJson() {
    return json.encode(toMap());
  }
}
