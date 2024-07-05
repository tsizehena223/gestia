import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<StatefulWidget> createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> {

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 19, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);
    final barGroup8 = makeGroupData(7, 10, 1.5);
    final barGroup9 = makeGroupData(8, 10, 1.5);
    final barGroup10 = makeGroupData(9, 10, 1.5);
    final barGroup11 = makeGroupData(10, 10, 1.5);
    final barGroup12 = makeGroupData(11, 10, 1.5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
      barGroup8,
      barGroup9,
      barGroup10,
      barGroup11,
      barGroup12,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            "Report transactions",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 38,
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: 20,
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
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '10K';
    } else if (value == 100) {
      text = '100K';
    } else {
      return Container();
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
    final titles = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
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