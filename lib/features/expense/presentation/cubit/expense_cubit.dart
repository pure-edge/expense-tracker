import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/edit_expense.dart';
import '../../domain/usecases/get_all_expenses.dart';

part 'expense_state.dart';

const String noInternetErrorMessage =
    "Sync failed: Changes saved on your device and will sync once you're back online.";

class ExpenseCubit extends Cubit<ExpenseState> {
  // Use case instances
  final AddExpense _addExpenseUseCase;
  final DeleteExpense _deleteExpenseUseCase;
  final EditExpense _updateExpenseUseCase;
  final GetAllExpenses _getAllExpensesUseCase;

  ExpenseCubit(
    this._addExpenseUseCase,
    this._deleteExpenseUseCase,
    this._updateExpenseUseCase,
    this._getAllExpensesUseCase,
  ) : super(ExpenseInitial());

  // Method to fetch all expenses
  Future<void> fetchAllExpenses() async {
    emit(ExpenseLoading());

    try {
      final result = await _getAllExpensesUseCase().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) => emit(ExpenseError(failure.message)),
        (expenses) {
          emit(ExpenseLoaded(expenses));
        },
      );
    } on TimeoutException catch (_) {
      emit(const ExpenseError(
          "There seems to be a problem with your Internet connection"));
    }
  }

  // Method to add a new expense
  Future<void> addExpense(Expense expense) async {
    emit(ExpenseLoading());

    try {
      final result = await _addExpenseUseCase(expense).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) => emit(ExpenseError(failure.message)),
        (_) {
          emit(ExpenseAdded());
        },
      );
    } on TimeoutException catch (_) {
      emit(const ExpenseError(noInternetErrorMessage));
    }
  }

  // Method to delete an expense
  Future<void> deleteExpense(Expense expense) async {
    emit(ExpenseLoading());

    try {
      final result = await _deleteExpenseUseCase(expense).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) => emit(ExpenseError(failure.message)),
        (_) {
          emit(ExpenseDeleted());
        },
      );
    } on TimeoutException catch (_) {
      emit(const ExpenseError(noInternetErrorMessage));
    }
  }

  // Method to update an expense
  Future<void> updateExpense(Expense expense) async {
    emit(ExpenseLoading());

    try {
      final result = await _updateExpenseUseCase(expense).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) => emit(ExpenseError(failure.message)),
        (_) {
          emit(ExpenseUpdated(expense));
        },
      );
    } on TimeoutException catch (_) {
      emit(const ExpenseError(noInternetErrorMessage));
    }
  }
}
