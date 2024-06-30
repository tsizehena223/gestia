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

  Transaction({
    required this.title,
    required this.amount,
    required this.category,
    required this.iconCode,
    required this.date,
  });

  IconData get iconData => IconData(iconCode, fontFamily: 'MaterialIcons');
}