import 'package:elchemist_app/features/formula/data/formula_dto.dart';
import 'package:elchemist_app/features/production_order/data/production_order_dto.dart';
import 'package:elchemist_app/features/recipe/data/recipe_dto.dart';

class MixSessionDto {
  final String id;
  final String sessionNumber;
  final MixSessionStatusDto status;
  final String? batchCode;
  final int? batchVolumeMl;
  final bool isArchived;
  final List<ProductionOrderSummaryDto> productionOrders;
  final int totalOrdersVolumeMl;
  final FormulaDto formula;
  final DateTime? mixedAt;
  final DateTime createdAt;
  final RecipeDto recipe;

  const MixSessionDto({
    required this.id,
    required this.sessionNumber,
    required this.status,
    required this.batchCode,
    required this.batchVolumeMl,
    required this.isArchived,
    required this.productionOrders,
    required this.totalOrdersVolumeMl,
    required this.formula,
    required this.mixedAt,
    required this.createdAt,
    required this.recipe,
  });

  factory MixSessionDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['formula'] as Map;
    final formula = FormulaDto.fromJson(Map<String, dynamic>.from(formulaJson));
    print(formula);

    final productionOrderJson = json['productionOrders'] as List<dynamic>;
    final productionOrders = productionOrderJson
        .map((o) => ProductionOrderSummaryDto.fromJson(
              Map<String, dynamic>.from(o as Map),
            ))
        .toList();
    print(productionOrders);

    final recipeJson = json['recipe'] as Map;
    final recipe = RecipeDto.fromJson(Map<String, dynamic>.from(recipeJson));
    print(recipe);

    return MixSessionDto(
      id: json['id'] as String,
      sessionNumber: json['sessionNumber'] as String,
      status: MixSessionStatusDto.fromString(json['status'] as String),
      batchCode: json['batchCode'] as String?,
      batchVolumeMl: (json['batchVolumeMl'] as num?)?.toInt(),
      isArchived: json['isArchived'] as bool,
      productionOrders: productionOrders,
      totalOrdersVolumeMl: (json['totalOrdersVolumeMl'] as num?)?.toInt() ?? 0,
      formula: formula,
      mixedAt: json['mixedAt'] != null
          ? DateTime.parse(json['mixedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      recipe: recipe,
    );
  }
}

class MixSessionSummaryDto {
  final String id;
  final String sessionNumber;
  final MixSessionStatusDto status;
  final String formulaName;
  final bool formulaIsPreMix;
  final String? batchCode;
  final bool isArchived;
  final DateTime? mixedAt;
  final DateTime createdAt;

  const MixSessionSummaryDto({
    required this.id,
    required this.sessionNumber,
    required this.status,
    required this.formulaName,
    required this.formulaIsPreMix,
    required this.batchCode,
    required this.isArchived,
    required this.mixedAt,
    required this.createdAt,
  });

  factory MixSessionSummaryDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['formula'];

    return MixSessionSummaryDto(
      id: json['id'] as String,
      sessionNumber: json['sessionNumber'] as String,
      status: MixSessionStatusDto.fromString(json['status'] as String),
      formulaName: formulaJson['name'] as String,
      formulaIsPreMix: formulaJson['isPreMix'] as bool,
      batchCode: json['batchCode'] as String?,
      isArchived: json['isArchived'] as bool,
      mixedAt: json['mixedAt'] != null
          ? DateTime.parse(json['mixedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() =>
      'MixSession: {number: $sessionNumber, formulaName: $formulaName}';
}

enum MixSessionStatusDto {
  inProgress,
  mixed;

  static MixSessionStatusDto fromString(String value) {
    return switch (value) {
      'IN_PROGRESS' => MixSessionStatusDto.inProgress,
      'MIXED' => MixSessionStatusDto.mixed,
      _ => throw FormatException('Unknown MixSessionStatus: $value'),
    };
  }
}
