import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/features/expense/data/data_source/expense_remote_datasource.dart';
import 'package:expense_tracker/features/expense/data/data_source/firebase_remote_datasource.dart';
import 'package:expense_tracker/features/expense/data/repository_impl/expense_repo_impl.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repo.dart';
import 'package:expense_tracker/features/expense/domain/usecases/add_expense.dart';
import 'package:expense_tracker/features/expense/domain/usecases/delete_expense.dart';
import 'package:expense_tracker/features/expense/domain/usecases/edit_expense.dart';
import 'package:expense_tracker/features/expense/domain/usecases/get_all_expenses.dart';
import 'package:expense_tracker/features/expense/presentation/cubit/expense_cubit.dart';
import 'package:get_it/get_it.dart';

// manages all dependencies

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Expense Feature

  // application layer
  serviceLocator.registerFactory(() => ExpenseCubit(
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));

  // domain layer
  serviceLocator.registerLazySingleton(() => AddExpense(serviceLocator()));
  serviceLocator.registerLazySingleton(() => EditExpense(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteExpense(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetAllExpenses(serviceLocator()));

  // data layer
  serviceLocator.registerLazySingleton<ExpenseRepository>(
      () => ExpenseRepositoryImplementation(serviceLocator()));
  serviceLocator.registerLazySingleton<ExpenseRemoteDataSource>(
      () => ExpenseFirebaseDatasource(serviceLocator()));
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);
}
