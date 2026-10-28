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
          ? DateTime.tryParse(json['mixedAt'] as String)
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
