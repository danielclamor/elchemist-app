import 'package:elchemist_app/features/eliquid/data/eliquid_dto.dart';
import 'package:elchemist_app/features/eliquid/data/eliquid_queries.dart';
import 'package:elchemist_app/features/eliquid/domain/eliquid.dart';
import 'package:elchemist_app/features/eliquid/domain/eliquid_list_page.dart';
import 'package:elchemist_app/features/eliquid/domain/eliquid_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EliquidRepositoryImpl implements EliquidRepository {
  final GraphQLClient _client;

  EliquidRepositoryImpl(this._client);

  @override
  Future<EliquidListPage> getListPage({
    required int first,
    String? after,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(eliquidListPageQuery),
        variables: {
          'first': first,
          'after': after,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) throw result.exception!;

    final conn = result.data!['eliquids'] as Map<String, dynamic>;
    final pageInfo = conn['pageInfo'] as Map<String, dynamic>;

    return EliquidListPage(
      items: (conn['edges'] as List<dynamic>)
          .map((e) => EliquidSummaryDto.fromJson(
              Map<String, dynamic>.from((e as Map)['node'] as Map)))
          .map((dto) => EliquidSummary.fromDto(dto))
          .toList(),
      endCursor: pageInfo['endCursor'] as String?,
      hasPreviousPage: pageInfo['hasPreviousPage'] as bool,
      hasNextPage: pageInfo['hasNextPage'] as bool,
    );
  }
}
