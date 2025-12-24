// features/home/presentation/cubit/stats_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/stats_api.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final StatsApi api;
  final SecureStorage storage;

  StatsCubit(this.api, this.storage) : super(StatsInitial());

  Future<void> fetchStats() async {
    emit(StatsLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No token');

      final data = await api.getHomeStats(token);

      if (isClosed) return;
      emit(StatsLoaded(
        todayAppointments: data['todayAppointments'],
        totalPatients: data['totalPatients'],
        nextAppointment: data['nextAppointment'],
      ));
    } catch (e) {
      if (isClosed) return;
      emit(StatsError(e.toString()));
    }
  }
}