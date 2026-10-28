import 'package:elchemist_app/features/mix_batch/data/mix_batch_dto.dart';
import 'package:elchemist_app/features/mix_batch/data/mix_batch_query_strings.dart';
import 'package:elchemist_app/features/mix_batch/domain/mix_batch.dart';
import 'package:elchemist_app/features/mix_batch/domain/mix_batch_list_page.dart';
import 'package:elchemist_app/features/mix_batch/domain/mix_batch_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MixBatchRepositoryImpl implements MixBatchRepository {
  final GraphQLClient _client;

  MixBatchRepositoryImpl(this._client);

  @override
  Stream<MixBatchListPage> watchListPage({
    required int first,
    String? after,
  }) async* {
    final observable = _client.watchQuery(
      WatchQueryOptions(
        document: gql(mixBatchListPageQuery),
        variables: {
          'first': first,
          'after': after,
        },
        fetchPolicy: FetchPolicy.networkOnly,
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

        final conn = result.data!['mixBatches'] as Map<String, dynamic>;
        final pageInfo = conn['pageInfo'] as Map<String, dynamic>;

        yield MixBatchListPage(
          items: (conn['edges'] as List<dynamic>)
              .map((e) => MixBatchSummaryDto.fromJson(
                  Map<String, dynamic>.from((e as Map)['node'] as Map)))
              .map((dto) => MixBatchSummary.fromDto(dto))
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
  Future<MixBatch?> getDetails({required String id}) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(mixBatchDetailsQuery),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['mixBatch'] as Map<String, dynamic>?;
    print(data);
    if (data == null) return null;
    final mixBatchDto = MixBatchDto.fromJson(data);
    print(mixBatchDto);
    final mixBatch = MixBatch.fromDto(mixBatchDto);
    print(mixBatch);
    return mixBatch;
  }
}
