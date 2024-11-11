import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/expense.dart';
import '../repositories/expense_repo.dart';

class GetAllExpenses {
  final ExpenseRepository expenseRepository;

  GetAllExpenses(this.expenseRepository);

  Future<Either<Failure, List<Expense>>> call() async {
    return await expenseRepository.getAllExpenses();
  }
}
