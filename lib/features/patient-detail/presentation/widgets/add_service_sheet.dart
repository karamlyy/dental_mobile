import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../services/presentation/cubit/services_cubit.dart';
import '../cubit/patient_service_creation_cubit.dart';
import '../cubit/patient_service_creation_state.dart';

class AddServiceSheet extends StatefulWidget {
  final int patientId;
  final PatientServiceCreationCubit cubit;
  final VoidCallback onSuccess;

  const AddServiceSheet({
    super.key,
    required this.patientId,
    required this.cubit,
    required this.onSuccess,
  });

  @override
  State<AddServiceSheet> createState() => _AddServiceSheetState();
}

class _AddServiceSheetState extends State<AddServiceSheet> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    if (name.isEmpty || price == null) {
      Flushbar(
        message: 'Zəhmət olmasa xanaları düzgün doldurun',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red,
      ).show(context);
      return;
    }
    setState(() => _isLoading = true);

    widget.cubit.createService(
      patientId: widget.patientId,
      name: name,
      price: price,
    );
  }

  void _showServicesDialog() {
    _searchController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return BlocBuilder<ServicesCubit, ServicesState>(
              builder: (context, servicesState) {
                if (servicesState is ServicesLoaded) {
                  final searchQuery = _searchController.text.toLowerCase();
                  final filteredServices = servicesState.services.where((
                    service,
                  ) {
                    final name = (service['name'] ?? '').toLowerCase();
                    return name.contains(searchQuery);
                  }).toList();

                  return DraggableScrollableSheet(
                    initialChildSize: 0.7,
                    minChildSize: 0.5,
                    maxChildSize: 0.95,
                    expand: false,
                    builder: (context, scrollController) {
                      return Column(
                        children: [
                          /// Drag Handle
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),

                          /// Title
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Xidmət seçin',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(sheetContext),
                                ),
                              ],
                            ),
                          ),

                          /// Search Field
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: TextFormField(
                              controller: _searchController,

                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Xidmət axtar...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setModalState(() {
                                            _searchController.clear();
                                          });
                                        },
                                      )
                                    : null,
                                filled: true,
                              ),
                              onChanged: (value) {
                                setModalState(() {});
                              },
                            ),
                          ),

                          const Divider(height: 1),

                          /// Services List
                          Expanded(
                            child: filteredServices.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.search_off,
                                          size: 64,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Xidmət tapılmadı',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    controller: scrollController,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    itemCount: filteredServices.length,
                                    itemBuilder: (context, index) {
                                      final service = filteredServices[index];
                                      return ListTile(
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade700
                                                .withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.medical_services_outlined,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                        title: Text(
                                          service['name'] ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text('${service['price']} ₼'),
                                        trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _nameController.text =
                                                service['name'] ?? '';
                                            _priceController.text =
                                                service['price']?.toString() ??
                                                '';
                                          });
                                          Navigator.pop(sheetContext);
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: widget.cubit,
      child:
          BlocConsumer<
            PatientServiceCreationCubit,
            PatientServiceCreationState
          >(
            listener: (context, state) {
              if (state is PatientServiceCreationSuccess) {
                Navigator.pop(context);
                widget.onSuccess();
              } else if (state is PatientServiceCreationError) {
                Flushbar(
                  message: state.message,
                  duration: const Duration(seconds: 3),
                  margin: const EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: Colors.red,
                ).show(context);
              }
            },
            builder: (context, state) {
              final isLoading = state is PatientServiceCreationLoading;
              final maxHeight = MediaQuery.of(context).size.height - 
                               MediaQuery.of(context).padding.top - 
                               kToolbarHeight - 
                               20; // AppBar yüksekliği + boşluk

              return SafeArea(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                      top: 8,
                      left: 16,
                      right: 16,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      /// 🔹 Drag Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      /// 🔹 Title
                      Text(
                        l10n.newService,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.enterNewServiceInfo,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 🔹 Browse Services Button
                      BlocBuilder<ServicesCubit, ServicesState>(
                        builder: (context, servicesState) {
                          if (servicesState is ServicesLoaded &&
                              servicesState.services.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: OutlinedButton.icon(
                                onPressed: _showServicesDialog,
                                icon: const Icon(Icons.list_alt),
                                label: const Text('Mövcud xidmətlərdən seçin'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      /// 🔹 Service Name Card
                      Card(
                        elevation: 0,
                        color: theme.colorScheme.surfaceContainerHighest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: l10n.serviceName,
                              hintText: 'Məs: İmplant',
                              prefixIcon: const Icon(
                                Icons.medical_services_outlined,
                              ),
                            ),
                            autofocus: true,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 🔹 Price Card
                      Card(
                        elevation: 0,
                        color: theme.colorScheme.surfaceContainerHighest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: TextFormField(
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: l10n.price,
                              hintText: 'Məs: 500',
                              prefixIcon: const Icon(Icons.attach_money),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      PrimaryButton(
                        text: l10n.save,
                        isLoading: isLoading,
                        onPressed: _submit,
                        icon: Icons.check,
                      ),
                    ],
                  ),
                ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
