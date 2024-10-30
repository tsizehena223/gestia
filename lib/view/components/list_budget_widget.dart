import 'package:flutter/material.dart';
import 'package:gestia/model/budget_goal.dart';
import 'package:gestia/model/transaction_history.dart';
import 'package:gestia/service/budget_goal_service.dart';
import 'package:gestia/service/transaction_history_service.dart';
import 'package:gestia/view/components/prediction_card_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ListBudgetWidget extends StatefulWidget {
  const ListBudgetWidget({super.key});

  @override
  State<ListBudgetWidget> createState() => _ListBudgetWidgetState();
}

class _ListBudgetWidgetState extends State<ListBudgetWidget> {
  late Box<BudgetGoal> budgetGoalBox;
  late Box<TransactionHistory> transactionHistoryBox;
  late List<TransactionHistory> transactionsHistory;

  int totalIncome = 0;
  int totalExpense = 0;
  int monthsToGoal = 0;
  String message = "";
  List<int> monthlyNetIncomes = []; 

  @override
  void initState() {
    super.initState();
    budgetGoalBox = Hive.box<BudgetGoal>(BudgetGoalService.boxName);
    transactionHistoryBox = Hive.box<TransactionHistory>(TransactionHistoryService.boxName);

    transactionsHistory = transactionHistoryBox.values.toList();
    calculateMonthlyNetIncomes();
    calculateMonthsToGoal();
  }

  void calculateMonthlyNetIncomes() {
    Map<int, int> monthlyIncomeMap = {};
    Map<int, int> monthlyExpenseMap = {};

    for (var transaction in transactionsHistory) {
      int month = DateFormat('MMMM').parse(transaction.month).month;
      monthlyIncomeMap.update(month, (value) => value + transaction.income, ifAbsent: () => transaction.income);
      monthlyExpenseMap.update(month, (value) => value + transaction.expense, ifAbsent: () => transaction.expense);
    }

    monthlyIncomeMap.forEach((month, income) {
      int expenses = monthlyExpenseMap[month] ?? 0;
      int netIncome = income - expenses;
      monthlyNetIncomes.add(netIncome);
    });
  }

  void calculateMonthsToGoal() {
    if (budgetGoalBox.isNotEmpty) {
      BudgetGoal goal = budgetGoalBox.getAt(0)!;
      int goalAmount = goal.amount;

      double averageNetIncome = monthlyNetIncomes.isNotEmpty
          ? monthlyNetIncomes.reduce((a, b) => a + b) / monthlyNetIncomes.length
          : 0;

      if (averageNetIncome > 0) {
        monthsToGoal = (goalAmount / averageNetIncome).ceil();
        message = "You will reach your goal in $monthsToGoal months";
      } else {
        monthsToGoal = 0;
        message = "No transaction yet";
      }
    } else {
      monthsToGoal = 0;
      message = "No goal set";
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
                  child: PredictionCardWidget(message: message),
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
