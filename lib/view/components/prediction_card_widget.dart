import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class PredictionCardWidget extends StatelessWidget {
  const PredictionCardWidget({
    super.key,
    required this.message
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50,),
        newCard(
          context,
          Theme.of(context).primaryColor.withOpacity(.2),
          'Prediction',
          message,
        ),
        const SizedBox(height: 20,),
        newCard(
          context,
          Theme.of(context).disabledColor.withOpacity(.3),
          'Goal deadline',
          '(New features, comming soon ...)',
        ),
      ],
    );
  }

  Card newCard(BuildContext context, Color color, String text, String explication) {
    return Card(
    margin: const EdgeInsets.all(8),
    color: color,
    elevation: 8,
    child: Container(
      padding: const EdgeInsets.all(16),
      height: 170,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 30, 
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0),
                  child: Icon(Icons.workspace_premium, color: Theme.of(context).primaryColorDark,),
                ),
              ),
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColorLight
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ), 
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Premium',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
              Icon(Icons.arrow_circle_right_outlined, size: 40, color: Theme.of(context).primaryColorDark, ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    explication,
                    speed: const Duration(milliseconds: 100),
                    textStyle: TextStyle(
                      color: (text == 'Goal deadline') ? Theme.of(context).primaryColor : Colors.green,
                      fontWeight: (text == 'Goal deadline') ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ],
                repeatForever: (text == 'Goal deadline') ? false : true,
                totalRepeatCount: 1,
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }
}
