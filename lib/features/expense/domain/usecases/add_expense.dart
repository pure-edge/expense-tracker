import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/expense.dart';
import '../repositories/expense_repo.dart';

class AddExpense {
  final ExpenseRepository expenseRepository;

  AddExpense(this.expenseRepository);

  Future<Either<Failure, void>> call(Expense expense) async {
    return await expenseRepository.addExpense(expense);
  }
}
