import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/expenses_api.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'expense_creation_state.dart';

class ExpenseCreationCubit extends Cubit<ExpenseCreationState> {
  final ExpensesApi api;
  final SecureStorage storage;
  final AnalyticsService analytics;

  ExpenseCreationCubit(this.api, this.storage, this.analytics) : super(ExpenseCreationInitial());

  Future<void> addExpense({
    required String title,
    required double price,
    required String description,
  }) async {
    emit(ExpenseCreationLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final body = {
        'title': title,
        'price': price,
        'description': description,
      };

      final result = await api.createExpense(token, body);
      
      // Track expense creation in Analytics
      final expenseId = result['id'] as int?;
      await analytics.logExpenseCreated(
        expenseId: expenseId,
        amount: price,
        category: title,
      );
      
      if (isClosed) return;
      emit(ExpenseCreationSuccess());
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(ExpenseCreationError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }
}
