import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_payments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsTab extends StatelessWidget {
  final int patientId;
  const PaymentsTab({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PatientPaymentsCubit>()..fetchPayments(patientId),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<PatientPaymentsCubit, PatientPaymentsState>(
              builder: (context, state) {
                if (state is PatientPaymentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PatientPaymentsLoaded) {
                  if (state.payments.isEmpty) {
                    return const Center(child: Text('Ödəniş yoxdur'));
                  }

                  return ListView.builder(
                    itemCount: state.payments.length,
                    itemBuilder: (context, index) {
                      final payment = state.payments[index];
                      return ListTile(
                        title: Text('${payment['amount']} AZN'),
                        subtitle: Text(payment['note'] ?? 'Qeyd yoxdur'),
                        trailing: Text(payment['createdAt'].substring(0, 10)),
                      );
                    },
                  );
                }

                if (state is PatientPaymentsError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // bottom sheet ilə yeni payment əlavə etmək
              },
              child: const Text('Ödəniş əlavə et'),
            ),
          ),
        ],
      ),
    );
  }
}