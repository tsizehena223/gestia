import 'package:flutter/material.dart';
import 'package:gestia/model/budget_goal.dart';
import 'package:gestia/service/budget_goal_service.dart';
import 'package:hive_flutter/adapters.dart';

class ListBudgetWidget extends StatefulWidget {
  const ListBudgetWidget({
    super.key,
  });

  @override
  State<ListBudgetWidget> createState() => _ListBudgetWidgetState();
}

class _ListBudgetWidgetState extends State<ListBudgetWidget> {
  late Box<BudgetGoal> budgetGoalBox;

  @override
  void initState() {
    super.initState();
    budgetGoalBox = Hive.box<BudgetGoal>(BudgetGoalService.boxName);
  }

  double? _numberOfMonths;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: budgetGoalBox.listenable(),
      builder: (context, budgetGoals, _) {
        if (budgetGoals.isEmpty) {
          return Center(
            child: Text(
              'No budget goal added yet',
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          );
        }

        BudgetGoal? firstBudgetGoal = budgetGoals.values.isNotEmpty ? budgetGoals.values.first : null;

        if (firstBudgetGoal == null) {
          return Center(
            child: Text(
              'No budget goal available',
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          );
        }

        double getNumberOfMonths(int goalAmount, int income, int expense) {
          return (goalAmount / (income - expense));
        }

        // _numberOfMonths = getNumberOfMonths(firstBudgetGoal.amount, firstbudgetgoal.salarymonthly, firstbudgetgoal.expensemonthly);
        _numberOfMonths = 3.5;

        return Center(
          child: Text(
            "You will get your ${firstBudgetGoal.label} in only ${_numberOfMonths?.round()} months",
            style: const TextStyle(
              color: Colors.green,
            ),
          ),
        );
      }
    );
  }
}