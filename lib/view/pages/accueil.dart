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

  TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/ispm.png",
              height: 100,
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(bottom: 1),
              color: Theme.of(context).primaryColor,
              child: SvgPicture.asset(
                "assets/images/logo.svg",
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                height: 250,
              ),
            ),
            Text(
              "Take control of your finances\nwith IA's optimization",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 23,
                fontWeight: FontWeight.w100,
              ),
            ),
            // Input
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: userNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 17, 141, 21),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  focusColor: Colors.white,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 17, 141, 21),
                    )
                  ),
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
           // End Input
            Visibility(
              visible: (_isInputNameValid) ? true : false,
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  onPressed: !(_isInputNameValid) ? null : () async {
                    await SharedPreferencesUtil.storeUserName(userNameController.text);
                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 70,
                    ),
                    backgroundColor: const Color.fromARGB(255, 25, 184, 30).withOpacity(.5),
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
      ),
    );
  }
}
