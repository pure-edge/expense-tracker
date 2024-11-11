import 'package:dartz/dartz.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repo.dart';
import 'package:expense_tracker/features/expense/domain/usecases/get_all_expenses.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'expense_repository.mock.dart';

void main() {
  late GetAllExpenses getAllExpenses;
  late ExpenseRepository expenseRepository;
  late List<Expense> tExpenses;

  setUp(() {
    expenseRepository = MockExpenseRepository();
    getAllExpenses = GetAllExpenses(expenseRepository);
    tExpenses = [
      Expense(
          id: "1",
          amount: 100,
          category: "Essentials",
          date: DateTime.now(),
          description: "Grocery")
    ];
  });

  test('should call the ExpenseRepo.getAllExpense', () async {
    // Arrange
    when(
      () => expenseRepository.getAllExpenses(),
    ).thenAnswer(
      (_) async => Right(tExpenses),
    );

    // Act
    final result = await getAllExpenses();

    // Assert
    expect(result, Right(tExpenses));
    verify(() => expenseRepository.getAllExpenses()).called(1);
    verifyNoMoreInteractions(expenseRepository);
  });
}
