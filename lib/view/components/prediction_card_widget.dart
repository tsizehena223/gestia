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
        newCard(
          context,
          Theme.of(context).primaryColor.withOpacity(.2),
          'Prediction',
          message,
        ),
        newCard(
          context,
          Theme.of(context).disabledColor.withOpacity(.5),
          'Duration',
          'New features, comming soon ...',
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
              const Icon(Icons.arrow_circle_right_rounded, size: 30, color: Color.fromARGB(255, 17, 155, 22),),
            ],
          ),
          Center(
            child: Text(
              explication,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }
}
