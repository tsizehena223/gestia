import 'package:flutter/material.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/service/transaction_service.dart';
import 'package:gestia/utils/format_data.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:gestia/view/components/header_widget.dart';
import 'package:gestia/view/components/list_transaction_widget.dart';
import 'package:gestia/view/components/total_transactions.dart';
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
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          children: [
            const HeaderWidget(
              title: 'Transactions',
              subtitle: 'List of your transactions',
              icon: Icons.compare_arrows,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColorLight,
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                    child: TotalTransactions(totalExpense: totalExpense, totalIncome: totalIncome),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListTransactionWidget(transactionBox: transactionBox, transactions: transactions, lengthTransaction: transactions.length,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}