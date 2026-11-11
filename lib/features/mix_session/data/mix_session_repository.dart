import 'package:elchemist_app/features/mix_session/data/mix_session_dto.dart';
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
}
