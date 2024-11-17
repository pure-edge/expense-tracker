part of 'expense_cubit.dart';

// Define Expense states
abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;

  const ExpenseLoaded(this.expenses);

  @override
  List<Object> get props => [expenses];
}

class ExpenseAdded extends ExpenseState {}

class ExpenseDeleted extends ExpenseState {}

class ExpenseUpdated extends ExpenseState {
  final Expense newExpense;

  const ExpenseUpdated(this.newExpense);

  @override
  List<Object> get props => [newExpense];
}

class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object> get props => [message];
}
