import 'package:elchemist_app/features/formula/data/formula_dto.dart';

class MixBatchDto {
  final String id;
  final String mixNumber;
  final MixBatchStatusDto status;
  final FormulaSummaryDto formula;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;
  final int? totalVolumeMl;

  const MixBatchDto({
    required this.id,
    required this.mixNumber,
    required this.status,
    required this.formula,
    required this.batchCode,
    required this.mixedAt,
    required this.createdAt,
    required this.totalVolumeMl,
  });

  factory MixBatchDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['formula'];

    return MixBatchDto(
      id: json['id'] as String,
      mixNumber: json['mixNumber'] as String,
      status: MixBatchStatusDto.fromString(json['status'] as String),
      formula: FormulaSummaryDto.fromJson(
          Map<String, dynamic>.from(formulaJson as Map)),
      batchCode: json['batchCode'] as String?,
      mixedAt: json['mixedAt'] != null
          ? DateTime.parse(json['mixedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalVolumeMl: json['totalVolumeMl'] as int?,
    );
  }
}

class MixBatchSummaryDto {
  final String id;
  final String mixNumber;
  final MixBatchStatusDto status;
  final String formulaFullName;
  final bool formulaIsPreMix;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;

  const MixBatchSummaryDto({
    required this.id,
    required this.mixNumber,
    required this.status,
    required this.formulaFullName,
    required this.formulaIsPreMix,
    required this.batchCode,
    required this.mixedAt,
    required this.createdAt,
  });

  factory MixBatchSummaryDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['formula'];

    return MixBatchSummaryDto(
      id: json['id'] as String,
      mixNumber: json['mixNumber'] as String,
      status: MixBatchStatusDto.fromString(json['status'] as String),
      formulaFullName: formulaJson['fullName'] as String,
      formulaIsPreMix: formulaJson['isPreMix'] as bool,
      batchCode: json['batchCode'] as String?,
      mixedAt: json['mixedAt'] != null
          ? DateTime.parse(json['mixedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

enum MixBatchStatusDto {
  cancelled,
  completed,
  inProgress,
  mixed;

  static MixBatchStatusDto fromString(String value) {
    return switch (value) {
      'CANCELLED' => MixBatchStatusDto.cancelled,
      'COMPLETED' => MixBatchStatusDto.completed,
      'IN_PROGRESS' => MixBatchStatusDto.inProgress,
      'MIXED' => MixBatchStatusDto.mixed,
      _ => throw FormatException('Unknown MixBatchStatus: $value'),
    };
  }
}
