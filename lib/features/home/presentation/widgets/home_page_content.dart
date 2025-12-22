import 'package:dental_mobile/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.go('/patients');
          },
          child: Container(
            color: Colors.blueAccent,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            child: const Center(
                child: Text('Pasiyentlərim', style: TextStyle(color: Colors.white, fontSize: 18))),
          ),
        ),
        Expanded(
          child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
            builder: (context, state) {
              if (state is AppointmentsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AppointmentsLoaded) {
                if (state.appointments.isEmpty) {
                  return const Center(child: Text('Növbəti 3 gün üçün appointment yoxdur'));
                }
                return ListView.builder(
                  itemCount: state.appointments.length,
                  itemBuilder: (context, index) {
                    final a = state.appointments[index];
                    final patient = a['patient'];
                    return ListTile(
                      title: Text(patient['fullName']),
                      subtitle: Text('${a['date']} ${a['startTime']} - ${a['endTime']}'),
                      trailing: Text(a['status']),
                    );
                  },
                );
              } else if (state is AppointmentsError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}