import 'package:flutter/material.dart';
import 'package:gestia/utils/shared_preferences_util.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: FutureBuilder(
        future: SharedPreferencesUtil.retrieveUserName(),
        builder: (context, snapshot) {
          String data = snapshot.data ?? "UserName";
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).disabledColor,
              child: Icon(Icons.person, color: Theme.of(context).primaryColorDark,),
            ),
            title: Text(
              data,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              "Welcome to GestIA",
              style: TextStyle(color: Theme.of(context).focusColor, fontSize: 12),
            ),
          );
        }
      ),
    );
  }
}
