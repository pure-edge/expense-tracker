import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/errors/exceptions.dart';
import 'package:expense_tracker/features/expense/data/data_source/expense_remote_datasource.dart';
import 'package:expense_tracker/features/expense/data/models/expense_model.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense_summary.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repo.dart';
import 'package:flutter/src/material/date.dart';

class ExpenseFirebaseDatasource implements ExpenseRemoteDataSource {
  final FirebaseFirestore _firestore;

  const ExpenseFirebaseDatasource(this._firestore);

  @override
  Future<void> addExpense(Expense expense) async {
    try {
      final expenseDocRef = _firestore.collection('expenses').doc();
      final expenseModel = ExpenseModel(
          id: expenseDocRef.id,
          amount: expense.amount,
          category: expense.category,
          date: expense.date,
          description: expense.description);
      await expenseDocRef.set(expenseModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> deleteExpense(Expense expense) async {
    try {
      await _firestore.collection('expenses').doc(expense.id).delete();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<Expense>> filterExpenses(ExpenseFilter filter) async {
    try {
      Query query = _firestore.collection('expenses');

      if (filter.category != null) {
        query = query.where('category', isEqualTo: filter.category);
      }

      if (filter.dateRange != null) {
        query = query.where('date',
            isGreaterThanOrEqualTo: filter.dateRange!.start.toIso8601String());
        query = query.where('date',
            isLessThanOrEqualTo: filter.dateRange!.end.toIso8601String());
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => Expense(
                id: doc.id,
                amount: doc['amount'],
                category: doc['category'],
                date: DateTime.parse(doc['date']),
                description: doc['description'],
              ))
          .toList();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    try {
      final querySnapshot = await _firestore
          .collection('expenses')
          .orderBy('date', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Expense(
                id: doc.id,
                amount: doc['amount'],
                category: doc['category'],
                date: DateTime.parse(doc['date']),
                description: doc['description'],
              ))
          .toList();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<ExpenseSummary> getExpenseSummary(DateTimeRange period) async {
    try {
      final querySnapshot = await _firestore
          .collection('expenses')
          .where('date', isGreaterThanOrEqualTo: period.start.toIso8601String())
          .where('date', isLessThanOrEqualTo: period.end.toIso8601String())
          .get();

      double totalExpenses = 0;
      double totalIncome = 0;

      for (var doc in querySnapshot.docs) {
        double amount = doc['amount'];
        if (amount < 0) {
          totalExpenses += amount;
        } else {
          totalIncome += amount;
        }
      }

      return ExpenseSummary(
        totalExpenses: totalExpenses,
        totalIncome: totalIncome,
      );
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<Expense>> searchExpenses(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection('expenses')
          .where('description', isGreaterThanOrEqualTo: query)
          .get();

      return querySnapshot.docs
          .map((doc) => Expense(
                id: doc.id,
                amount: doc['amount'],
                category: doc['category'],
                date: DateTime.parse(doc['date']),
                description: doc['description'],
              ))
          .toList();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final expenseModel = ExpenseModel(
        id: expense.id,
        amount: expense.amount,
        category: expense.category,
        date: expense.date,
        description: expense.description);

    try {
      await _firestore
          .collection('expenses')
          .doc(expense.id)
          .update(expenseModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }
}
