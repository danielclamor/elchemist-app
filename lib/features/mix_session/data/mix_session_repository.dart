import 'package:elchemist_app/features/mix_session/data/mix_session_dto.dart';
import 'package:elchemist_app/features/mix_session/data/mix_session_mutation_strings.dart';
import 'package:elchemist_app/features/mix_session/data/mix_session_query_strings.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session_list_page.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session_repository.dart';
import 'package:elchemist_app/features/recipe/data/recipe_dto.dart';
import 'package:elchemist_app/features/recipe/domain/recipe.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MixSessionRepositoryImpl implements MixSessionRepository {
  final GraphQLClient _client;

  MixSessionRepositoryImpl(this._client);

  @override
  Future<MixSessionListPage> getListPage({
    required int first,
    String? after,
    String? formulaId,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(mixSessionListPageQuery),
        variables: {
          'first': first,
          'after': after,
          'formulaIdentifier': formulaId != null ? {'id': formulaId} : null,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) throw result.exception!;

    final conn = result.data!['mixSessions'] as Map<String, dynamic>;
    final pageInfo = conn['pageInfo'] as Map<String, dynamic>;

    return MixSessionListPage(
      items: (conn['edges'] as List<dynamic>)
          .map((e) => MixSessionSummaryDto.fromJson(
              Map<String, dynamic>.from((e as Map)['node'] as Map)))
          .map((dto) => MixSessionSummary.fromDto(dto))
          .toList(),
      endCursor: pageInfo['endCursor'] as String?,
      hasPreviousPage: pageInfo['hasPreviousPage'] as bool,
      hasNextPage: pageInfo['hasNextPage'] as bool,
      totalCount: conn['totalCount'] as int,
    );
  }

  @override
  Stream<MixSessionListPage> watchListPage({
    required int first,
    String? after,
    String? formulaId,
  }) async* {
    final observable = _client.watchQuery(
      WatchQueryOptions(
        document: gql(mixSessionListPageQuery),
        variables: {
          'first': first,
          'after': after,
          'formulaIdentifier': formulaId != null ? {'id': formulaId} : null,
        },
        fetchPolicy: FetchPolicy.noCache,
        fetchResults: true,
        pollInterval: const Duration(seconds: 10),
      ),
    );

    try {
      await for (final result in observable.stream) {
        if (result.data == null) {
          if (result.hasException) throw result.exception!;
          continue;
        }

        final conn = result.data!['mixSessions'] as Map<String, dynamic>;
        final pageInfo = conn['pageInfo'] as Map<String, dynamic>;

        yield MixSessionListPage(
          items: (conn['edges'] as List<dynamic>)
              .map((e) => MixSessionSummaryDto.fromJson(
                  Map<String, dynamic>.from((e as Map)['node'] as Map)))
              .map((dto) => MixSessionSummary.fromDto(dto))
              .toList(),
          endCursor: pageInfo['endCursor'] as String?,
          hasPreviousPage: pageInfo['hasPreviousPage'] as bool,
          hasNextPage: pageInfo['hasNextPage'] as bool,
          totalCount: conn['totalCount'] as int,
        );
      }
    } finally {
      observable.close();
    }
  }

  @override
  Future<MixSession?> getDetails({required String id}) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(mixSessionDetailsQuery),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['mixSession'] as Map<String, dynamic>?;

    if (data == null) return null;

    return MixSession.fromDto(MixSessionDto.fromJson(data));
  }

  @override
  Future<String?> createWithProductionOrders({
    required List<String> productionOrderIds,
  }) async {
    final productionOrderIdentifiers =
        productionOrderIds.map((i) => {'id': i}).toList();

    final result = await _client.mutate(
      MutationOptions(
        document: gql(mixSessionCreateWithProductionOrdersMutation),
        variables: {
          'productionOrderIdentifers': productionOrderIdentifiers,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;

    final payload = result.data?['mixSessionCreateWithProductionOrders']
        as Map<String, dynamic>?;
    final feedback = payload?['feedback'] as Map<String, dynamic>?;
    final data = payload?['mixSession'] as Map<String, dynamic>?;

    if (data == null || feedback?['status'] == 'FAILED') {
      throw Exception(
        feedback?['message'] as String? ?? 'Could not create mix session',
      );
    }

    return data['id'];
  }

  @override
  Future<void> mergeMixSessions({
    required List<String> sourceIds,
    required String targetId,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(mixSessionMergeSessionsMutation),
        variables: {
          'sourceIds': sourceIds.map((id) => {'id': id}).toList(),
          'targetId': targetId
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;

    final payload = result.data?['mixSessionMerge'] as Map<String, dynamic>?;
    final feedback = payload?['feedback'] as Map<String, dynamic>?;
    final data = payload?['mixSession'] as Map<String, dynamic>?;

    if (data == null || feedback?['status'] == 'FAILED') {
      throw Exception(
        feedback?['message'] as String? ?? 'Could not create mix session',
      );
    }
  }

  @override
  Future<Recipe> setBatchVolumeMl({
    required String id,
    required double volumeMl,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(mixSessionSetBatchVolumeMlMutation),
        variables: {
          'id': id,
          'volumeMl': volumeMl,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;

    final payload =
        result.data?['mixSessionSetBatchVolumeMl'] as Map<String, dynamic>?;
    final feedback = payload?['feedback'] as Map<String, dynamic>?;
    final data = payload?['mixSession'] as Map<String, dynamic>?;

    if (data == null || feedback?['status'] == 'FAILED') {
      throw Exception(
        feedback?['message'] as String? ??
            'Could not set mix session batch volume',
      );
    }

    return Recipe.fromDto(RecipeDto.fromJson(data['recipe']));
  }

  @override
  Future<void> markMixed({required String id}) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(mixSessionMarkMixedMutation),
        variables: {
          'id': id,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;

    final payload =
        result.data?['mixSessionMarkMixed'] as Map<String, dynamic>?;
    final feedback = payload?['feedback'] as Map<String, dynamic>?;
    final data = payload?['mixSession'] as Map<String, dynamic>?;

    if (data == null || feedback?['status'] == 'FAILED') {
      throw Exception(feedback?['message'] as String? ??
          'Could not mark mix session mixed');
    }
  }
}
