import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_payments_cubit.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_payment_sheet.dart';

class PaymentsTab extends StatelessWidget {
  final int patientId;
  const PaymentsTab({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => sl<PatientPaymentsCubit>()..fetchPayments(patientId),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<PatientPaymentsCubit, PatientPaymentsState>(
          builder: (context, state) {
            if (state is PatientPaymentsLoading) {
              return const LoadingIndicator();
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
                       Text(
                        l10n.noPaymentsFound,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.payments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 0),
                itemBuilder: (context, index) {
                  final payment = state.payments[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                    child: ListTile(

                      leading: const Icon(
                        Icons.payments,
                        color: Colors.green,
                        size: 32,
                      ),

                      title: Text(
                        '${payment['amount']} AZN',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          (payment['note'] == null ||
                              payment['note'].toString().trim().isEmpty)
                              ? 'Qeyd yoxdur'
                              : payment['note'],
                        ),
                      ),

                      trailing: Text(
                        payment['createdAt'].substring(0, 10),
                        style: const TextStyle(color: Colors.grey),
                      ),
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
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                final cubit = context.read<PatientPaymentsCubit>();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) =>
                      AddPaymentSheet(patientId: patientId, cubit: cubit),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      l10n.newPayment,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
