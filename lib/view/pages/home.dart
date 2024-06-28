import 'package:flutter/material.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
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

  final List<Map<String, dynamic>> _activities =  [
    {"title": "Food", "category": "expense", "amount": 12000, "icon": Icons.fastfood_rounded},
    {"title": "Transport", "category": "expense", "amount": 200, "icon": Icons.train},
    {"title": "Gift", "category": "income", "amount": 50000, "icon": Icons.card_giftcard},
    {"title": "Food", "category": "expense", "amount": 2000, "icon": Icons.fastfood},
  ];

  bool _isShow = false;

  void _toggleShow() {
    setState(() {
      _isShow = !_isShow;
    });
  }

  String _formatNumber(int number) {
    return NumberFormat("#,###").format(number).replaceAll(",", " ");
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
    String balanceFormated = _formatNumber(userBalance);

    final List<Widget> pages = [
      home(context, balanceFormated, formattedDate),
      const Center(child: Text("Reports", style: TextStyle(color: Colors.white),),),
      const Center(child: Text("Transactions", style: TextStyle(color: Colors.white),),),
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
              3,
              (index) => Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: IconButton(
                  icon: Icon(
                    (index == 0) ? Icons.home_filled : (index == 1) ? Icons.leaderboard : Icons.compare_arrows,
                    color: (index == _currentPageIndex) ? Theme.of(context).primaryColorLight : Theme.of(context).focusColor,
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Begin
            Container(
              margin: const EdgeInsets.only(top: 10, right: 20, left: 20,),
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColorDark,
                      child: const Icon(Icons.person, color: Colors.white,),
                    ),
                    title: Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text("Welcome to GestIA"),
                    trailing: const Badge(
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 217, 236, 39),
                        child: Icon(Icons.notifications_outlined),
                      ),
                    ),
                  ),
                  ListTile(
                    minVerticalPadding: 20,
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).disabledColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 56, 56, 56),
                          child: Icon(Icons.arrow_back_rounded, color: Colors.red,),
                        ),
                        title: Text("Expense", style: TextStyle(color: Colors.white,),),
                      ),
                    )
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 101, 165, 218),
                          child: Icon(Icons.arrow_forward_rounded, color: Color.fromARGB(255, 1, 59, 10),),
                        ),
                        title: Text("Income", style: TextStyle(color: Colors.white,),),
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
                color: Theme.of(context).disabledColor,
                borderRadius: BorderRadius.circular(35),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 30, top: 20),
                        child: Text(
                          "Recents",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30, top: 20),
                        child: Text(
                          "View all",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: (_activities[index]['category'] == 'expense') ? Colors.red : Colors.green,
                            child: Icon(_activities[index]["icon"], color: const Color.fromARGB(255, 224, 187, 187),),
                          ),
                          title: Text(
                            _activities[index]["title"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            _activities[index]["category"]!,
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                              fontSize: 15,
                            ),
                          ),
                          trailing: Text(
                            _formatNumber(_activities[index]['amount']),
                            style: TextStyle(
                              color: (_activities[index]['category'] == 'expense') ? Colors.red : Colors.green,
                              fontSize: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
