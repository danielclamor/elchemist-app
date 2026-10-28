class MixBatchDto {
  final String id;
  final String mixNumber;
  final MixBatchStatusDto status;
  final NicProfileSummaryDto nicProfile;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;
  final int? totalVolumeMl;

  const MixBatchDto({
    required this.id,
    required this.mixNumber,
    required this.status,
    required this.nicProfile,
    required this.batchCode,
    required this.mixedAt,
    required this.createdAt,
    required this.totalVolumeMl,
  });

  factory MixBatchDto.fromJson(Map<String, dynamic> json) {
    final nicProfileJson = json['nicProfile'];

    return MixBatchDto(
      id: json['id'] as String,
      mixNumber: json['mixNumber'] as String,
      status: MixBatchStatusDto.fromString(json['status'] as String),
      nicProfile:
          NicProfileSummaryDto.fromJson(nicProfileJson as Map<String, dynamic>),
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
  final String nicProfileFullName;
  final bool nicProfileIsPreMix;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;

  const MixBatchSummaryDto({
    required this.id,
    required this.mixNumber,
    required this.status,
    required this.nicProfileFullName,
    required this.nicProfileIsPreMix,
    required this.batchCode,
    required this.mixedAt,
    required this.createdAt,
  });

  factory MixBatchSummaryDto.fromJson(Map<String, dynamic> json) {
    final nicProfileJson = json['nicProfile'];

    return MixBatchSummaryDto(
      id: json['id'] as String,
      mixNumber: json['mixNumber'] as String,
      status: MixBatchStatusDto.fromString(json['status'] as String),
      nicProfileFullName: nicProfileJson['fullName'] as String,
      nicProfileIsPreMix: nicProfileJson['isPreMix'] as bool,
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

class NicProfileSummaryDto {
  final String id;
  final String name;
  final String fullName;
  final bool isPreMix;
  final FormulaSummaryDto formula;

  const NicProfileSummaryDto({
    required this.id,
    required this.name,
    required this.fullName,
    required this.isPreMix,
    required this.formula,
  });

  factory NicProfileSummaryDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['formula'];

    return NicProfileSummaryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      isPreMix: json['isPreMix'] as bool,
      formula: FormulaSummaryDto.fromJson(
        formulaJson as Map<String, dynamic>,
      ),
    );
  }
}

class FormulaSummaryDto {
  final String id;
  final String brand;
  final String name;
  final String chillType;
  final String nicType;

  const FormulaSummaryDto({
    required this.id,
    required this.brand,
    required this.name,
    required this.chillType,
    required this.nicType,
  });

  factory FormulaSummaryDto.fromJson(Map<String, dynamic> json) {
    return FormulaSummaryDto(
      id: json['id'] as String,
      brand: json['brand'] as String,
      name: json['name'] as String,
      chillType: json['chillType'] as String,
      nicType: json['nicType'] as String,
    );
  }
}
