import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestia/model/budget_goal.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/service/budget_goal_service.dart';
import 'package:gestia/service/transaction_service.dart';
import 'package:gestia/utils/format_data.dart';
import 'package:gestia/view/components/header_widget.dart';
import 'package:gestia/view/components/set_budget_widget.dart';
import 'package:gestia/view/components/total_transactions.dart';
import 'package:gestia/view/pages/budget_goal_list.dart';
import 'package:hive/hive.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<StatefulWidget> createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> {
  List<BarChartGroupData> showingBarGroups = [];

  void _reloadPage() {
    setState(() {
    });
  }

  double _sumAmount(int month, int year, String category) {
    var box = Hive.box<Transaction>('transactions');
    List<Transaction> transactions = box.values.toList();

    List<Transaction> filteredTransactions = transactions.where((transaction) {
      return transaction.date.month == month && transaction.date.year == year;
    }).toList();

    int total = filteredTransactions
      .where((transaction) => transaction.category == category)
      .fold(0, (sum, item) => sum + item.amount);

    if (total >= 1000000) return 100;

    return total.toDouble() / 10000;
  }

  int selectedYear = DateTime.now().year;
  List<int> years = List<int>.generate(100, (int index) => (2000 + index));

  void changeGraph(int year) {
    showingBarGroups.clear();
    for (int i = 0; i < 12; i++) {
      double income = _sumAmount(i + 1, year, "income");
      double expense = _sumAmount(i + 1, year, "expense");
      showingBarGroups.add(makeGroupData(i, income, expense));
      selectedYear = year;
      setState(() {});
    }
  }

  late Box<BudgetGoal> budgetGoalBox;

  @override
  void initState() {
    super.initState();
    changeGraph(selectedYear);
    budgetGoalBox = Hive.box<BudgetGoal>(BudgetGoalService.boxName);
  }

  Future<Object?> _showSetBudget(BuildContext context) async {
    TextEditingController labelController= TextEditingController();
    TextEditingController amountController= TextEditingController();

    // Check if there is already an budget goal
    if (budgetGoalBox.isNotEmpty) {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BudgetGoalList()),
      );
    }

    return await showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return SetBudgetWidget(
          labelController: labelController,
          amountController: amountController,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
      final transactionBox = Hive.box<Transaction>(TransactionService.boxName);
      List<Transaction> transactions = transactionBox.values.toList();
      FormatData.sortWithDate(transactions);

      int totalExpense = transactions
        .where((transaction) => transaction.category == "expense")
        .fold(0, (sum, transaction) => sum + transaction.amount);

      int totalIncome = transactions
        .where((transaction) => transaction.category == "income")
        .fold(0, (sum, transaction) => sum + transaction.amount);

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(
              title: 'Report',
              subtitle: 'Report of your transactions',
              icon: Icons.leaderboard,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                onTap: () => _showSetBudget(context),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.gps_fixed),
                  ),
                  title: Text(
                    "Budget",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  subtitle: Text(
                    "Set your budget goal with GestIA Bot",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            ),
            Container(
              height: 350,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColorLight,
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Analytics",
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      yearDropDown(),
                      IconButton(
                        onPressed: _reloadPage,
                        icon: Icon(
                          Icons.refresh,
                          color: Theme.of(context).focusColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        maxY: 101,
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitles,
                              reservedSize: 42,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              reservedSize: 28,
                              interval: 1,
                              getTitlesWidget: leftTitles,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: showingBarGroups,
                        gridData: const FlGridData(show: true),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TotalTransactions(totalExpense: totalExpense, totalIncome: totalIncome),
            )
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    String text = "";
    if (value == 0) {
      text = '1K';
    }

    for (int i = 10; i < 100; i += 10) {
      if (value == i) {
        text = "${value.toInt()}0K";
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).focusColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Ja', 'Fe', 'Ma', 'Ap', 'May', 'Jun', 'Jul', 'Au', 'Se', 'Oc', 'No', 'De'];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(
        titles[value.toInt()],
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 1,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.green.withOpacity(.7),
          width: 5,
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.red.withOpacity(.7),
          width: 5,
        ),
      ],
    );
  }

  Center yearDropDown() {
    return Center(
      child: DropdownButton<int>(
        focusColor: Theme.of(context).primaryColor,
        value: selectedYear,
        hint: const Text('Select Year'),
        items: years.map((int year) {
          return DropdownMenuItem<int>(
            value: year,
            child: Text(
              year.toString(),
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 15,
              ),
            ),
          );
        }).toList(),
        onChanged: (int? newValue) {
          changeGraph(newValue ?? DateTime.now().year);
        },
      ),
    );
  }
}