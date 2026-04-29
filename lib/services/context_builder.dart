import '../models/expense.dart';

class AIContextBuilder {
  static Map<String, dynamic> build({
    required double income,
    required List<Expense> expenses,
  }) {
    final spent =
        expenses.fold(0.0, (s, e) => s + e.amount);

    final map = <String, double>{};

    for (var e in expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }

    String top = "None";
    double max = 0;

    map.forEach((k, v) {
      if (v > max) {
        max = v;
        top = k;
      }
    });

    return {
      "income": income,
      "spent": spent,
      "remaining": income - spent,
      "top_category": top,
      "transactions": expenses.length,
    };
  }
}