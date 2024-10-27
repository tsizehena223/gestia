import 'package:gestia/model/budget_goal.dart';
import 'package:hive/hive.dart';

class BudgetGoalAdapter extends TypeAdapter<BudgetGoal> {
  @override
  BudgetGoal read(BinaryReader reader) {
    return BudgetGoal(
      label: reader.read(),
      amount: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, BudgetGoal obj) {
    writer.write(obj.label);
    writer.write(obj.amount);
  }

  @override
  int get typeId => 1;
}
