import 'package:expense_tracker/core/services/injection_container.dart';
import 'package:expense_tracker/core/widgets/empty_state_list.dart';
import 'package:expense_tracker/core/widgets/error_state_list.dart';
import 'package:expense_tracker/core/widgets/loading_state_shimmer_list.dart';
import 'package:expense_tracker/features/expense/presentation/add_edit_expense_page.dart';
import 'package:expense_tracker/features/expense/presentation/cubit/category_cubit.dart';
import 'package:expense_tracker/features/expense/presentation/cubit/expense_cubit.dart';
import 'package:expense_tracker/features/expense/presentation/view_expense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAllExpensesPage extends StatefulWidget {
  const ViewAllExpensesPage({super.key});

  @override
  State<ViewAllExpensesPage> createState() => _ViewAllExpensesPageState();
}

class _ViewAllExpensesPageState extends State<ViewAllExpensesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseCubit>().fetchAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses"),
      ),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const LoadingStateShimmerList();
          } else if (state is ExpenseLoaded) {
            if (state.expenses.isEmpty) {
              return const EmptyStateList(
                imageAssetName: 'assets/images/empty.png',
                title: 'Oops...There are no expenses here',
                description: "Tap '+' button to add a new expense",
              );
            }

            return ListView.builder(
              itemCount: state.expenses.length,
              itemBuilder: (context, index) {
                final currentExpense = state.expenses[index];

                return Card(
                  child: ListTile(
                    title: Text("Php ${currentExpense.amount}"),
                    subtitle: Text(currentExpense.description),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => serviceLocator<ExpenseCubit>(),
                            child: ViewExpensePage(
                              expense: currentExpense,
                            ),
                          ),
                        ),
                      );
                      context
                          .read<ExpenseCubit>()
                          .fetchAllExpenses(); // refresh the page

                      if (result.runtimeType == String) {
                        final snackBar =
                            SnackBar(content: Text(result as String));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is ExpenseError) {
            return ErrorStateList(
              imageAssetName: 'assets/images/error.png',
              errorMessage: state.message,
              onRetry: () {
                context.read<ExpenseCubit>().fetchAllExpenses();
              },
            );
          } else {
            return const EmptyStateList(
              imageAssetName: 'assets/images/empty.png',
              title: 'Oops...There are no expenses here',
              description: "Tap '+' button to add a new expense",
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
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
              ));

          context
              .read<ExpenseCubit>()
              .fetchAllExpenses(); // refresh the view all expenses page

          if (result.runtimeType == String) {
            final snackBar = SnackBar(content: Text(result as String));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
