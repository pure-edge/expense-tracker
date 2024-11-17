import 'package:expense_tracker/core/services/injection_container.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense.dart';
import 'package:expense_tracker/features/expense/presentation/add_edit_expense_page.dart';
import 'package:expense_tracker/features/expense/presentation/cubit/category_cubit.dart';
import 'package:expense_tracker/features/expense/presentation/cubit/expense_cubit.dart';
import 'package:expense_tracker/features/expense/presentation/view_expense_page.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (context) =>
              const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      case "/add-expense":
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => serviceLocator<ExpenseCubit>(),
              ),
              BlocProvider(
                create: (context) => serviceLocator<CategoryCubit>(),
              ),
            ],
            child: const AddEditExpensePage(),
          ),
        );
      case "/edit-expense":
        final expense = settings.arguments as Expense;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => serviceLocator<ExpenseCubit>(),
              ),
              BlocProvider(
                create: (context) => serviceLocator<CategoryCubit>(),
              ),
            ],
            child: AddEditExpensePage(
              expense: expense,
            ),
          ),
        );
      case "/view-expense":
        final expense = settings.arguments as Expense;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => serviceLocator<ExpenseCubit>(),
            child: ViewExpensePage(
              expense: expense,
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) =>
              const MyHomePage(title: 'Flutter Demo Home Page'),
        );
    }
  }
}
