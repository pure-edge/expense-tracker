import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/core/errors/exceptions.dart';
import 'package:expense_tracker/features/expense/data/data_source/category_remote_datasource.dart';
import 'package:expense_tracker/features/expense/domain/entities/category.dart';

class CategoryFirebaseDatasource implements ExpenseCategoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  const CategoryFirebaseDatasource(this._firestore);

  @override
  Future<List<ExpenseCategory>> getAllCategories() async {
    try {
      final querySnapshot =
          await _firestore.collection('categories').orderBy('name').get();
      return querySnapshot.docs
          .map((doc) => ExpenseCategory(
                id: doc.id,
                name: doc['name'],
              ))
          .toList();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }
}
