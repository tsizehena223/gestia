import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:gestia/view/pages/home.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  bool _isInputNameValid = false;
  bool _isInputNumberValid = false;

  TextEditingController userNameController = TextEditingController();
  TextEditingController userBalanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 1),
            color: Theme.of(context).primaryColor,
            child: SvgPicture.asset(
              "assets/images/logo.svg",
              colorFilter: ColorFilter.mode(Theme.of(context).primaryColorLight, BlendMode.srcIn),
              height: 250,
            ),
          ),
          const Text(
            "Take control of your finances\nwith IA's optimization",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w100,
            ),
          ),
          // Input
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: userNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColorDark,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                focusColor: Colors.white,
                labelText: "Type your name",
                labelStyle: TextStyle(color: Theme.of(context).focusColor),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onChanged: (String? value) => {
                if (value == null || value == "") {
                  setState(
                    () {
                      _isInputNameValid = false;
                    }
                  )
                } else {
                  setState(() {
                    _isInputNameValid = true;
                  })
                },
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: userBalanceController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColorDark,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                fillColor: Colors.white,
                labelText: "Type your current balance",
                labelStyle: TextStyle(color: Theme.of(context).focusColor),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onChanged: (String? value) => {
                if (value == null || value == "") {
                  setState(
                    () {
                    _isInputNumberValid = false;
                    }
                  )
                } else {
                  setState(() {
                    _isInputNumberValid = true;
                  })
                },
              },
            ),
          ),
          // End Input
          Visibility(
            visible: (_isInputNameValid && _isInputNumberValid) ? true : false,
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: !(_isInputNameValid && _isInputNumberValid) ? null : () async {
                  await SharedPreferencesUtil.storeUserName(userNameController.text);
                  await SharedPreferencesUtil.storeBalance(int.parse(userBalanceController.text));

                  Navigator.push(
                    // ignore: use_build_context_synchronously
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
          ),
        ],
      ),
    );
  }
}
