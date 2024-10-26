import 'package:flutter/material.dart';
import 'package:gestia/model/transaction_history.dart';
import 'package:gestia/service/transaction_history_service.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class ListTransactionHistoryWidget extends StatefulWidget {
  const ListTransactionHistoryWidget({super.key});

  @override
  State<ListTransactionHistoryWidget> createState() =>
      _ListTransactionHistoryWidgetState();
}

class _ListTransactionHistoryWidgetState
    extends State<ListTransactionHistoryWidget> {
  late Box<TransactionHistory> transactionBox;
  bool _isAscending = true; // Track sorting order

  @override
  void initState() {
    super.initState();
    transactionBox = Hive.box<TransactionHistory>(TransactionHistoryService.boxName);
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final currentMonth = DateFormat.MMMM().format(DateTime.now());

    return Column(
      children: [
        // Sort Order Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sort by',
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                ),
              ),
              IconButton(
                icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                onPressed: _toggleSortOrder,
                tooltip: _isAscending ? 'Sort Descending' : 'Sort Ascending',
              ),
            ],
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: transactionBox.listenable(),
            builder: (context, transactions, _) {
              if (transactions.isEmpty) {
                return Center(
                  child: Text(
                    'No transaction added yet',
                    style: TextStyle(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                );
              }

              // Convert transactions to a list and sort
              List<TransactionHistory> transactionList = transactions.values.toList();
              transactionList.sort((a, b) {
                int yearComparison = a.year.compareTo(b.year);
                return _isAscending
                    ? yearComparison != 0
                        ? yearComparison
                        : a.month.compareTo(b.month)
                    : yearComparison != 0
                        ? -yearComparison
                        : b.month.compareTo(a.month);
              });

              return ListView.builder(
                itemCount: transactionList.length,
                itemBuilder: (context, index) {
                  final transaction = transactionList[index];
                  final isCurrentMonth = transaction.year == currentYear && transaction.month == currentMonth;

                  return Card(
                    margin: const EdgeInsets.all(8),
                    color: isCurrentMonth
                        ? Theme.of(context).primaryColorDark
                        : Theme.of(context).primaryColor,
                    child: ListTile(
                      title: Text(
                        isCurrentMonth
                            ? "Current month"
                            : "${transaction.year} : ${transaction.month}",
                        style: TextStyle(
                          color: isCurrentMonth
                              ? Theme.of(context).primaryColorLight
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Income: ${transaction.income} Ar',
                            style: TextStyle(
                              color: isCurrentMonth
                                  ? Theme.of(context).primaryColor.withOpacity(.9)
                                  : Theme.of(context).primaryColorDark,
                            ),
                          ),
                          Text(
                            'Expense: ${transaction.expense} Ar',
                            style: TextStyle(
                              color: isCurrentMonth
                                  ? Theme.of(context).disabledColor.withOpacity(.6)
                                  : Theme.of(context).focusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

