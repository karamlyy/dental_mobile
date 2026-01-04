part of 'expenses_cubit.dart';

abstract class ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<Map<String, dynamic>> expenses;

  ExpensesLoaded(this.expenses);
}

class ExpensesError extends ExpensesState {
  final String message;
  final dynamic error;
  final int? statusCode;

  ExpensesError(this.message, {this.error, this.statusCode});
}
