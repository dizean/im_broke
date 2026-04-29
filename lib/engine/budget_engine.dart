import '../models/expense.dart';
import '../models/income.dart';
import '../models/insight.dart';

class BudgetAIEngine {
  List<Insight> generateInsights({
    required List<Expense> expenses,
    required Income income,
  }) {
    final totalSpent = _total(expenses);
    final remaining = income.amount - totalSpent;

    return [
      ..._budgetStatus(totalSpent, income.amount),
      ..._categoryInsights(expenses, totalSpent),
      ..._dailyForecast(expenses, income, remaining),
      ..._behaviorPattern(expenses),
    ];
  }

  double _total(List<Expense> expenses) =>
      expenses.fold(0, (s, e) => s + e.amount);

  // 💰 Budget Status
  List<Insight> _budgetStatus(double spent, double income) {
    final percent = income == 0 ? 0 : spent / income;

    if (percent >= 1.0) {
      return [
        Insight(
          title: "Budget Exceeded",
          message: "You already exceeded your budget.",
          type: "danger",
        )
      ];
    } else if (percent >= 0.8) {
      return [
        Insight(
          title: "Budget Warning",
          message: "You've used 80% of your budget.",
          type: "warning",
        )
      ];
    }

    return [
      Insight(
        title: "On Track",
        message: "Your spending is under control.",
        type: "info",
      )
    ];
  }

  // 🍔 Category Insight
  List<Insight> _categoryInsights(
      List<Expense> expenses, double total) {
    if (expenses.isEmpty) return [];

    final map = <String, double>{};

    for (var e in expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }

    final top = map.entries.reduce((a, b) =>
        a.value > b.value ? a : b);

    final percent = total == 0 ? 0 : (top.value / total) * 100;

    return [
      Insight(
        title: "Top Spending Category",
        message:
            "${top.key} takes ${percent.toStringAsFixed(1)}% of your expenses.",
        type: percent > 40 ? "warning" : "info",
      )
    ];
  }

  // 📉 Daily Forecast
  List<Insight> _dailyForecast(
    List<Expense> expenses,
    Income income,
    double remaining,
  ) {
    if (expenses.isEmpty) return [];

    final daysPassed =
        DateTime.now().difference(income.startDate).inDays + 1;

    final totalSpent = _total(expenses);
    final dailyAvg = totalSpent / daysPassed;

    final totalDays =
        income.type == "15_days" ? 15 : 30;

    final daysLeft = totalDays - daysPassed;

    final projected = dailyAvg * totalDays;

    final insights = <Insight>[];

    insights.add(
      Insight(
        title: "Daily Spending",
        message:
            "You're spending ₱${dailyAvg.toStringAsFixed(2)} per day.",
        type: "info",
      ),
    );

    if (projected > income.amount) {
      insights.add(
        Insight(
          title: "Overspending Risk",
          message:
              "At this rate, you'll exceed your budget.",
          type: "danger",
        ),
      );
    }

    if (daysLeft > 0) {
      insights.add(
        Insight(
          title: "Safe Daily Budget",
          message:
              "You can spend ₱${(remaining / daysLeft).toStringAsFixed(2)} per day safely.",
          type: "info",
        ),
      );
    }

    return insights;
  }

  // 📊 Behavior Pattern
  List<Insight> _behaviorPattern(List<Expense> expenses) {
    if (expenses.length < 3) return [];

    double weekday = 0;
    double weekend = 0;

    for (var e in expenses) {
      if (e.date.weekday >= 6) {
        weekend += e.amount;
      } else {
        weekday += e.amount;
      }
    }

    if (weekend > weekday) {
      return [
        Insight(
          title: "Weekend Spending Pattern",
          message:
              "You spend more on weekends. Watch discretionary spending.",
          type: "warning",
        )
      ];
    }

    return [];
  }
}