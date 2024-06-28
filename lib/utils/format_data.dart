import 'package:intl/intl.dart';

class FormatData {
  static String formatNumber(int number) {
    return NumberFormat("#,###").format(number).replaceAll(",", " ");
  }
}