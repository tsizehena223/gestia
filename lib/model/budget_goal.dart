import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class BudgetGoal {
  @HiveField(0)
  String label;
  @HiveField(1)
  int amount;

  BudgetGoal({
    required this.label,
    required this.amount,
  });
}