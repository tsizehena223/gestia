import 'package:gestia/model/budget_goal.dart';
import 'package:hive/hive.dart';

class BudgetGoalService {
  static const String boxName = 'budgetgoals';

  Future<Box<BudgetGoal>> _openBox() async {
    return await Hive.openBox<BudgetGoal>(boxName);
  }

  Future<void> addBudgetGoal(BudgetGoal budgetGoal) async {
    final box = await _openBox();
    box.add(budgetGoal);
  }

  Future<List<BudgetGoal>> getBudgetGoals() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> updateBudgetGoal(int index, BudgetGoal updatedBudgetGoal) async {
    final box = await _openBox();
    box.putAt(index, updatedBudgetGoal);
  }

  Future<void> deleteBudgetGoal(int index) async {
    final box = await _openBox();
    box.deleteAt(index);
  }
}
