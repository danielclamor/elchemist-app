import 'package:elchemist_app/features/formula/domain/formula.dart';

class FormulaListPage {
  final List<FormulaSummary> items;
  final String? endCursor;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final int totalCount;

  const FormulaListPage({
    required this.items,
    required this.endCursor,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.totalCount,
  });
}
