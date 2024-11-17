import 'package:equatable/equatable.dart';

class ExpenseCategory extends Equatable {
  final String id;
  final String name;

  const ExpenseCategory({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}
