import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/expenses_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  final ExpensesApi api;
  final SecureStorage storage;

  ExpensesCubit(this.api, this.storage) : super(ExpensesInitial());

  Future<void> fetchExpenses() async {
    emit(ExpensesLoading());
    
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final expenses = await api.getExpenses(token);
      
      if (isClosed) return;
      emit(ExpensesLoaded(expenses));
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(ExpensesError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  Future<void> updateExpense(String expenseId, Map<String, dynamic> body) async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await api.updateExpense(token, expenseId, body);
      await fetchExpenses(); // Reload the list
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(ExpensesError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await api.deleteExpense(token, expenseId);
      await fetchExpenses(); // Reload the list
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(ExpensesError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  void clear() {
    emit(ExpensesInitial());
  }
}
