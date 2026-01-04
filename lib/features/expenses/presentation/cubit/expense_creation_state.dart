part of 'expense_creation_cubit.dart';

abstract class ExpenseCreationState {}

class ExpenseCreationInitial extends ExpenseCreationState {}

class ExpenseCreationLoading extends ExpenseCreationState {}

class ExpenseCreationSuccess extends ExpenseCreationState {}

class ExpenseCreationError extends ExpenseCreationState {
  final String message;
  final dynamic error;
  final int? statusCode;

  ExpenseCreationError(this.message, {this.error, this.statusCode});
}
