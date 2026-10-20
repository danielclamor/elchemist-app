import 'package:elchemist_app/features/mix_job/data/mix_job_dto.dart';

class MixJob {}

class MixJobSummary {}

enum MixJobStatus {
  cancelled,
  completed,
  inProgress,
  mixed,
  reassigned;

  static MixJobStatus fromDto(MixJobStatusDto s) {
    return switch (s) {
      MixJobStatusDto.cancelled => MixJobStatus.cancelled,
      MixJobStatusDto.completed => MixJobStatus.completed,
      MixJobStatusDto.inProgress => MixJobStatus.inProgress,
      MixJobStatusDto.mixed => MixJobStatus.mixed,
      MixJobStatusDto.reassigned => MixJobStatus.reassigned,
    };
  }
}
