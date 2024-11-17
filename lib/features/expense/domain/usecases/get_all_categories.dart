import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/failure.dart';
import 'package:expense_tracker/features/expense/domain/entities/category.dart';
import 'package:expense_tracker/features/expense/domain/repositories/category_repo.dart';

class GetAllCategories {
  final ExpenseCategoryRepository repository;

  GetAllCategories(this.repository);

  Future<Either<Failure, List<ExpenseCategory>>> call() async {
    return await repository.getAllCategories();
  }
}
