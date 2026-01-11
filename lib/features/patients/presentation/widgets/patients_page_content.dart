import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/features/patients/presentation/cubit/patients_cubit.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PatientsPageContent extends StatelessWidget {
  const PatientsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<PatientsCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: l10n.searchPatients,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) =>
                context.read<PatientsCubit>().onSearchChanged(value),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocConsumer<PatientsCubit, PatientsState>(
              listener: (context, state) {
                if (state is PatientsLoaded) {
                  _refreshList(state.patients, cubit, context);
                }
              },
              builder: (context, state) {
                if (state is PatientsLoading) {
                  return const LoadingIndicator();
                } else if (state is PatientsLoaded) {
                  if (state.patients.isEmpty && cubit.animatedListItems.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noPatientsFound,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  return AnimatedList(
                    key: cubit.listKey,
                    initialItemCount: cubit.animatedListItems.length,
                    itemBuilder: (context, index, animation) {
                      if (index >= cubit.animatedListItems.length) {
                        return const SizedBox();
                      }
                      final patient = cubit.animatedListItems[index];
                      return _buildItem(patient, animation, context);
                    },
                  );
                } else if (state is PatientsError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _refreshList(List<dynamic> newPatients, PatientsCubit cubit, BuildContext context) {
    for (var i = cubit.animatedListItems.length - 1; i >= 0; i--) {
       final removedItem = cubit.animatedListItems.removeAt(i);
       cubit.listKey.currentState?.removeItem(
         i, 
         (context, animation) => _buildItem(removedItem, animation, context),
       );
    }
    
    Future.forEach(newPatients.asMap().entries, (entry) async {
      await Future.delayed(const Duration(milliseconds: 50));
      cubit.animatedListItems.add(entry.value);
      cubit.listKey.currentState?.insertItem(cubit.animatedListItems.length - 1);
    });
  }

  Widget _buildItem(dynamic patient, Animation<double> animation, BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0), // Adjust if needed
          child: GestureDetector(
            onTap: () {
              context.push('/patient/${patient['id']}');
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12), // Add margin for spacing
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,

                        child: SvgPicture.asset(
                          patient['gender'] == 'MALE'
                              ? 'assets/icons/male.svg'
                              : 'assets/icons/female.svg',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patient['fullName'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              patient['phone'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
}
