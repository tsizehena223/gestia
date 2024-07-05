import 'package:flutter/material.dart';

class HeaderReport extends StatelessWidget {
  const HeaderReport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20,),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(26),
      ),
      child: ListTile(
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).focusColor,
          child: Icon(Icons.leaderboard, color: Theme.of(context).primaryColorLight,),
        ),
        title: const Text(
          "Report",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          "Report of your transactions",
          style: TextStyle(color: Theme.of(context).focusColor,),
        ),
      ),
    );
  }
}

