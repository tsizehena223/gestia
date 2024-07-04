import 'package:flutter/material.dart';

class HeaderTransaction extends StatelessWidget {
  const HeaderTransaction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20,),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(26),
      ),
      child: ListTile(
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColorLight,
          child: Icon(Icons.compare_arrows, color: Theme.of(context).primaryColorDark,),
        ),
        title: const Text(
          "Transactions",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          "List of your transactions",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
        ),
      ),
    );
  }
}

