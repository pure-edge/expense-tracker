import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];

  String getMessage() {
    return message;
  }
}

class APIFailure extends Failure {
  final String statusCode;
  const APIFailure({required super.message, required this.statusCode});

  @override
  List<Object> get props => [super.message, statusCode];

  @override
  String getMessage() {
    return '$statusCode: ${super.message}';
  }
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class GeneralFailure extends Failure {
  const GeneralFailure({required super.message});
}
