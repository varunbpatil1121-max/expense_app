// lib/expense.dart

import 'package:intl/intl.dart';

enum Category { food, travel, leisure, work }

final formatter = DateFormat.yMd();

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}