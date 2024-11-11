import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/failure.dart';
import '../entities/expense_summary.dart';
import '../repositories/expense_repo.dart';

class GetExpenseSummary {
  final ExpenseRepository expenseRepository;

  GetExpenseSummary(this.expenseRepository);

  Future<Either<Failure, ExpenseSummary>> call(DateTimeRange period) async {
    return await expenseRepository.getExpenseSummary(period);
  }
}
