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

  @override
  void initState() {
    super.initState();
    transactionBox = Hive.box<TransactionHistory>(TransactionHistoryService.boxName);
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final currentMonth = DateFormat.MMMM().format(DateTime.now());

    return Column(
      children: [
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

              List<TransactionHistory> transactionList = transactions.values.toList();

              return ListView.builder(
                itemCount: transactionList.length,
                itemBuilder: (context, index) {
                  final transaction = transactionList[index];
                  final isCurrentMonth = transaction.year == currentYear && transaction.month == currentMonth;

                  return Card(
                    margin: const EdgeInsets.all(8),
                    color: isCurrentMonth
                        ? Theme.of(context).primaryColorDark.withOpacity(.8)
                        : Theme.of(context).disabledColor.withOpacity(.1),
                    child: ListTile(
                      title: Center(
                        child: Text(
                          isCurrentMonth
                              ? "Current month"
                              : "${transaction.year} : ${transaction.month}",
                          style: TextStyle(
                            color: isCurrentMonth
                                ? Theme.of(context).primaryColorLight
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Expense: ${transaction.expense} Ar',
                            style: TextStyle(
                              color: isCurrentMonth
                                  ? Theme.of(context).disabledColor.withOpacity(.6)
                                  : Theme.of(context).focusColor,
                            ),
                          ),
                          Text(
                            'Income: ${transaction.income} Ar',
                            style: TextStyle(
                              color: isCurrentMonth
                                  ? Theme.of(context).primaryColor.withOpacity(.9)
                                  : Theme.of(context).primaryColorDark,
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
