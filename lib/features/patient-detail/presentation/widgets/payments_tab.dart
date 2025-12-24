import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_payments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_payment_sheet.dart';

class PaymentsTab extends StatelessWidget {
  final int patientId;
  const PaymentsTab({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PatientPaymentsCubit>()..fetchPayments(patientId),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<PatientPaymentsCubit, PatientPaymentsState>(
          builder: (context, state) {
            if (state is PatientPaymentsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PatientPaymentsLoaded) {

              if (state.payments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.money_rounded,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Bu pasiyentin ödənişi yoxdur',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.payments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final payment = state.payments[index];

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.payments, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${payment['amount']} AZN',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                payment['note'] ?? 'Qeyd yoxdur',

                              ),
                            ],
                          ),
                        ),
                        Text(
                          payment['createdAt'].substring(0, 10),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
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
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                final cubit = context.read<PatientPaymentsCubit>();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => AddPaymentSheet(
                    patientId: patientId,
                    cubit: cubit,
                  ),
                );
              },
              child: const Icon(Icons.add),
            );
          }
        ),
      ),
    );
  }
}