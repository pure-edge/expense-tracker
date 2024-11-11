import 'package:equatable/equatable.dart';

class ExpenseSummary extends Equatable {
  final double totalExpenses;
  final double totalIncome;

  const ExpenseSummary({
    required this.totalExpenses,
    required this.totalIncome,
  });

  @override
  List<Object> get props => [totalExpenses, totalIncome];
}
