import '../engine/ai_input_guard.dart';
import '../engine/budget_engine.dart';
import '../services/ai_service.dart';
import '../services/context_builder.dart';
import '../models/expense.dart';
import '../models/income.dart';

class BudgetController {
  final BudgetAIEngine engine;
  final AIService aiService;

  BudgetController({
    required this.engine,
    required this.aiService,
  });

  Future<Map<String, dynamic>> handleUserQuery({
    required String input,
    required List<Expense> expenses,
    required Income income,
  }) async {
    // 1. INPUT GUARD (FIRST LAYER)
    if (!AIInputGuard.isAllowed(input)) {
      return {
        "source": "guard",
        "response": AIInputGuard.fallbackMessage(),
        "insights": [],
      };
    }

    // 2. RULE-BASED ENGINE (INSTANT INSIGHTS)
    final insights = engine.generateInsights(
      expenses: expenses,
      income: income,
    );

    // 3. CONTEXT BUILDER FOR AI
    final context = AIContextBuilder.build(
      income: income.amount,
      expenses: expenses,
    );

    // 4. AI RESPONSE (OPTIONAL ENHANCEMENT)
    final aiResponse = await aiService.generateResponse(
      question: input,
      context: context,
    );

    // 5. FINAL RESPONSE MERGE
    return {
      "source": "hybrid",
      "insights": insights,
      "ai": aiResponse,
    };
  }
}