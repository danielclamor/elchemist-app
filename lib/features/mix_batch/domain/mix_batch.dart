import 'package:elchemist_app/features/mix_batch/data/mix_batch_dto.dart';

class MixBatchSummary {
  final String id;
  final String mixNumber;
  final MixBatchStatus status;
  final String nicProfileFullName;
  final bool nicProfileIsPreMix;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;

  const MixBatchSummary({
    required this.id,
    required this.mixNumber,
    required this.status,
    required this.nicProfileFullName,
    required this.nicProfileIsPreMix,
    required this.batchCode,
    required this.mixedAt,
    required this.createdAt,
  });

  factory MixBatchSummary.fromDto(MixBatchSummaryDto b) {
    return MixBatchSummary(
      id: b.id,
      mixNumber: b.mixNumber,
      status: MixBatchStatus.fromDto(b.status),
      nicProfileFullName: b.nicProfileFullName,
      nicProfileIsPreMix: b.nicProfileIsPreMix,
      batchCode: b.batchCode,
      mixedAt: b.mixedAt,
      createdAt: b.createdAt,
    );
  }
}

enum MixBatchStatus {
  cancelled,
  completed,
  inProgress,
  mixed;

  static MixBatchStatus fromDto(MixBatchStatusDto value) {
    return switch (value) {
      MixBatchStatusDto.cancelled => MixBatchStatus.cancelled,
      MixBatchStatusDto.completed => MixBatchStatus.completed,
      MixBatchStatusDto.inProgress => MixBatchStatus.inProgress,
      MixBatchStatusDto.mixed => MixBatchStatus.mixed,
    };
  }
}
