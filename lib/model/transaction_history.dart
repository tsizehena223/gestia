import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class TransactionHistory {
  @HiveField(0)
  String month;
  @HiveField(1)
  int year;
  @HiveField(2)
  int expense;
  @HiveField(3)
  int income;

  TransactionHistory({
    required this.month,
    required this.year,
    required this.expense,
    required this.income,
  });
}
