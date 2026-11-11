import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session_list_page.dart';

abstract class MixSessionRepository {
  Stream<MixSessionListPage> watchListPage({
    required int first,
    String? after,
  });

  Future<MixSession?> getDetails({
    required String id,
  });
}
