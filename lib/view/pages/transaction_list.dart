import 'package:flutter/material.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/utils/format_data.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final List<Transaction> _transactions =  [
    Transaction(title: "Food", amount: 1200, category: "expense", icon: Icons.food_bank, date: DateTime(2024, 12, 10)),
    Transaction(title: "Salary", amount: 2000000, category: "income", icon: Icons.monetization_on, date: DateTime(2024, 10, 10)),
    Transaction(title: "Transport", amount: 200, category: "expense", icon: Icons.train, date: DateTime(2024, 2, 20)),
    Transaction(title: "Gift", amount: 20000, category: "income", icon: Icons.card_giftcard, date: DateTime(2024, 7, 1)),
  ];

  @override
  Widget build(BuildContext context) {
    // Tri par date
    _transactions.sort((a, b) => b.date.compareTo(a.date));

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
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
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
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: Theme.of(context).disabledColor,
                          child: ListTile(
                            title: const Text("Total Expense", style: TextStyle(color: Colors.white),),
                            subtitle: Row(
                              children: [
                                const Text("Ar  ", style: TextStyle(color: Colors.white),),
                                Text(
                                  FormatData.formatNumber(20000),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          color: Theme.of(context).primaryColorDark,
                          child: ListTile(
                            title: const Text("Total Income", style: TextStyle(color: Colors.white),),
                            subtitle: Row(
                              children: [
                                const Text("Ar  ", style: TextStyle(color: Colors.white),),
                                Text(
                                  FormatData.formatNumber(15000000),
                                  style: const TextStyle(color: Colors.white, fontSize: 25),
                                ),
                              ]
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
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (transaction.category == 'expense') ? Colors.red : Colors.green,
                    child: Icon(transaction.icon, color: const Color.fromARGB(255, 224, 187, 187),),
                  ),
                  title: Text(
                    transaction.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    FormatData.formatNumber(transaction.amount),
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 15,
                    ),
                  ),
                  trailing: Text(
                    DateFormat('yyyy-MM-dd').format(transaction.date),
                    style: TextStyle(
                      color: (transaction.category == 'expense') ? Colors.red : Colors.green,
                      fontSize: 15,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}