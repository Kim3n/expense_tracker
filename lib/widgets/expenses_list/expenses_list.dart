import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense) onRemoveExpense;
  final void Function({required Expense expenseToUpdate}) onUpdateExpense;

  const ExpensesList({
    Key? key,
    required this.expenses,
    required this.onRemoveExpense,
    required this.onUpdateExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        var expenseItem = ExpenseItem(expense: expenses[index]);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Dismissible(
              key: ValueKey(expenses[index]),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  // Delete -> dismiss
                  return true;
                } else {
                  // Update -> request update and do NOT dismiss
                  onUpdateExpense(expenseToUpdate: expenses[index]);
                  return false;
                }
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  onRemoveExpense(expenses[index]);
                } else {
                  // Will never be called, dismiss rejected, see `confirmDismiss` above
                }
              },
              dismissThresholds: const {
                DismissDirection.endToStart:
                    0.4, // Greater threshold for delete, avoid accidental delete
                DismissDirection.startToEnd:
                    0.2, // Smaller threshold for update
              },
              background: DismissableCardBackground(
                icon: Icons.draw,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.75),
                direction: DismissDirection.startToEnd,
                height: 82,
              ),
              secondaryBackground: DismissableCardBackground(
                icon: Icons.delete,
                backgroundColor:
                    Theme.of(context).colorScheme.error.withOpacity(0.75),
                direction: DismissDirection.endToStart,
                height: 82,
              ),
              child: expenseItem,
            ),
          ),
        );
      },
    );
  }
}

class DismissableCardBackground extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final DismissDirection direction;
  final double height;

  const DismissableCardBackground({
    Key? key,
    required this.icon,
    required this.backgroundColor,
    required this.direction,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var iconAlignment = direction == DismissDirection.startToEnd
        ? Alignment.centerLeft
        : Alignment.centerRight;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: height,
      color: backgroundColor,
      alignment: iconAlignment,
      child: Icon(icon),
    );
  }
}
