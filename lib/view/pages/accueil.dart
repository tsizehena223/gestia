import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestia/view/pages/home.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 1),
            color: Colors.white,
            child: SvgPicture.asset(
              "assets/images/welcome.svg",
              height: 250,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "With GestIA",
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            "Take control of your finances\nwith IA's optimization",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontWeight: FontWeight.w100,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 70,
                ),
                backgroundColor: Theme.of(context).primaryColorDark,
              ),
              child: const Text(
                "Start",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
