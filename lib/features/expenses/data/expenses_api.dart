import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class ExpensesApi {
  final DioClient dioClient;

  ExpensesApi(this.dioClient);

  Future<List<Map<String, dynamic>>> getExpenses(String accessToken) async {
    final res = await dioClient.dio.get(
      '/expenses',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return List<Map<String, dynamic>>.from(res.data);
  }

  Future<Map<String, dynamic>> createExpense(
    String accessToken,
    Map<String, dynamic> body,
  ) async {
    final res = await dioClient.dio.post(
      '/expenses',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return res.data;
  }

  Future<Map<String, dynamic>> updateExpense(
    String accessToken,
    String expenseId,
    Map<String, dynamic> body,
  ) async {
    final res = await dioClient.dio.patch(
      '/expenses/$expenseId',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return res.data;
  }

  Future<void> deleteExpense(
    String accessToken,
    String expenseId,
  ) async {
    await dioClient.dio.delete(
      '/expenses/$expenseId',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }
}
