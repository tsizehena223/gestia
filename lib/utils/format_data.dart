import 'package:gestia/model/transaction.dart';
import 'package:intl/intl.dart';

class FormatData {
  static String formatNumber(int number) {
    if (number >= 100000000) {
      return '${(number / 10000000).toStringAsFixed(1)}M';
    } else {
      return NumberFormat("#,###").format(number).replaceAll(",", " ");
    }
  }

  static void sortWithDate(List<Transaction> transactions) {
    transactions.sort((a, b) => b.date.compareTo(a.date));
  }

}