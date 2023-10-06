import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

/// A widget that displays a list of expenses.
class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

/// This class represents the state of the Expenses widget.
/// It extends the [State] class with [Expenses] as its generic type.
/// The underscore before the class name indicates that it is a private class.
/// This class is located in the expenses.dart file in the lib/widgets directory.
class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  /// Function to open the add expense overlay.
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  /// Adds an [Expense] to the list of registered expenses and updates the state of the widget.
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  /// Removes the given [expense] from the [_registeredExpenses] list and shows a [SnackBar] with an option to undo the deletion.
  ///
  /// The [expense] is removed by calling the `remove` method of the [_registeredExpenses] list and updating the state of the widget using `setState`.
  /// The [SnackBar] is shown using the [ScaffoldMessenger] of the [context] with a message "Expense deleted." and an action button labeled "Undo".
  /// If the "Undo" button is pressed, the [expense] is re-inserted into the [_registeredExpenses] list at its original index using the `insert` method of the list and updating the state of the widget using `setState`.
  ///
  /// Example usage:
  /// ```dart
  /// void _onRemoveExpenseButtonPressed(Expense expense) {
  ///   _removeExpense(expense);
  /// }
  /// ```
  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  /// Updates an expense in the list of registered expenses.
  ///
  /// The [oldExpense] parameter is the expense to be updated, and the [updatedExpense]
  /// parameter is the new expense to replace the old one.
  ///
  /// This method replaces the [oldExpense] with the [updatedExpense] in the list of
  /// [_registeredExpenses] and updates the state of the widget.
  ///
  /// Example:
  ///
  /// ```dart
  /// Expense oldExpense = Expense(name: 'Groceries', amount: 50.0);
  /// Expense updatedExpense = Expense(name: 'Groceries', amount: 75.0);
  /// _updateExpense(oldExpense: oldExpense, updatedExpense: updatedExpense);
  /// ```
  void _updateExpense(
      {required Expense oldExpense, required Expense updatedExpense}) {
    setState(() {
      _registeredExpenses[_registeredExpenses.indexOf(oldExpense)] =
          updatedExpense;
    });
  }

  /// Opens a modal bottom sheet to update an expense.
  ///
  /// The [expenseToUpdate] parameter is required and specifies the expense to be updated.
  ///
  /// The [showModalBottomSheet] function is used to display the modal bottom sheet.
  ///
  /// The [useSafeArea] parameter is set to true to ensure that the modal bottom sheet is displayed within the safe area of the screen.
  ///
  /// The [isScrollControlled] parameter is set to true to allow the modal bottom sheet to be scrolled if its content exceeds the height of the screen.
  ///
  /// The [context] parameter is required and specifies the build context.
  ///
  /// The [builder] parameter is a callback that returns the widget tree to be displayed within the modal bottom sheet.
  ///
  /// The [NewExpense.update] widget is returned by the builder callback and is used to update the expense.
  ///
  /// The [onUpdateExpense] parameter is a callback that is called when the expense is updated.
  ///
  /// The [expenseToUpdate] parameter is passed to the [NewExpense.update] widget to specify the expense to be updated.
  void _openUpdateExpenseOverlay({required Expense expenseToUpdate}) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense.update(
        onUpdateExpense: _updateExpense,
        expenseToUpdate: expenseToUpdate,
      ),
    );
  }

  /// Builds the expenses screen widget.
  ///
  /// This widget displays a list of expenses and a chart of the expenses.
  /// If there are no expenses, a message is displayed to prompt the user to add some.
  ///
  /// The widget is responsive and adjusts its layout based on the screen width.
  ///
  /// The [context] parameter is required to access the media query.
  ///
  /// The [_registeredExpenses] list contains the registered expenses to be displayed.
  ///
  /// The [_removeExpense] function is called when an expense is removed.
  ///
  /// The [_openUpdateExpenseOverlay] function is called when an expense is updated.
  ///
  /// The [_openAddExpenseOverlay] function is called when the add expense button is pressed.
  ///
  /// Returns a [Scaffold] widget containing the expenses screen.
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
        onUpdateExpense: _openUpdateExpenseOverlay,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
