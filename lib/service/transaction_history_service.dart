import 'package:gestia/model/transaction_history.dart';
import 'package:hive/hive.dart';

class TransactionHistoryService {
  static const String boxName = 'transactionHistory';

  Future<Box<TransactionHistory>> _openBox() async {
    return await Hive.openBox<TransactionHistory>(boxName);
  }

  Future<void> addTransactionHistory(
      TransactionHistory transactionHistory) async {
    final box = await _openBox();
    box.add(transactionHistory);
  }

  Future<List<TransactionHistory>> getTransactionsHistory() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> updateTransactionHistory(
      int index, TransactionHistory updatedTransactionHistory) async {
    final box = await _openBox();
    box.putAt(index, updatedTransactionHistory);
  }

  Future<void> deleteTransactionHistory(int index) async {
    final box = await _openBox();
    box.deleteAt(index);
  }
}
