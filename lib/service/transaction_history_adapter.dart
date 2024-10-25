import 'package:gestia/model/transaction_history.dart';
import 'package:hive/hive.dart';

class TransactionHistoryAdapter extends TypeAdapter<TransactionHistory> {
  @override
  TransactionHistory read(BinaryReader reader) {
    return TransactionHistory(
      month: reader.read(),
      year: reader.read(),
      expense: reader.read(),
      income: reader.read(),
      key: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionHistory obj) {
    writer.write(obj.month);
    writer.write(obj.year);
    writer.write(obj.income);
    writer.write(obj.expense);
    writer.write(obj.key);
  }

  @override
  int get typeId => 2;
}
