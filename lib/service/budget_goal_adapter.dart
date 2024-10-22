import 'package:gestia/model/budget_goal.dart';
import 'package:hive/hive.dart';

class BudgetGoalAdapter extends TypeAdapter<BudgetGoal> {
  @override
  BudgetGoal read(BinaryReader reader) {
    return BudgetGoal(
      key: reader.read(),
      salaryMonthly: reader.read(),
      expenseMonthly: reader.read(),
      label: reader.read(),
      amount: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, BudgetGoal obj) {
    writer.write(obj.salaryMonthly);
    writer.write(obj.expenseMonthly);
    writer.write(obj.label);
    writer.write(obj.amount);
    writer.write(obj.key);
  }

  @override
  int get typeId => 1;
}
