import 'package:flutter/material.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/service/transaction_service.dart';
import 'package:gestia/utils/format_data.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:gestia/view/components/list_transaction_widget.dart';
import 'package:hive_flutter/adapters.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  Future<int> _getCurrentBalance() async {
    int currentBalance = await SharedPreferencesUtil.retrieveBalance() ?? 0;
    return currentBalance;
  }

  Future<void> _updateBalance(int amount) async {
    await SharedPreferencesUtil.storeBalance(amount);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentBalance();
  }

  @override
  Widget build(BuildContext context) {
    final transactionBox = Hive.box<Transaction>(TransactionService.boxName);
    List<Transaction> transactions = transactionBox.values.toList();
    FormatData.sortWithDate(transactions);

    int totalExpense = transactions
      .where((transaction) => transaction.category == "expense")
      .fold(0, (sum, transaction) => sum + transaction.amount);

    int totalIncome = transactions
      .where((transaction) => transaction.category == "income")
      .fold(0, (sum, transaction) => sum + transaction.amount);

    // Update balance
    _updateBalance(totalIncome - totalExpense);

    return SafeArea(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).primaryColorLight,
            ),
            child: Column(
              children: [
                ListTile(
                  minVerticalPadding: 20,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorDark,
                    child: Icon(Icons.compare_arrows, color: Theme.of(context).primaryColorLight),
                  ),
                  title: const Text(
                    "Transactions",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: Theme.of(context).disabledColor,
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
                                  const Text("Ar  ", style: TextStyle(color: Colors.white),),
                                  Text(
                                    FormatData.formatNumber(totalExpense),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ]
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          color: Theme.of(context).primaryColorDark,
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
                                  const Text("Ar  ", style: TextStyle(color: Colors.white),),
                                  Text(
                                    FormatData.formatNumber(totalIncome),
                                    style: const TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ]
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListTransactionWidget(transactionBox: transactionBox, transactions: transactions, lengthTransaction: transactions.length,),
            ),
          ),
        ],
      ),
    );
  }
}