import 'package:gestia/model/transaction.dart';
import 'package:hive/hive.dart';

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  Transaction read(BinaryReader reader) {
    return Transaction(
      title: reader.read(),
      category: reader.read(),
      amount: reader.read(),
      date: reader.read(),
      iconCode: reader.read(),
      color: reader.read(),
      key: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer.write(obj.title);
    writer.write(obj.category);
    writer.write(obj.amount);
    writer.write(obj.date);
    writer.write(obj.iconCode);
    writer.write(obj.color);
    writer.write(obj.key);
  }

  @override
  int get typeId => 0;
}
