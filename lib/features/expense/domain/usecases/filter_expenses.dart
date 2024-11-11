import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/expense.dart';
import '../repositories/expense_repo.dart';

class FilterExpenses {
  final ExpenseRepository expenseRepository;

  FilterExpenses(this.expenseRepository);

  Future<Either<Failure, List<Expense>>> call(ExpenseFilter filter) async {
    return await expenseRepository.filterExpenses(filter);
  }
}
