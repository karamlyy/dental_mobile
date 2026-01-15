import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/features/expenses/presentation/cubit/expenses_cubit.dart';
import 'package:dental_mobile/features/expenses/presentation/widgets/add_expense_sheet.dart';
import 'package:dental_mobile/features/expenses/presentation/widgets/expense_detail_sheet.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dental_mobile/core/error/app_error.dart';
import 'package:dental_mobile/common/widgets/error_bottom_sheet.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myExpenses),forceMaterialTransparency: true,),
      floatingActionButton: Builder(
        builder: (context) {
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const AddExpenseSheet(),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children:  [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    l10n.newExpense,
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

      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: isDarkMode ? 0.02 : 0.7,
              child: SvgPicture.asset(
                'assets/icons/appBackground.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          BlocConsumer<ExpensesCubit, ExpensesState>(
            listener: (context, state) {
              if (state is ExpensesError) {
                ErrorBottomSheet.show(
                  context,
                  AppError(
                    message: state.message,
                    error: state.error,
                    statusCode: state.statusCode,
                  ),
                );
              }
            },
            builder: (context, state) {
          if (state is ExpensesLoading && state is! ExpensesLoaded) {
            return const LoadingIndicator();
          }

          if (state is ExpensesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Xəta baş verdi: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ExpensesCubit>().fetchExpenses(),
                    child: const Text('Yenidən yoxla'),
                  ),
                ],
              ),
            );
          }

          if (state is ExpensesLoaded) {
            final expenses = state.expenses;

            if (expenses.isEmpty) {
              return const Center(child: Text('Hələ ki xərc yoxdur'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: expenses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                final expense = expenses[index];
                final price = expense['price'];
                final title = expense['title'] ?? 'Xərc adı yoxdur';
                final rawDescription = expense['description'];
                final description = (rawDescription == null ||
                        rawDescription.toString().trim().isEmpty)
                    ? 'Xərc təsviri yoxdur'
                    : rawDescription.toString();

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => ExpenseDetailSheet(
                          expense: expense,
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.errorContainer,
                        child: Icon(
                          Icons.money_off,
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                      title: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        '-$price ₼',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },


      ),
        ],
      ),
    );
  }
}
