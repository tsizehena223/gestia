import 'package:flutter/material.dart';
import 'package:gestia/model/budget_goal.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/model/transaction_history.dart';
import 'package:gestia/service/budget_goal_service.dart';
import 'package:gestia/service/transaction_history_service.dart';
import 'package:gestia/view/components/prediction_card_widget.dart';
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
  late Transaction transaction;
  
  int totalIncome = 0;
  int totalExpense = 0;

  @override
  void initState() {
    super.initState();
    budgetGoalBox = Hive.box<BudgetGoal>(BudgetGoalService.boxName);
    transactionHistoryBox = Hive.box<TransactionHistory>(TransactionHistoryService.boxName);

    // Get all transactions and store in the list
    transactionsHistory = transactionHistoryBox.values.toList();

    // Calculate total income and total expense from transactions
    for (var transaction in transactionsHistory) {
      totalIncome += transaction.income;
      totalExpense += transaction.expense;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const PredictionCardWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0),
    );
  }
}
