import 'package:flutter/material.dart';
import 'package:gestia/model/budget_goal.dart';
import 'package:gestia/model/transaction_history.dart';
import 'package:gestia/service/budget_goal_service.dart';
import 'package:gestia/service/transaction_history_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ListBudgetWidget extends StatefulWidget {
  const ListBudgetWidget({super.key});

  @override
  State<ListBudgetWidget> createState() => _ListBudgetWidgetState();
}

class _ListBudgetWidgetState extends State<ListBudgetWidget> {
  late Box<BudgetGoal> budgetGoalBox;
  late Box<TransactionHistory> transactionHistoryBox;
  late List<TransactionHistory> transactionsHistory;

  @override
  void initState() {
    super.initState();
    budgetGoalBox = Hive.box<BudgetGoal>(BudgetGoalService.boxName);
    transactionHistoryBox = Hive.box<TransactionHistory>(TransactionHistoryService.boxName);

    // Get all transactions and store in the list
    transactionsHistory = transactionHistoryBox.values.toList();
  }

  double? _numberOfMonths;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
      ),
      body: Column(
        children: [
          ValueListenableBuilder(
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

              // Calculate months to reach the budget goal
              _numberOfMonths = getNumberOfMonths(firstBudgetGoal.amount, 5000000, 300000);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "You will get your ${firstBudgetGoal.label} in ${_numberOfMonths?.round()} months",
                  style: const TextStyle(color: Colors.green),
                ),
              );
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactionsHistory.length,
              itemBuilder: (context, index) {
                final transaction = transactionsHistory[index];
                return ListTile(
                  leading: Text("Income : ${transaction.income}"),
                  title: Text("Transaction ${index + 1}"),
                  subtitle: Text("${transaction.year} : ${transaction.month}"), 
                  trailing: Text("Expense : ${transaction.expense}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
