import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:gestia/utils/format_data.dart';

class PredictionCardWidget extends StatelessWidget {
  const PredictionCardWidget({
    super.key,
    required this.message,
    required this.predictions
  });

  final String message;
  final List<double> predictions;

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
          '(New features, coming soon ...)',
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
                GestureDetector(
                  child: Icon(Icons.arrow_circle_right_outlined, size: 40, color: Theme.of(context).primaryColorDark,),
                  onTap: () {
                    if (text != 'Goal deadline') {
                      _showPredictions(context, text, predictions);
                    }
                  },
                ),
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

  Future<dynamic> _showPredictions(BuildContext context, String title, List<double> predictions) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(239, 26, 11, 77),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Theme.of(context).primaryColorDark),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Predictions saving goals for the next 12 months:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(
                  color: Colors.white54,
                  thickness: 1.5,
                ),
                ...predictions.map((prediction) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: Theme.of(context).primaryColorDark),
                          const SizedBox(width: 6),
                          Text(
                            "${FormatData.formatNumber(prediction.toInt())} Ariary",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColorDark
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
