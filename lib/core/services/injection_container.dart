import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/features/expense/data/data_source/category_firebase_datasource.dart';
import 'package:expense_tracker/features/expense/data/data_source/category_remote_datasource.dart';
import 'package:expense_tracker/features/expense/data/data_source/expense_remote_datasource.dart';
import 'package:expense_tracker/features/expense/data/data_source/expense_firebase_datasource.dart';
import 'package:expense_tracker/features/expense/data/repository_impl/category_repo_impl.dart';
import 'package:expense_tracker/features/expense/data/repository_impl/expense_repo_impl.dart';
import 'package:expense_tracker/features/expense/domain/repositories/category_repo.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repo.dart';
import 'package:expense_tracker/features/expense/domain/usecases/add_expense.dart';
import 'package:expense_tracker/features/expense/domain/usecases/delete_expense.dart';
import 'package:expense_tracker/features/expense/domain/usecases/edit_expense.dart';
import 'package:expense_tracker/features/expense/domain/usecases/get_all_categories.dart';
import 'package:expense_tracker/features/expense/domain/usecases/get_all_expenses.dart';
import 'package:expense_tracker/features/expense/presentation/cubit/category_cubit.dart';
import 'package:expense_tracker/features/expense/presentation/cubit/expense_cubit.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

// manage dependencies

Future<void> init() async {
  // Feature 1: Expense
  // presentation layer
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

  // Categories

  serviceLocator.registerFactory(() => CategoryCubit(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => GetAllCategories(serviceLocator()));
  serviceLocator.registerLazySingleton<ExpenseCategoryRepository>(
      () => ExpenseCategoryRepositoryImplementation(serviceLocator()));
  serviceLocator.registerLazySingleton<ExpenseCategoryRemoteDataSource>(
      () => CategoryFirebaseDatasource(serviceLocator()));
}
