import 'package:flutter/cupertino.dart';
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No transaction added yet',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColorDark.withOpacity(.7),
                        child: Icon(CupertinoIcons.question, color: Theme.of(context).primaryColor.withOpacity(.8),)
                      ),
                    ],
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
                        ? Theme.of(context).primaryColorDark.withOpacity(.7)
                        : Theme.of(context).disabledColor.withOpacity(.2),
                    elevation: 8,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      height: 170,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 30, 
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0),
                                child: Icon(Icons.money, color: Theme.of(context).primaryColor,),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isCurrentMonth ? "Current Month" : "${transaction.month} ${transaction.year}",
                            style: TextStyle(
                              fontSize: 20,
                              color: isCurrentMonth
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      ? Theme.of(context).disabledColor
                                      : Theme.of(context).primaryColor.withOpacity(.7),
                                ),
                              ),
                            ],
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
