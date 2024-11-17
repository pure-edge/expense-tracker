import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/expense/domain/entities/category.dart';
import 'package:expense_tracker/features/expense/domain/usecases/get_all_categories.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  // Use case instances
  final GetAllCategories _getAllCategories;

  CategoryCubit(
    this._getAllCategories,
  ) : super(CategoryInitial());

  // Method to fetch all expenses
  Future<void> fetchAllCategories() async {
    emit(CategoryLoading());

    try {
      final result = await _getAllCategories().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) => emit(CategoryError(failure.message)),
        (expenses) {
          emit(CategoryLoaded(expenses));
        },
      );
    } on TimeoutException catch (_) {
      emit(const CategoryError(
          "There seems to be a problem with your Internet connection"));
    }
  }
}
