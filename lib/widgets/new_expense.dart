import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

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

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Category selectedCategory = Category.food;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

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

  Widget _buildTitleTextField() {
    return TextField(
      maxLength: 50,
      keyboardType: TextInputType.text,
      controller: _titleController,
      decoration: const InputDecoration(labelText: 'Title'),
    );
  }

  Widget _buildAmountTextField() {
    return TextField(
      keyboardType: TextInputType.number,
      controller: _amountController,
      decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$'),
    );
  }

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

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancel'),
    );
  }

  Widget _buildSaveExpenseButton() {
    return ElevatedButton(
      onPressed: _submitExpenseData,
      child: const Text('Save Expense'),
    );
  }
}
