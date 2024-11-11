import 'package:expense_tracker/core/errors/exceptions.dart';
import 'package:expense_tracker/core/errors/failure.dart';
import 'package:expense_tracker/features/expense/data/repository_impl/expense_repo_impl.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'expense_remote_datasource.mock.dart';

void main() {
  late ExpenseRepositoryImplementation expenseRepositoryUnderTest;
  late MockExpenseRemoteDataSource mockExpenseRemoteDataSource;

  setUp(() {
    mockExpenseRemoteDataSource = MockExpenseRemoteDataSource();
    expenseRepositoryUnderTest =
        ExpenseRepositoryImplementation(mockExpenseRemoteDataSource);
  });

  final tExpense = Expense(
    id: '1',
    amount: 100.0,
    category: 'Food',
    date: DateTime.now(),
    description: 'Dinner',
  );

  final tExpenseList = [tExpense];

  group('addExpense', () {
    test('should return void when the addExpense method succeeds', () async {
      // Arrange: Stub the method to succeed (returning void in this case)
      when(() => mockExpenseRemoteDataSource.addExpense(tExpense))
          .thenAnswer((_) async => Future.value());

      // Act: Call the addExpense method
      final result = await expenseRepositoryUnderTest.addExpense(tExpense);

      // Assert: Ensure the result is a Right value (success) and equals void
      expect(result, equals(const Right(null)));
      // Verify the method on the mock data source was called with the correct argument
      verify(() => mockExpenseRemoteDataSource.addExpense(tExpense)).called(1);
      verifyNoMoreInteractions(mockExpenseRemoteDataSource);
    });

    test('should return a Failure when the addExpense method fails', () async {
      // Arrange: Stub the method to throw an exception
      when(() => mockExpenseRemoteDataSource.addExpense(tExpense))
          .thenThrow(Exception());

      // Act: Call the addExpense method
      final result = await expenseRepositoryUnderTest.addExpense(tExpense);

      // Assert: Ensure the result is a Left value (failure)
      expect(result, isA<Left<Failure, void>>());
      // Verify the method on the mock data source was called with the correct argument
      verify(() => mockExpenseRemoteDataSource.addExpense(tExpense)).called(1);
      verifyNoMoreInteractions(mockExpenseRemoteDataSource);
    });
  });

  group('getAllExpenses', () {
    test(
        'should return a list of expenses when the getAllExpenses method succeeds',
        () async {
      // Arrange: Stub the method to return a list of expenses
      when(() => mockExpenseRemoteDataSource.getAllExpenses())
          .thenAnswer((_) async => tExpenseList);

      // Act: Call the getAllExpenses method
      final result = await expenseRepositoryUnderTest.getAllExpenses();

      // Assert: Ensure the result is a Right value (success) and equals the test list
      expect(result, equals(Right(tExpenseList)));
      // Verify the method on the mock data source was called
      verify(() => mockExpenseRemoteDataSource.getAllExpenses()).called(1);
      verifyNoMoreInteractions(mockExpenseRemoteDataSource);
    });

    test('should return a Failure when the getAllExpenses method fails',
        () async {
      // Arrange: Stub the method to throw an exception
      when(() => mockExpenseRemoteDataSource.getAllExpenses()).thenThrow(
          const APIException(
              message: 'Something went wrong with the server',
              statusCode: '500'));

      // Act: Call the getAllExpenses method
      final result = await expenseRepositoryUnderTest.getAllExpenses();

      // Assert: Ensure the result is a Left value (failure)
      expect(result, isA<Left<Failure, List<Expense>>>());
      // Verify the method on the mock data source was called
      verify(() => mockExpenseRemoteDataSource.getAllExpenses()).called(1);
      verifyNoMoreInteractions(mockExpenseRemoteDataSource);
    });
  });

  group('searchExpenses', () {
    const tQuery = 'Dinner';
    test(
        'should return a list of expenses when the searchExpenses method succeeds',
        () async {
      // Arrange: Stub the method to return a list of expenses matching the query
      when(() => mockExpenseRemoteDataSource.searchExpenses(any()))
          .thenAnswer((_) async => tExpenseList);

      // Act: Call the searchExpenses method
      final result = await expenseRepositoryUnderTest.searchExpenses(tQuery);

      // Assert: Ensure the result is a Right value (success) and equals the test list
      expect(result, equals(Right(tExpenseList)));
      // Verify the method on the mock data source was called with the correct query
      verify(() => mockExpenseRemoteDataSource.searchExpenses(tQuery))
          .called(1);
      verifyNoMoreInteractions(mockExpenseRemoteDataSource);
    });

    test('should return a Failure when the searchExpenses method fails',
        () async {
      // Arrange: Stub the method to throw an exception
      when(() => mockExpenseRemoteDataSource.searchExpenses(any()))
          .thenThrow(Exception());

      // Act: Call the searchExpenses method
      final result = await expenseRepositoryUnderTest.searchExpenses(tQuery);

      // Assert: Ensure the result is a Left value (failure)
      expect(result, isA<Left<Failure, List<Expense>>>());
      // Verify the method on the mock data source was called with the correct query
      verify(() => mockExpenseRemoteDataSource.searchExpenses(tQuery))
          .called(1);
      verifyNoMoreInteractions(mockExpenseRemoteDataSource);
    });
  });
}
