import 'package:expense_tracker/features/expense/domain/entities/expense.dart';
import 'package:expense_tracker/features/expense/presentation/cubit/category_cubit.dart';
import 'package:expense_tracker/features/expense/presentation/cubit/expense_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  Expense e = Expense(
      id: 'asdsd123',
      amount: 123,
      category: 'Utility',
      date: DateTime.now(),
      description: 'WiFi bill');

  runApp(MaterialApp(
    home: Scaffold(
      body: AddEditExpensePage(
        expense: e,
      ),
    ),
  ));
}

class AddEditExpensePage extends StatefulWidget {
  final Expense? expense;

  const AddEditExpensePage({super.key, this.expense});

  @override
  State<AddEditExpensePage> createState() => _AddEditExpensePageState();
}

class _AddEditExpensePageState extends State<AddEditExpensePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().fetchAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle =
        widget.expense == null ? 'Add new expense' : 'Edit expense';
    String buttonLabel =
        widget.expense == null ? 'Add Expense' : 'Edit Expense';

    final initialValues = {
      'amount': widget.expense?.amount.toString(),
      'category': widget.expense?.category,
      'description': widget.expense?.description,
      'date': widget.expense?.date,
    };

    return BlocListener<ExpenseCubit, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is ExpenseAdded) {
          Navigator.pop(context, "Expense added");
        } else if (state is ExpenseUpdated) {
          Navigator.pop(context, state.newExpense);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: Column(
          children: [
            Expanded(
                child: FormBuilder(
              key: _formKey,
              initialValue: initialValues,
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  FormBuilderTextField(
                    name: 'amount',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Amount',
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.positiveNumber(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CategoryDropdown(),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderTextField(
                    name: 'description',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderDateTimePicker(
                    name: 'date',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  )
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: _isPerforming
                            ? null
                            : () {
                                bool isValid =
                                    _formKey.currentState!.validate();
                                final inputs =
                                    _formKey.currentState!.instantValue;

                                if (isValid) {
                                  setState(() {
                                    _isPerforming = true;
                                  });

                                  final newExpense = Expense(
                                      id: widget.expense?.id ?? "",
                                      amount: double.parse(inputs['amount']),
                                      category: inputs['category'],
                                      date: inputs['date'],
                                      description: inputs['description']);

                                  if (widget.expense == null) {
                                    // cubit.addExpense()
                                    context
                                        .read<ExpenseCubit>()
                                        .addExpense(newExpense);
                                  } else {
                                    context
                                        .read<ExpenseCubit>()
                                        .updateExpense(newExpense);
                                  }
                                }
                              },
                        child: _isPerforming
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ))
                            : Text(buttonLabel)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                width: 16.0,
              ),
              Text("Loading..."),
            ],
          );
        } else if (state is CategoryError) {
          return TextButton(
            onPressed: () {
              context.read<CategoryCubit>().fetchAllCategories();
            },
            child: const Text('Tap to load again'),
          );
        } else if (state is CategoryLoaded) {
          return FormBuilderDropdown(
            name: 'category',
            items: state.categories
                .map((category) => DropdownMenuItem(
                    value: category.name, child: Text(category.name)))
                .toList(),
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category',
                hintText: 'Select category'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          );
        } else {
          return TextButton(
            onPressed: () {
              context.read<CategoryCubit>().fetchAllCategories();
            },
            child: const Text('Tap to load again'),
          );
        }
      },
    );
  }
}
