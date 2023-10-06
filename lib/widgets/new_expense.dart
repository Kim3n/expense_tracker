import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

/// A widget that allows the user to add a new expense or update an existing one.
///
/// If [onAddExpense] is provided, the widget is used to add a new expense. If [onUpdateExpense] and [expenseToUpdate] are provided, the widget is used to update an existing expense.
///
/// The [onAddExpense] function is called when the user adds a new expense. The [onUpdateExpense] function is called when the user updates an existing expense. The [oldExpense] parameter of [onUpdateExpense] is the expense before the update, and the [updatedExpense] parameter is the expense after the update.
///
/// The [expenseToUpdate] parameter is the expense that the user wants to update. If it is null, the widget is used to add a new expense.
class NewExpense extends StatefulWidget {
  final Function(Expense)? onAddExpense;
  final Function(
      {required Expense oldExpense,
      required Expense updatedExpense})? onUpdateExpense;
  final Expense? expenseToUpdate;

  const NewExpense({
    Key? key,
    required this.onAddExpense,
  })  : onUpdateExpense = null,
        expenseToUpdate = null,
        super(key: key);

  const NewExpense.update({
    Key? key,
    required this.onUpdateExpense,
    required this.expenseToUpdate,
  })  : onAddExpense = null,
        super(key: key);

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

/// This class represents the state of the NewExpense widget.
/// It contains controllers for the title and amount fields, as well as the selected date and category.
class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Category selectedCategory = Category.food;

  /// Disposes the [_titleController] and [_amountController] when the widget is removed from the tree.
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// Shows a date picker dialog and updates the selected date if a date is chosen.
  /// The date picker dialog shows dates from one year ago to the current date.
  ///
  /// The function is asynchronous and returns a Future that completes with the
  /// selected date or null if the user cancels the dialog.
  ///
  /// The selected date is stored in the state of the widget and is used to display
  /// the selected date in the UI.
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  /// This method is called when the user submits the expense data.
  /// It validates the user input and shows an alert dialog if the input is invalid.
  /// If the input is valid, it creates a new expense object and passes it to the parent widget's callback function.
  /// If the widget has an expenseToUpdate property, it calls the parent widget's onUpdateExpense callback function.
  /// Otherwise, it calls the parent widget's onAddExpense callback function.
  /// Finally, it pops the current screen from the navigation stack.
  void _submitExpenseData() {
    final amount = double.tryParse(_amountController.text);
    if (_titleController.text.trim().isEmpty || amount == null || amount <= 0) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Input!'),
            content: const Text('Please enter a valid title and amount.'),
            icon: const Icon(Icons.error),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
    } else {
      final newExpense = Expense(
        title: _titleController.text.trim(),
        category: selectedCategory,
        amount: amount,
        date: selectedDate,
      );

      final expenseToUpdate = widget.expenseToUpdate;
      if (expenseToUpdate != null) {
        widget.onUpdateExpense!(
          oldExpense: expenseToUpdate,
          updatedExpense: newExpense,
        );
      } else {
        widget.onAddExpense!(newExpense);
      }
      Navigator.pop(context);
    }
  }

  /// Initializes the state of the [NewExpense] widget.
  /// If [widget.expenseToUpdate] is not null, sets the initial values of the
  /// [_amountController], [_titleController], [selectedCategory], and [selectedDate]
  /// to the corresponding values of the [widget.expenseToUpdate].
  @override
  void initState() {
    super.initState();
    final expenseToUpdate = widget.expenseToUpdate;
    if (expenseToUpdate != null) {
      _amountController.text = expenseToUpdate.amount.toString();
      _titleController.text = expenseToUpdate.title;
      selectedCategory = expenseToUpdate.category;
      selectedDate = expenseToUpdate.date;
    }
  }

  /// Builds the UI for adding a new expense.
  ///
  /// Returns a [Widget] that contains a form for adding a new expense.
  /// The form includes text fields for the expense title and amount,
  /// a dropdown for selecting the expense category, a date picker for
  /// selecting the expense date, and buttons for saving or canceling the expense.
  /// The UI is responsive and adjusts its layout based on the screen width.
  /// The [keyboardSpace] parameter is used to adjust the padding of the form
  /// to avoid overlapping with the keyboard when it is displayed.
  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildTitleTextField()),
                        const SizedBox(width: 24),
                        Expanded(child: _buildAmountTextField()),
                      ],
                    ),
                    Row(
                      children: [
                        _buildCategorySelectionDropdown(),
                        Expanded(child: _buildDatePickerRow()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Spacer(),
                        _buildCancelButton(),
                        _buildSaveExpenseButton(),
                      ],
                    )
                  ] else ...[
                    _buildTitleTextField(),
                    Row(
                      children: [
                        Expanded(child: _buildAmountTextField()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDatePickerRow()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildCategorySelectionDropdown(),
                        const Spacer(),
                        _buildCancelButton(),
                        _buildSaveExpenseButton(),
                      ],
                    )
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds a text field for the title of a new expense.
  ///
  /// Returns a [TextField] widget with a maximum length of 50 characters,
  /// a text input type of [TextInputType.text], and a label of 'Title'.
  Widget _buildTitleTextField() {
    return TextField(
      maxLength: 50,
      keyboardType: TextInputType.text,
      controller: _titleController,
      decoration: const InputDecoration(labelText: 'Title'),
    );
  }

  /// Builds a [TextField] widget for entering the amount of a new expense.
  /// The [TextField] has a [TextInputType.number] keyboard type and a [_amountController] controller.
  /// It also has a label text of 'Amount' and a prefix text of '\$' in the decoration.
  Widget _buildAmountTextField() {
    return TextField(
      keyboardType: TextInputType.number,
      controller: _amountController,
      decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$'),
    );
  }

  /// Builds a dropdown button widget for selecting a category.
  ///
  /// Returns a [DropdownButton] widget that displays a list of [Category] values
  /// as dropdown menu items. The currently selected category is stored in the
  /// [selectedCategory] variable. When the user selects a new category, the
  /// [onChanged] callback function is called with the new value, which updates
  /// the selected category and rebuilds the widget.
  Widget _buildCategorySelectionDropdown() {
    return DropdownButton(
      value: selectedCategory,
      items: Category.values
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item.name.toUpperCase()),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedCategory = value;
          });
        }
      },
    );
  }

  /// Builds a row containing a text widget displaying the selected date formatted using [formatter]
  /// and an icon button that opens a date picker dialog when pressed.
  /// Returns the row as a [Widget].
  Widget _buildDatePickerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(formatter.format(selectedDate)),
        IconButton(
          onPressed: _presentDatePicker,
          icon: const Icon(
            Icons.calendar_month,
          ),
        ),
      ],
    );
  }

  /// Builds a cancel button widget.
  ///
  /// Returns a [TextButton] widget with the text "Cancel" and an [onPressed] function that pops the current route off the navigator.
  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancel'),
    );
  }

  /// Builds a save expense button widget.
  ///
  /// Returns an [ElevatedButton] widget with the text 'Save Expense' and
  /// an onPressed callback that calls [_submitExpenseData] function.
  Widget _buildSaveExpenseButton() {
    return ElevatedButton(
      onPressed: _submitExpenseData,
      child: const Text('Save Expense'),
    );
  }
}
