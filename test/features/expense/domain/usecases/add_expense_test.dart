import 'package:dartz/dartz.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repo.dart';
import 'package:expense_tracker/features/expense/domain/usecases/add_expense.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'expense_repository.mock.dart';

void main() {
  late AddExpense addExpense;
  late ExpenseRepository mockRepository;
  late Expense newExpense;

  setUp(() {
    mockRepository = MockExpenseRepository();
    addExpense = AddExpense(mockRepository);
    newExpense = Expense(
        id: "1",
        amount: 100,
        category: "Essentials",
        date: DateTime.now(),
        description: "Grocery");
  });

  test('should call the ExpenseRepo.addExpense and return void', () async {
    // Arrange
    when(
      () => mockRepository.addExpense(newExpense),
    ).thenAnswer(
      (_) async => const Right(null),
    );

    // Act
    final result = await addExpense(newExpense);

    // Assert
    expect(result, const Right(null));
    verify(() => mockRepository.addExpense(newExpense)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
