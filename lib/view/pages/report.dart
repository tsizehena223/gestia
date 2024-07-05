import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/view/components/header_report.dart';
import 'package:hive/hive.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<StatefulWidget> createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> {

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  double _sumAmount(int month, int year, String category) {
    var box = Hive.box<Transaction>('transactions');
    List<Transaction> transactions = box.values.toList();

    List<Transaction> filteredTransactions = transactions.where((transaction) {
      return transaction.date.month == month && transaction.date.year == year;
    }).toList();

    int total = filteredTransactions
      .where((transaction) => transaction.category == category)
      .fold(0, (sum, item) => sum + item.amount);

    return total.toDouble() / 10000;
  }

  @override
  void initState() {
    super.initState();

    showingBarGroups = [];

    for (int i = 0; i < 12; i++) {
      double income = _sumAmount(i + 1, 2024, "income");
      double expense = _sumAmount(i + 1, 2024, "expense");
      showingBarGroups.add(makeGroupData(i, income, expense));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderReport(),
        Container(
          height: 350,
          margin: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
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
                          showTitles: true,
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
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ],
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
      barsSpace: 2,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.green,
          width: 4,
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.red,
          width: 4,
        ),
      ],
    );
  }
}