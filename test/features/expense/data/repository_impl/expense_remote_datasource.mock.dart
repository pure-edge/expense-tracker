// Mock class for the remote data source
import 'package:expense_tracker/features/expense/data/data_source/expense_remote_datasource.dart';
import 'package:mocktail/mocktail.dart';

class MockExpenseRemoteDataSource extends Mock
    implements ExpenseRemoteDataSource {}
