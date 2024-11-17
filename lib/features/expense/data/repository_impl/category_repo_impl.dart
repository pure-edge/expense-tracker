import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/exceptions.dart';
import 'package:expense_tracker/core/errors/failure.dart';
import 'package:expense_tracker/features/expense/data/data_source/category_remote_datasource.dart';
import 'package:expense_tracker/features/expense/domain/entities/category.dart';
import 'package:expense_tracker/features/expense/domain/repositories/category_repo.dart';

class ExpenseCategoryRepositoryImplementation
    implements ExpenseCategoryRepository {
  final ExpenseCategoryRemoteDataSource _dataSource;
  const ExpenseCategoryRepositoryImplementation(this._dataSource);

  @override
  Future<Either<Failure, List<ExpenseCategory>>> getAllCategories() async {
    try {
      return Right(await _dataSource.getAllCategories());
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
}
