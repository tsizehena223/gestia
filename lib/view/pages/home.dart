import 'package:flutter/material.dart';
import 'package:gestia/utils/format_data.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:gestia/view/components/header.dart';
import 'package:gestia/view/components/list_transaction_widget.dart';
import 'package:gestia/view/pages/add_transaction.dart';
import 'package:gestia/view/pages/report.dart';
import 'package:gestia/view/pages/transaction_history_list.dart';
import 'package:gestia/view/pages/transaction_list.dart';
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
  String? _defaultCategory;

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

    if (_currentPageIndex != 3) {
      _defaultCategory = null;
    }

    final List<Widget> pages = [
      home(context, balanceFormated, formattedDate),
      const ReportPage(),
      const TransactionHistoryList(),
      AddTransaction(
        defaultCategory: _defaultCategory,
      ),
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
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
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
                            borderRadius: BorderRadius.circular(20)),
                        child: IconButton(
                          icon: Icon(
                            (index == 0)
                                ? Icons.home_filled
                                : (index == 1)
                                    ? Icons.leaderboard
                                    : (index == 2)
                                        ? Icons.compare_arrows
                                        : Icons.add,
                            color: (index == _currentPageIndex)
                                ? Theme.of(context).primaryColorDark
                                : Theme.of(context).focusColor,
                          ),
                          onPressed: () =>
                              setState(() => _currentPageIndex = index),
                        ),
                      ))),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  SafeArea home(
      BuildContext context, String balanceFormated, String formattedDate) {
    var children = [
      const Header(),
      // Begin
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ListTile(
              title: Center(
                child: Text(
                  formattedDate,
                  style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Center(
                child: Text(
                  'Your balance',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).focusColor,
                  ),
                ),
              ),
            ),
            ListTile(
                title: Row(children: [
                  Text(
                    _isShow ? balanceFormated : "*** ***",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "  Ariary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ]),
                trailing: IconButton(
                  icon: (_isShow)
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: _toggleShow,
                )),
          ],
        ),
      ),
      // End
      Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentPageIndex = 3;
                  _defaultCategory = "expense";
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withOpacity(.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Theme.of(context).focusColor, width: .5),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(.2),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "Expense",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              ),
            )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentPageIndex = 3;
                  _defaultCategory = 'income';
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).disabledColor.withOpacity(0.3),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    "Income",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
      // End
      Container(
        width: MediaQuery.sizeOf(context).width,
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 30),
                  child: Text(
                    "Recents",
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, right: 30),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // _currentPageIndex = 2;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const TransactionListPage()),
                        );
                      });
                    },
                    child: Text(
                      "View all",
                      style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: ListTransactionWidget(
                isPreview: true,
              ),
            ),
          ],
        ),
      ),
    ];
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: children,
        ),
      ),
    );
  }
}
