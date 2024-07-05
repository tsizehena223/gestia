import 'package:flutter/material.dart';
import 'package:gestia/utils/shared_preferences_util.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20,),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(26),
      ),
      child: FutureBuilder(
        future: SharedPreferencesUtil.retrieveUserName(),
        builder: (context, snapshot) {
          String data = snapshot.data ?? "UserName";
          return ListTile(
            trailing: CircleAvatar(
              backgroundColor: Theme.of(context).focusColor,
              child: Icon(Icons.person, color: Theme.of(context).primaryColorLight,),
            ),
            title: Text(
              data,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              "Welcome to GestIA",
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
          );
        }
      ),
    );
  }
}
