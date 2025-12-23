import 'package:dental_mobile/config/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/add_patient_cubit.dart';

class AddPatientPage extends StatelessWidget {
  const AddPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddPatientCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Yeni Pasiyent')),
        body: BlocListener<AddPatientCubit, AddPatientState>(
          listener: (context, state) {
            if (state.status == AddPatientStatus.success) {
              Navigator.pop(context, true);
            } else if (state.status == AddPatientStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Xəta baş verdi')),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<AddPatientCubit, AddPatientState>(
                  buildWhen: (previous, current) =>
                      previous.fullName != current.fullName,
                  builder: (context, state) {
                    return TextFormField(
                      initialValue: state.fullName,
                      decoration: const InputDecoration(
                        labelText: 'Ad və Soyad',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (value) => context
                          .read<AddPatientCubit>()
                          .fullNameChanged(value),
                      autofocus: true,
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<AddPatientCubit, AddPatientState>(
                  buildWhen: (previous, current) =>
                      previous.phone != current.phone,
                  builder: (context, state) {
                    return TextFormField(
                      initialValue: state.phone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Nömrə',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      onChanged: (value) =>
                          context.read<AddPatientCubit>().phoneChanged(value),
                    );
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<AddPatientCubit, AddPatientState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.status == AddPatientStatus.loading
                          ? null
                          : () => context.read<AddPatientCubit>().submit(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state.status == AddPatientStatus.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Əlavə et'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
