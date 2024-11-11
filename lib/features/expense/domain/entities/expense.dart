import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String description;

  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });

  @override
  List<Object> get props => [id];
}
