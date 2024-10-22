import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class BudgetGoal {
  @HiveField(0)
  int salaryMonthly;
  @HiveField(1)
  int expenseMonthly;
  @HiveField(2)
  String label;
  @HiveField(3)
  int amount;
  @HiveField(4)
  String key;

  BudgetGoal({
    required this.salaryMonthly,
    required this.expenseMonthly,
    required this.label,
    required this.amount,
    required this.key
  });
}