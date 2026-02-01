import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../home/data/appointments_api.dart';
import 'appointments_page_state.dart';

class AppointmentsPageCubit extends Cubit<AppointmentsPageState> {
  final AppointmentsApi api;
  final SecureStorage storage;

  AppointmentsPageCubit(this.api, this.storage) : super(AppointmentsPageInitial());

  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  final List<dynamic> animatedListItems = [];
  
  DateTime selectedDate = DateTime.now();

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> fetchAppointments({DateTime? date}) async {
    if (date != null) {
      selectedDate = date;
    }
    
    emit(AppointmentsPageLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final appointments = await api.getAppointments(
        token,
        date: _formatDate(selectedDate),
      );

      appointments.sort((a, b) {
        final startA = a['startTime'] as String;
        final startB = b['startTime'] as String;
        return startA.compareTo(startB);
      });

      emit(AppointmentsPageLoaded(appointments));
    } catch (e) {
      emit(AppointmentsPageError(e.toString()));
    }
  }

  void changeDate(DateTime date) {
    fetchAppointments(date: date);
  }
}
