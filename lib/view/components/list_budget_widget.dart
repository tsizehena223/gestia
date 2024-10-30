import 'package:flutter/material.dart';
import 'package:gestia/model/budget_goal.dart';
import 'package:gestia/model/transaction_history.dart';
import 'package:gestia/service/budget_goal_service.dart';
import 'package:gestia/service/transaction_history_service.dart';
import 'package:gestia/view/components/prediction_card_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  List<double> monthlyNetIncomes = [];
  List<double> predictions = []; 

  @override
  void initState() {
    super.initState();
    budgetGoalBox = Hive.box<BudgetGoal>(BudgetGoalService.boxName);
    transactionHistoryBox = Hive.box<TransactionHistory>(TransactionHistoryService.boxName);

    transactionsHistory = transactionHistoryBox.values.toList();
    calculateMonthlyNetIncomes();
    calculateMonthsToGoal();
    _getFutureTransactions();
    print(monthlyNetIncomes);
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
      monthlyNetIncomes.add(netIncome.toDouble());
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

  void _getFutureTransactions() async {
    try {
      List<double> history = monthlyNetIncomes;
      List<double> fetchedPredictions = await _fetchPredictions(history, 12);

      setState(() {
        predictions = fetchedPredictions;
      });

      print("Predicted Future Transactions: $predictions");
    } catch (error) {
      print("Error fetching predictions: $error");
    }
  }

  Future<List<double>> _fetchPredictions(List<double> transactionHistory, int periods) async {
    final url = Uri.parse('http://127.0.0.1:5000/predict');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'transactions': transactionHistory,
        'periods': periods,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<double>.from(data['predictions']);
    } else {
      throw Exception('Failed to fetch predictions: ${response.body}');
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
                  child: PredictionCardWidget(
                    message: message,
                    predictions: predictions,
                  ),
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
