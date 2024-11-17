import 'package:flutter/material.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/summary.dart';
import '../../domain/repositories/expense_repo.dart';

abstract class ExpenseRemoteDataSource {
  Future<void> addExpense(Expense expense);
  Future<List<Expense>> getAllExpenses();
  Future<ExpenseSummary> getExpenseSummary(DateTimeRange period);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(Expense expense);
  Future<List<Expense>> searchExpenses(String query);
  Future<List<Expense>> filterExpenses(ExpenseFilter filter);
}
