import 'package:expense_tracker/core/services/injection_container.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense.dart';
import 'package:expense_tracker/features/expense/presentation/add_edit_expense_page.dart';
import 'package:expense_tracker/features/expense/presentation/cubit/category_cubit.dart';
import 'package:expense_tracker/features/expense/presentation/cubit/expense_cubit.dart';
import 'package:expense_tracker/features/expense/presentation/view_expense_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: ViewExpensePage(
              expense: Expense(
                  id: '123',
                  amount: 123,
                  category: 'Shopping',
                  date: DateTime(2024, 11, 11),
                  description: 'Laptop'))),
    ),
  );
}

class ViewExpensePage extends StatefulWidget {
  final Expense expense;

  const ViewExpensePage({
    super.key,
    required this.expense,
  });

  @override
  State<ViewExpensePage> createState() => _ViewExpensePageState();
}

class _ViewExpensePageState extends State<ViewExpensePage> {
  late Expense _currentExpense;

  @override
  void initState() {
    super.initState();
    _currentExpense = widget.expense;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseCubit, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseDeleted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context, "Expense deleted");
        } else if (state is ExpenseError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentExpense.description),
          actions: [
            IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) =>
                                  serviceLocator<ExpenseCubit>(),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  serviceLocator<CategoryCubit>(),
                            ),
                          ],
                          child: AddEditExpensePage(expense: _currentExpense),
                        ),
                      ));

                  if (result.runtimeType == Expense) {
                    setState(() {
                      _currentExpense = result as Expense;
                    });
                  }
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text("Deleting expense..."),
                    duration: Duration(seconds: 9),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  context.read<ExpenseCubit>().deleteExpense(widget.expense);
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            LabelValueRow(
              label: 'Date',
              value: _currentExpense.date,
            ),
            LabelValueRow(
              label: 'Amount',
              value: _currentExpense.amount,
            ),
            LabelValueRow(
              label: 'Description',
              value: _currentExpense.description,
            ),
            LabelValueRow(
              label: 'Category',
              value: _currentExpense.category,
            ),
          ],
        ),
      ),
    );
  }
}
