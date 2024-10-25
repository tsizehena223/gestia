import 'package:flutter/material.dart';
import 'package:gestia/model/transaction_history.dart';
import 'package:gestia/service/transaction_history_service.dart';
import 'package:hive_flutter/adapters.dart';

class ListTransactionHistoryWidget extends StatefulWidget {
  const ListTransactionHistoryWidget({
    super.key,
  });

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
    transactionBox =
        Hive.box<TransactionHistory>(TransactionHistoryService.boxName);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: transactionBox.listenable(),
      builder: (context, transactions, _) {
        if (transactions.isEmpty) {
          return Center(
            child: Text('No transaction added yet',
                style: TextStyle(color: Theme.of(context).disabledColor)),
          );
        }
        List<TransactionHistory> transactionList = transactions.values.toList();
        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactionList[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(transaction.month),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Expense: \$${transaction.expense}'),
                    Text('Income: \$${transaction.income}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
