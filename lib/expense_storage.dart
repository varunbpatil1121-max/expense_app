// lib/expense_storage.dart

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'expense.dart';

// Saves expenses on the device as a JSON list
class ExpenseStorage {
  static const _key = 'expenses';

  Future<List<Expense>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return [];

    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((item) => Expense.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(expenses.map((e) => e.toMap()).toList());
    await prefs.setString(_key, json);
  }
}
