import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/failure.dart';
import '../entities/expense.dart';
import '../entities/expense_summary.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, void>> addExpense(Expense expense);
  Future<Either<Failure, List<Expense>>> getAllExpenses();
  Future<Either<Failure, ExpenseSummary>> getExpenseSummary(
      DateTimeRange period);
  Future<Either<Failure, void>> updateExpense(Expense expense);
  Future<Either<Failure, void>> deleteExpense(Expense expense);
  Future<Either<Failure, List<Expense>>> searchExpenses(String query);
  Future<Either<Failure, List<Expense>>> filterExpenses(ExpenseFilter filter);
}

class ExpenseFilter {
  final String? category;
  final DateTimeRange? dateRange;

  ExpenseFilter({this.category, this.dateRange});
}
