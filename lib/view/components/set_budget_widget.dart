import 'package:flutter/material.dart';
import 'package:gestia/model/budget_goal.dart';
import 'package:gestia/service/budget_goal_service.dart';
import 'package:gestia/view/components/snack_bar_message.dart';
import 'package:gestia/view/pages/budget_goal_list.dart';
import 'package:hive/hive.dart';

class SetBudgetWidget extends StatefulWidget {
  const SetBudgetWidget({
    super.key,
    required this.salaryController,
    required this.expenseController,
    required this.labelController,
    required this.amountController,
  });

  final TextEditingController salaryController;
  final TextEditingController expenseController;
  final TextEditingController labelController;
  final TextEditingController amountController;

  @override
  SetBudgetWidgetState createState() => SetBudgetWidgetState();
}

class SetBudgetWidgetState extends State<SetBudgetWidget> {
  final _budgetGoalBox = Hive.box<BudgetGoal>(BudgetGoalService.boxName);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 20),
        child: Text(
          'Set your budget goal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 350,
        child: Form(
          key: _formKey, // Form key to track the form state
          child: Column(
            children: [
              buildTextField(
                context: context,
                controller: widget.salaryController,
                label: 'Income monthly',
                keyboardType: TextInputType.number,
                validator: (value) => validatePositiveNumber(value, 'Salary'),
              ),
              const SizedBox(height: 10),
              buildTextField(
                context: context,
                controller: widget.expenseController,
                label: 'Expense monthly',
                keyboardType: TextInputType.number,
                validator: (value) => validatePositiveNumber(value, 'Expense'),
              ),
              const SizedBox(height: 10),
              buildTextField(
                context: context,
                controller: widget.labelController,
                label: 'Target label',
                keyboardType: TextInputType.text,
                validator: (value) => validateNotEmpty(value, 'Label'),
              ),
              const SizedBox(height: 10),
              buildTextField(
                context: context,
                controller: widget.amountController,
                label: 'Target amount',
                keyboardType: TextInputType.number,
                validator: (value) => validatePositiveNumber(value, 'Amount'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              // Save the new budgetGoal
              BudgetGoal newBudgetGoal = BudgetGoal(
                salaryMonthly: int.parse(widget.salaryController.text),
                expenseMonthly: int.parse(widget.expenseController.text),
                label: widget.labelController.text,
                amount: int.parse(widget.amountController.text),
              );

              // Put in the box (Database)
              _budgetGoalBox.add(newBudgetGoal);
              showSuccessMessage(context, "Budget goal set successfully");

              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const BudgetGoalList()),
              );
            }
          },
          child: Text(
            'Confirm',
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
        ),
      ],
    );
  }

  Widget buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        focusColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).focusColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).focusColor),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      style: TextStyle(color: Theme.of(context).disabledColor),
      validator: validator,
    );
  }

  String? validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return '$fieldName must be a positive number';
    }
    return null;
  }

  String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }
}
