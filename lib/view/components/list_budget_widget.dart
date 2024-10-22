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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: budgetGoalBox.listenable(),
      builder: (context, budgetGoals, _) {
        if (budgetGoals.isEmpty) {
          return Center(
            child: Text('No budget goal added yet', style: TextStyle(color: Theme.of(context).disabledColor)),
          );
        }
        List<BudgetGoal> budgetGoalList = budgetGoals.values.toList();
        return ListView.builder(
          itemCount: budgetGoalList.length,
          itemBuilder: (context, index) {
            BudgetGoal budgetGoal = budgetGoalList[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(.7),
                child: Icon(Icons.money, color: Theme.of(context).primaryColorLight,),
              ),
              title: Text(
                budgetGoal.label,
                style: TextStyle(
                  color: Theme.of(context).disabledColor.withOpacity(.7),
                  fontSize: 20,
                ),
              ),
              trailing: Text(
                budgetGoal.amount.toString(),
                style: TextStyle(
                  color: Theme.of(context).disabledColor,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                budgetGoal.salaryMonthly.toString(),
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontSize: 15,
                ),
              ),
            );
          },

        );
      },
    );
  }
}