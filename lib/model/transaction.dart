import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  int amount;
  @HiveField(1)
  String title;
  @HiveField(2)
  String category;
  @HiveField(3)
  int iconCode;
  @HiveField(4)
  DateTime date;
  @HiveField(5)
  Color color;
  @HiveField(6)
  String key;

  Transaction({
    required this.title,
    required this.amount,
    required this.category,
    required this.iconCode,
    required this.date,
    required this.color,
    required this.key,
  });

  IconData get iconData => IconData(iconCode, fontFamily: 'MaterialIcons');
}