import 'package:elchemist_app/features/mix_batch/data/mix_batch_dto.dart';

class MixBatch {
  final String id;
  final String mixNumber;
  final MixBatchStatus status;
  final NicProfileSummary nicProfile;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;
  final int? totalVolumeMl;

  const MixBatch({
    required this.id,
    required this.mixNumber,
    required this.status,
    required this.nicProfile,
    required this.batchCode,
    required this.mixedAt,
    required this.createdAt,
    required this.totalVolumeMl,
  });

  factory MixBatch.fromDto(MixBatchDto b) {
    return MixBatch(
      id: b.id,
      mixNumber: b.mixNumber,
      status: MixBatchStatus.fromDto(b.status),
      nicProfile: NicProfileSummary.fromDto(b.nicProfile),
      batchCode: b.batchCode,
      mixedAt: b.mixedAt,
      createdAt: b.createdAt,
      totalVolumeMl: b.totalVolumeMl,
    );
  }
}

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

class NicProfileSummary {
  final String id;
  final String name;
  final String fullName;
  final bool isPreMix;

  const NicProfileSummary({
    required this.id,
    required this.name,
    required this.fullName,
    required this.isPreMix,
  });

  factory NicProfileSummary.fromDto(NicProfileSummaryDto p) {
    return NicProfileSummary(
      id: p.id,
      name: p.name,
      fullName: p.fullName,
      isPreMix: p.isPreMix,
    );
  }
}
