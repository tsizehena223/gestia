import 'package:gestia/model/transaction.dart';
import 'package:hive/hive.dart';

class TransactionService {
  static const String boxName = 'transactions';

  Future<Box<Transaction>> _openBox() async {
    return await Hive.openBox<Transaction>(boxName);
  }

  Future<void> addTransaction(Transaction transaction) async {
    final box = await _openBox();
    box.add(transaction);
  }

  Future<List<Transaction>> getTransactions() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> updateTransaction(int index, Transaction updatedTransaction) async {
    final box = await _openBox();
    box.putAt(index, updatedTransaction);
  }

  Future<void> deleteTransaction(int index) async {
    final box = await _openBox();
    box.deleteAt(index);
  }
}
