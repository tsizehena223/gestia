import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).disabledColor,
          child: Icon(icon, color: Theme.of(context).primaryColorDark,),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 12),
        ),
        trailing: CircleAvatar(
              backgroundColor: Theme.of(context).disabledColor,
              child: Icon(Icons.person_2_rounded, color: Theme.of(context).primaryColorDark,),
            ),
      ),
    );
  }
}

