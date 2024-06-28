import 'package:flutter/material.dart';

class Transaction {
  final int amount;
  final String title;
  final String category;
  final IconData icon;
  final DateTime date;

  Transaction({
    required this.title,
    required this.amount,
    required this.category,
    required this.icon,
    required this.date,
  });
}