import 'package:elchemist_app/features/repat_job/data/repat_job_dto.dart';

enum RepatJobStatus {
  cancelled,
  completed,
  inProgress,
  reassigned;

  static RepatJobStatus fromDto(RepatJobStatusDto s) {
    return switch (s) {
      RepatJobStatusDto.cancelled => RepatJobStatus.cancelled,
      RepatJobStatusDto.completed => RepatJobStatus.completed,
      RepatJobStatusDto.inProgress => RepatJobStatus.inProgress,
      RepatJobStatusDto.reassigned => RepatJobStatus.reassigned,
    };
  }
}
