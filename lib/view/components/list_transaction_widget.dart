import 'package:flutter/material.dart';
import 'package:gestia/main.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/service/transaction_service.dart';
import 'package:gestia/utils/format_data.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class ListTransactionWidget extends StatefulWidget {
  const ListTransactionWidget({
    super.key,
  });

  @override
  State<ListTransactionWidget> createState() => _ListTransactionWidgetState();
}

class _ListTransactionWidgetState extends State<ListTransactionWidget> {
  Future<bool?> _confirmDismiss(BuildContext context, Transaction transaction) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Are you sure you want to delete this transaction?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }

  void _reloadApp(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyApp(),
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark.withOpacity(.7),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              "$title removed successfully",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  late Box<Transaction> transactionBox;

  @override
  void initState() {
    super.initState();
    transactionBox = Hive.box<Transaction>(TransactionService.boxName);
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: transactionBox.listenable(),
      builder: (context, transactions, _) {
        if (transactions.isEmpty) {
          return const Center(
            child: Text('No transactions added yet', style: TextStyle(color: Colors.white)),
          );
        }
        List<Transaction> transactionList = transactions.values.toList();
        return ListView.builder(
          itemCount: transactionList.length,
          itemBuilder: (context, index) {
            Transaction transaction = transactionList[index];
            return Dismissible(
              key: Key(transaction.key),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) => _confirmDismiss(context, transaction),
              onDismissed: (direction) {
                transactions.deleteAt(index);
                setState(() {
                  transactionList.removeAt(index);
                });
                _reloadApp(context);
                _showSuccessMessage(context, "Removed successfully");
              },
              child: ListTile(
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
              ),
            );
          },
        );
      },
    );
  }
}