import 'package:flutter/material.dart';
import 'package:gestia/main.dart';
import 'package:gestia/model/transaction.dart';
// import 'package:gestia/model/transaction_history.dart';
// import 'package:gestia/service/transaction_history_service.dart';
import 'package:gestia/service/transaction_service.dart';
import 'package:gestia/utils/format_data.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class ListTransactionWidget extends StatefulWidget {
  const ListTransactionWidget({
    super.key,
    required this.isPreview,
  });

  final bool isPreview;

  @override
  State<ListTransactionWidget> createState() => _ListTransactionWidgetState();
}

class _ListTransactionWidgetState extends State<ListTransactionWidget> {
  bool _isAscending = true; // Track sorting order (ASC or DESC)

  Future<bool?> _confirmDismiss(BuildContext context, Transaction transaction) async {
    // Check if the balance will be negative
    int currentBalance = await SharedPreferencesUtil.retrieveBalance() ?? 0;
    bool canBeDeleted = true;
    String confirmationText = 'Are you sure you want to delete this transaction?';
    if (transaction.category == "income" && transaction.amount > currentBalance) {
      canBeDeleted = false;
      confirmationText = 'This transaction can\'t be deleted';
    }

    return await showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: Text(confirmationText),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            Visibility(
              visible: canBeDeleted,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(canBeDeleted),
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateTransactionHistory(int index, Transaction transaction) async {
    // final transactionHistoryService = TransactionHistoryService();
    // final transactionHistoryBox = Hive.box<TransactionHistory>(TransactionHistoryService.boxName);

    // final existingHistoryKey = transactionHistoryBox.keys.firstWhere(
    //   (key) {
    //     final entry = transactionHistoryBox.get(key);
    //     return entry != null &&
    //            entry.year == transaction.date.year &&
    //            entry.month == DateFormat.MMMM().format(transaction.date);
    //   },
    //   orElse: () => null,
    // );

    // if (existingHistoryKey != null) {
    //   final existingHistory = transactionHistoryBox.get(existingHistoryKey);

    //   if (existingHistory != null) {
    //     if (transaction.category == "expense") {
    //       existingHistory.expense -= transaction.amount;
    //     } else {
    //       existingHistory.income -= transaction.amount;
    //     }

    //     // if history is empty then delete, else update
    //     if (existingHistory.expense == 0 && existingHistory.income == 0) {
    //       transactionHistoryService.deleteTransactionHistory(index);
    //     } else {
    //       transactionHistoryService.updateTransactionHistory(index, existingHistory);
    //     }
    //   }
    // }

    // update current balance
    int currentBalance = await SharedPreferencesUtil.retrieveBalance() ?? 0;
    int updatedBalance = transaction.category == "expense" ? currentBalance + transaction.amount : currentBalance - transaction.amount;
    await SharedPreferencesUtil.storeBalance(updatedBalance);
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

  late Box<Transaction> transactionBox;

  @override
  void initState() {
    super.initState();
    transactionBox = Hive.box<Transaction>(TransactionService.boxName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sorting toggle button
        Visibility(
          visible: !widget.isPreview,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                child: Text(
                  'Sort by',
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                    onPressed: () {
                      setState(() {
                        _isAscending = !_isAscending; // Toggle sorting order
                      });
                    },
                  ),
                ],
              )
              
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
                    style: TextStyle(color: Theme.of(context).disabledColor),
                  ),
                );
              }
              List<Transaction> transactionList = transactions.values.toList();

              // Sort transactions based on _isAscending
              transactionList.sort((a, b) => _isAscending
                  ? a.date.compareTo(b.date) // Ascending order
                  : b.date.compareTo(a.date)); // Descending order

              return ListView.builder(
                physics: widget.isPreview ? const NeverScrollableScrollPhysics() : null,
                itemCount: transactionList.length,
                itemBuilder: (context, index) {
                  Transaction transaction = transactionList[index];
                  if (widget.isPreview && index > 2) {
                    return const SizedBox.shrink();
                  }
                  return Dismissible(
                    key: Key(transaction.key),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: transaction.color.withOpacity(.4),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) => _confirmDismiss(context, transaction),
                    onDismissed: (direction) {
                      transactions.deleteAt(index);
                      _updateTransactionHistory(index, transaction);
                      _reloadApp(context);
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: transaction.color.withOpacity(.7),
                        child: Icon(
                          transaction.iconData,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      title: Text(
                        transaction.title,
                        style: TextStyle(
                          color: Theme.of(context).disabledColor.withOpacity(.7),
                          fontSize: 20,
                        ),
                      ),
                      trailing: Text(
                        "${(transaction.category == "expense") ? '-' : ''} ${FormatData.formatNumber(transaction.amount)} Ar",
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
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
          ),
        ),
      ],
    );
  }
}