import 'package:flutter/material.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/service/transaction_service.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:gestia/view/components/header_widget.dart';
import 'package:gestia/view/components/list_transaction_widget.dart';
import 'package:gestia/view/components/total_transactions.dart';
import 'package:gestia/view/pages/home.dart';
import 'package:hive_flutter/adapters.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
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

    int totalExpense = transactions
        .where((transaction) => transaction.category == "expense")
        .fold(0, (sum, transaction) => sum + transaction.amount);

    int totalIncome = transactions
        .where((transaction) => transaction.category == "income")
        .fold(0, (sum, transaction) => sum + transaction.amount);

    // Update balance
    _updateBalance(totalIncome - totalExpense);

    return Scaffold(
      body: SafeArea(
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
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const ListTransactionWidget(isPreview: false),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: TotalTransactions(totalExpense: totalExpense, totalIncome: totalIncome),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: SizedBox(
        height: 80,
        width: MediaQuery.sizeOf(context).width,
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.home_filled,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
