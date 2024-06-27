import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(now);

    Widget home = Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Begin
        Container(
          margin: const EdgeInsets.only(top: 60, right: 20, left: 20,),
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
                title: const Text("Tsizehena", style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: const Text("Sarobidi"),
                trailing: const Badge(
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 217, 236, 39),
                    child: Icon(Icons.notifications_outlined),
                  ),
                ),
              ),
              ListTile(
                minVerticalPadding: 30,
                title: const Text("Total Balance", style: TextStyle(fontSize: 20),),
                subtitle: Row(
                  children: [
                    const Text("Ar  ", style: TextStyle(fontSize: 20),),
                    Text("25.000",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                ),
                trailing: const Icon(Icons.remove_red_eye_outlined),
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor,
            borderRadius: BorderRadius.circular(35),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              const SizedBox(height: 20,),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).focusColor,
                  child: const Icon(Icons.food_bank),
                ),
                title: const Text(
                  "Food",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  "Expense",
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontSize: 15,
                  ),
                ),
                trailing: const Text(
                  "12.000",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).focusColor,
                  child: const Icon(Icons.computer),
                ),
                title: const Text(
                  "Freelance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  "Income",
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontSize: 15,
                  ),
                ),
                trailing: const Text(
                  "200.000",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );

    return Scaffold(
      body: home,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
