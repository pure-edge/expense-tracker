import 'package:dartz/dartz.dart';
import 'package:expense_tracker/features/expense/domain/entities/category.dart';

import '../../../../core/errors/failure.dart';

abstract class ExpenseCategoryRepository {
  Future<Either<Failure, List<ExpenseCategory>>> getAllCategories();
}
