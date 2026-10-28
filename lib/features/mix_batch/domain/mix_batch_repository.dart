import 'package:elchemist_app/features/mix_batch/domain/mix_batch.dart';
import 'package:elchemist_app/features/mix_batch/domain/mix_batch_list_page.dart';

abstract class MixBatchRepository {
  Stream<MixBatchListPage> watchListPage({
    required int first,
    String? after,
  });
}
