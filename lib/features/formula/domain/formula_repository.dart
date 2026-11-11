import 'package:elchemist_app/features/formula/domain/formula.dart';
import 'package:elchemist_app/features/formula/domain/formula_list_page.dart';

abstract class FormulaRepository {
  Future<Formula?> getDetails({required String id});

  Future<FormulaListPage> getListPage({
    required int first,
    String? after,
  });
}
