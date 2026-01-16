import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/expenses_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/cache/cache_service.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  final ExpensesApi api;
  final SecureStorage storage;
  final CacheService cache;

  ExpensesCubit(this.api, this.storage, this.cache) : super(ExpensesInitial());

  Future<void> fetchExpenses({bool fromCache = true}) async {
    // If fromCache is true, try to load from cache first
    if (fromCache) {
      final cachedData = cache.getCachedExpenses();
      if (cachedData != null && cachedData.isNotEmpty) {
        emit(ExpensesLoaded(cachedData));
        // Continue to fetch fresh data in background
        _fetchAndUpdateExpenses();
        return;
      }
    }

    // No cache available, show loading
    emit(ExpensesLoading());
    await _fetchAndUpdateExpenses();
  }

  Future<void> _fetchAndUpdateExpenses() async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final expenses = await api.getExpenses(token);
      
      // Cache the fresh data
      await cache.cacheExpenses(expenses);
      
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
      await fetchExpenses(fromCache: false); // Reload the list (force refresh)
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
      await fetchExpenses(fromCache: false); // Reload the list (force refresh)
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
