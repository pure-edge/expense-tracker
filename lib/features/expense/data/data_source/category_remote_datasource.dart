import 'package:expense_tracker/features/expense/domain/entities/category.dart';

abstract class ExpenseCategoryRemoteDataSource {
  Future<List<ExpenseCategory>> getAllCategories();
}
