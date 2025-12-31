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

  Future<void> fetchAppointments() async {
    emit(AppointmentsPageLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final appointments = await api.getAppointments(token);

      appointments.sort((a, b) {
        final dateA = DateTime.parse(a['date']);
        final dateB = DateTime.parse(b['date']);
        return dateA.compareTo(dateB);
      });

      emit(AppointmentsPageLoaded(appointments));
    } catch (e) {
      emit(AppointmentsPageError(e.toString()));
    }
  }
}
