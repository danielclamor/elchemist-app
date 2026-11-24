import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session_list_page.dart';
import 'package:elchemist_app/features/recipe/domain/recipe.dart';

abstract class MixSessionRepository {
  Stream<MixSessionListPage> watchListPage({
    required int first,
    String? after,
    String? formulaId,
  });

  Future<MixSessionListPage> getListPage({
    required int first,
    String? after,
    String? formulaId,
  });

  Future<MixSession?> getDetails({
    required String id,
  });

  Future<String?> createWithProductionOrders({
    required List<String> productionOrderIds,
  });

  Future<void> mergeMixSessions({
    required List<String> sourceIds,
    required String targetId,
  });

  Future<Recipe> setBatchVolumeMl({
    required String id,
    required double volumeMl,
  });

  Future<void> markMixed({
    required String id,
  });
}
