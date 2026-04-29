class AIInputGuard {
  static bool isAllowed(String input) {
    final text = input.toLowerCase().trim();

    final allowedKeywords = [
      "budget",
      "expense",
      "spend",
      "money",
      "income",
      "save",
      "fare",
      "food",
      "rent",
      "bill",
      "payment",
      "cost",
      "balance",
      "overspend",
      "withdraw",
      "allowance"
    ];

    return allowedKeywords.any((k) => text.contains(k));
  }

  static String fallbackMessage() {
    return "I can only help with budgeting and spending insights.";
  }
}