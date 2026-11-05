import 'package:elchemist_app/features/formula/domain/formula.dart';

abstract class FormulaRepository {
  Future<Formula?> getDetails({required String id});
}
