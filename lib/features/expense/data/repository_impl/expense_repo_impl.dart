import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/exceptions.dart';
import 'package:expense_tracker/features/expense/data/data_source/expense_remote_datasource.dart';
import 'package:flutter/src/material/date.dart';
import 'package:expense_tracker/core/errors/failure.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_summary.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repo.dart';

class ExpenseRepositoryImplementation implements ExpenseRepository {
  final ExpenseRemoteDataSource _dataSource;

  const ExpenseRepositoryImplementation(this._dataSource);

  @override
  Future<Either<Failure, void>> addExpense(Expense expense) async {
    try {
      return Right(await _dataSource.addExpense(expense));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(Expense expense) async {
    try {
      return Right(await _dataSource.deleteExpense(expense));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> filterExpenses(
      ExpenseFilter filter) async {
    try {
      return Right(await _dataSource.filterExpenses(filter));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getAllExpenses() async {
    try {
      return Right(await _dataSource.getAllExpenses());
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseSummary>> getExpenseSummary(
      DateTimeRange period) async {
    try {
      return Right(await _dataSource.getExpenseSummary(period));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> searchExpenses(String query) async {
    try {
      return Right(await _dataSource.searchExpenses(query));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(Expense expense) async {
    try {
      return Right(await _dataSource.updateExpense(expense));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
}
