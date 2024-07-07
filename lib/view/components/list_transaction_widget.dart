import 'package:flutter/material.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/utils/format_data.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class ListTransactionWidget extends StatelessWidget {
  const ListTransactionWidget({
    super.key,
    required this.transactionBox,
    required this.transactions,
    required this.lengthTransaction,
  });

  final Box<Transaction> transactionBox;
  final List<Transaction> transactions;
  final int lengthTransaction;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: transactionBox.listenable(),
      builder: (context, _, __) {
        if (transactions.isEmpty) {
          return const Center(
            child: Text('No transactions added yet', style: TextStyle(color: Colors.white)),
          );
        }
        return ListView.builder(
          itemCount: lengthTransaction,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: transaction.color.withOpacity(.7),
                child: Icon(transaction.iconData, color: Theme.of(context).primaryColor,),
              ),
              title: Text(
                transaction.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              trailing: Text(
                "${(transaction.category == "expense") ? '-' : ''} ${FormatData.formatNumber(transaction.amount)} Ar",
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                DateFormat('yyyy-MM-dd').format(transaction.date),
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontSize: 15,
                ),
              ),
            );
          },
        );
      },
    );
  }
}