import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/expense.dart';
import '../repositories/expense_repo.dart';

class SearchExpenses {
  final ExpenseRepository expenseRepository;

  SearchExpenses(this.expenseRepository);

  Future<Either<Failure, List<Expense>>> call(String query) async {
    return await expenseRepository.searchExpenses(query);
  }
}
