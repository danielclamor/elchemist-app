import 'package:elchemist_app/constants.dart';
import 'package:elchemist_app/services/api_models.dart';

class LocalService {
  List<FormulaDto> getFormulas() {
    return (formulasData as List<dynamic>?)
            ?.map((formula) =>
                FormulaDto.fromJson(Map<String, dynamic>.from(formula as Map)))
            .toList() ??
        [];
  }

  List<NicBaseOptionDto> getNicBaseOptions() {
    return (nicBaseOptionsData as List<dynamic>?)
            ?.map((formula) => NicBaseOptionDto.fromJson(
                Map<String, dynamic>.from(formula as Map)))
            .toList() ??
        [];
  }
}
