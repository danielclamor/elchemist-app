import 'package:elchemist_app/features/mix_session/data/mix_session_dto.dart';
import 'package:elchemist_app/features/mix_session/data/mix_session_mutation_strings.dart';
import 'package:elchemist_app/features/mix_session/data/mix_session_query_strings.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session_list_page.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MixSessionRepositoryImpl implements MixSessionRepository {
  final GraphQLClient _client;

  MixSessionRepositoryImpl(this._client);

  @override
  Stream<MixSessionListPage> watchListPage({
    required int first,
    String? after,
  }) async* {
    final observable = _client.watchQuery(
      WatchQueryOptions(
        document: gql(mixSessionListPageQuery),
        variables: {
          'first': first,
          'after': after,
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
    required List<String> mixSessionSourceIds,
    required String mixSessionTargetId,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(mixSessionMergeSessionsMutation),
        variables: {
          'sourceIds': mixSessionSourceIds.map((id) => {'id': id}).toList(),
          'targetId': mixSessionTargetId
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
}
