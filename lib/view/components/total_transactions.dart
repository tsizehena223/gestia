import 'package:flutter/material.dart';
import 'package:gestia/utils/format_data.dart';

class TotalTransactions extends StatelessWidget {
  const TotalTransactions({
    super.key,
    required this.totalExpense,
    required this.totalIncome,
  });

  final int totalExpense;
  final int totalIncome;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Theme.of(context).disabledColor.withOpacity(.2),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  "Total Expense",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 15,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      FormatData.formatTotalNumber(totalExpense),
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 20,
                      ),
                    ),
                    Text("  Ar", style: TextStyle(color: Theme.of(context).primaryColorLight),),
                  ]
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            color: Theme.of(context).primaryColorDark.withOpacity(.8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  "Total Income",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 15,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      FormatData.formatTotalNumber(totalIncome),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const Text("  Ar", style: TextStyle(color: Colors.white),),
                  ]
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}