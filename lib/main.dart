// lib/main.dart

import 'package:flutter/material.dart';
import 'expense.dart';
import 'expense_item.dart';
import 'expense_storage.dart';
import 'new_expense.dart';

final ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

final ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardThemeData(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.primary,
          foregroundColor: kColorScheme.onPrimary,
        ),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
            ),
      ),
      themeMode: ThemeMode.system,
      home: const ExpensesScreen(),
    ),
  );
}

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ExpenseStorage _storage = ExpenseStorage();
  List<Expense> _registeredExpenses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  // Loads saved expenses from the device
  Future<void> _loadExpenses() async {
    final expenses = await _storage.load();
    setState(() {
      _registeredExpenses = expenses;
      _isLoading = false;
    });
  }

  // Updates the list, sorts newest first, and saves it to the device
  void _updateExpenses(void Function(List<Expense>) change) {
    setState(() {
      change(_registeredExpenses);
      _registeredExpenses.sort((a, b) => b.date.compareTo(a.date));
    });
    _storage.save(_registeredExpenses);
  }

  // Function to open the bottom sheet modal for adding a new expense
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return NewExpense(onAddExpense: _addExpense);
      },
    );
  }

  // Function that adds the new expense and saves it to the device
  void _addExpense(Expense expense) {
    _updateExpenses((list) => list.add(expense));
  }

  void _removeExpense(Expense expense) {
    _updateExpenses((list) => list.remove(expense));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _updateExpenses((list) => list.add(expense));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay, // Opens the add expense form
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Expanded(child: ChartBar(fill: 0.6)),
                      Expanded(child: ChartBar(fill: 0.9)),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Icon(Icons.fastfood),
                    Icon(Icons.movie),
                    Icon(Icons.flight_takeoff),
                    Icon(Icons.work),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _registeredExpenses.isEmpty
                    ? const Center(
                        child: Text('No expenses found. Start adding some!'),
                      )
                    : ListView.builder(
                        itemCount: _registeredExpenses.length,
                        itemBuilder: (ctx, index) => Dismissible(
                          key: ValueKey(_registeredExpenses[index].id),
                          background: Container(
                            color: Theme.of(context)
                                .colorScheme
                                .error
                                .withValues(alpha: 0.75),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onDismissed: (direction) {
                            _removeExpense(_registeredExpenses[index]);
                          },
                          child: ExpenseItem(_registeredExpenses[index]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class ChartBar extends StatelessWidget {
  const ChartBar({super.key, required this.fill});

  final double fill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: FractionallySizedBox(
        heightFactor: fill,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.65),
          ),
        ),
      ),
    );
  }
}