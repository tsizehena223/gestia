import 'package:flutter/material.dart';
import 'package:gestia/main.dart';
import 'package:gestia/utils/shared_preferences_util.dart';

class Header extends StatefulWidget {
  const Header({
    super.key,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  void _reloadApp(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyApp(),
      ),
    );
  }

  Future<void> _updateProfile(BuildContext context) async {
    TextEditingController nameController = TextEditingController();

    return await showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Update your name',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          content: Form(
            child: TextField(
              keyboardType: TextInputType.text,
              controller: nameController,
              decoration: inputDecoration(context, 'Username'),
              style: TextStyle(color: Theme.of(context).disabledColor),
            )
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User name should not be null')),
                  );
                  return;
                }
                await SharedPreferencesUtil.storeUserName(nameController.text);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(true);
                // ignore: use_build_context_synchronously
                _reloadApp(context);
              },
              child: Text('Confirm', style: TextStyle(color: Theme.of(context).primaryColorDark),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withOpacity(.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: FutureBuilder(
        future: SharedPreferencesUtil.retrieveUserName(),
        builder: (context, snapshot) {
          String data = snapshot.data ?? "UserName";
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
              child: Icon(Icons.home_filled, color: Theme.of(context).primaryColor,),
            ),
            title: Text(
              data,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "Welcome to GestIA",
              style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(.8), fontSize: 12),
            ),
            trailing: GestureDetector(
              onTap: () => _updateProfile(context),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
                child: Icon(Icons.person, color: Theme.of(context).primaryColorDark,),
              ),
            ),
          );
        }
      ),
    );
  }

  InputDecoration inputDecoration(BuildContext context, String label) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      focusColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).focusColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      labelText: label,
      labelStyle: TextStyle(color: Theme.of(context).focusColor),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
