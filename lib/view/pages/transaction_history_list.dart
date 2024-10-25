import 'package:flutter/material.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:gestia/view/components/header_widget.dart';
import 'package:gestia/view/components/list_transaction_history_widget.dart';
import 'package:gestia/view/pages/home.dart';

class TransactionHistoryList extends StatefulWidget {
  const TransactionHistoryList({super.key});

  @override
  State<TransactionHistoryList> createState() => _TransactionHistoryListState();
}

class _TransactionHistoryListState extends State<TransactionHistoryList> {
  Future<int> _getCurrentBalance() async {
    int currentBalance = await SharedPreferencesUtil.retrieveBalance() ?? 0;
    return currentBalance;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              const HeaderWidget(
                title: 'Monthly transactions',
                subtitle: 'Follow your transactions\' story',
                icon: Icons.compare_arrows_rounded,
              ),
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const ListTransactionHistoryWidget(),
                ),
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
            children: List.generate(
              1,
              (index) => Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20)),
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
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
