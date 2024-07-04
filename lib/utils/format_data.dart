import 'package:gestia/model/transaction.dart';
import 'package:intl/intl.dart';

class FormatData {
  static String formatTotalNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)} K';
    }
    return NumberFormat("#,###").format(number).replaceAll(",", " ");
  }

  static String formatNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)} M';
    } else  {
      return NumberFormat("#,###").format(number).replaceAll(",", " ");
    }
  }

  static void sortWithDate(List<Transaction> transactions) {
    transactions.sort((a, b) => b.date.compareTo(a.date));
  }

}