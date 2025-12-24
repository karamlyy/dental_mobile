import 'package:dental_mobile/common/widgets/primary_button.dart';
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
        appBar: AppBar(
          title: const Text('Yeni pasiyent'),
          centerTitle: true,
          elevation: 0,
        ),
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
              children: [
                // 🔹 Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: const [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person_add,
                            color: Colors.white, size: 32),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Yeni pasiyent əlavə et',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Pasiyentin əsas məlumatlarını daxil edin',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Form Card
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      BlocBuilder<AddPatientCubit, AddPatientState>(
                        buildWhen: (p, c) => p.fullName != c.fullName,
                        builder: (context, state) {
                          return TextFormField(
                            initialValue: state.fullName,
                            decoration: InputDecoration(
                              labelText: 'Ad və Soyad',
                              filled: true,
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                        buildWhen: (p, c) => p.phone != c.phone,
                        builder: (context, state) {
                          return TextField(

                            keyboardType: TextInputType.phone,

                            decoration: InputDecoration(
                              labelText: 'Telefon nömrəsi',
                              filled: true,
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            ),

                            onChanged: (value) => context
                                .read<AddPatientCubit>()
                                .phoneChanged(value),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                BlocBuilder<AddPatientCubit, AddPatientState>(
                  buildWhen: (p, c) => p.status != c.status,
                  builder: (context, state) {
                    return PrimaryButton(
                      text: 'Pasiyenti əlavə et',
                      onPressed: state.status == AddPatientStatus.loading
                          ? null
                          : () => context.read<AddPatientCubit>().submit(),
                      icon: state.status == AddPatientStatus.loading
                          ? null
                          : Icons.person_add, // istəsən icon əlavə edə bilərsən
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