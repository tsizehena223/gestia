import 'package:flutter/material.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/service/transaction_service.dart';
import 'package:gestia/utils/format_data.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:gestia/view/components/header.dart';
import 'package:gestia/view/components/list_transaction_widget.dart';
import 'package:gestia/view/pages/add_transaction.dart';
import 'package:gestia/view/pages/report.dart';
import 'package:gestia/view/pages/transaction_list.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = "";
  int userBalance = 0;

  void _retrieveUser() async {
    await SharedPreferencesUtil.retrieveUserName().then((value) {
      userName = value ?? "";
    });
    await SharedPreferencesUtil.retrieveBalance().then((value) {
      userBalance = value ?? 0;
    });
  }

  bool _isShow = false;

  void _toggleShow() {
    setState(() {
      _isShow = !_isShow;
    });
  }

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _retrieveUser();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(now);
    String balanceFormated = FormatData.formatNumber(userBalance);

    final List<Widget> pages = [
      home(context, balanceFormated, formattedDate),
      const ReportPage(),
      const TransactionList(),
      const AddTransaction(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentPageIndex,
        children: pages,
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        width: MediaQuery.sizeOf(context).width,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color:Theme.of(context).disabledColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: IconButton(
                  icon: Icon(
                    (index == 0) ? Icons.home_filled : (index == 1) ? Icons.leaderboard : (index == 2) ? Icons.compare_arrows : Icons.add,
                    color: (index == _currentPageIndex) ? Theme.of(context).primaryColorDark : Theme.of(context).focusColor,
                  ),
                  onPressed: () => setState(() => _currentPageIndex = index),
                ),
              )
            )
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  SafeArea home(BuildContext context, String balanceFormated, String formattedDate) {
    final transactionBox = Hive.box<Transaction>(TransactionService.boxName);
    List<Transaction> recentTransactions = transactionBox.values.toList();
    FormatData.sortWithDate(recentTransactions);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Header(),
            // Begin
            Container(
              margin: const EdgeInsets.only(top: 10, right: 20, left: 20,),
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      "Total Balance",
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Row(
                      children: [
                        const Text(
                          "Ar  ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          _isShow ? balanceFormated : "*** ***",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    ),
                    trailing: IconButton(icon: (_isShow) ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off), onPressed: _toggleShow,)
                  ),
                  ListTile(
                    title: Text(formattedDate, style: TextStyle(color: Theme.of(context).primaryColor),),
                  ),
                ],
              ),
            ),
            // End
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                        _currentPageIndex = 3;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 54, 54, 54),
                            child: Icon(Icons.remove, color: Colors.white,),
                          ),
                          title: Text("Expense", style: TextStyle(color: Colors.white,),),
                        ),
                      ),
                    )
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                        _currentPageIndex = 3;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).disabledColor.withOpacity(0.5),
                            child: const Icon(Icons.add, color: Colors.white,),
                          ),
                          title: const Text("Income", style: TextStyle(color: Colors.white,),),
                        ),
                      ),
                    )
                  )
                ],
              ),
            ),
            // End
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 320,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(color: Theme.of(context).primaryColorLight),
                borderRadius: BorderRadius.circular(35),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 30),
                        child: const Text(
                          "Recents",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, right: 30),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentPageIndex = 2;
                            });
                          },
                          child: Text(
                            "View all",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListTransactionWidget(
                      transactionBox: transactionBox,
                      transactions: recentTransactions,
                      lengthTransaction: (recentTransactions.length < 3) ? recentTransactions.length : 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
