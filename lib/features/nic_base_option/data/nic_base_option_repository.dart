import 'package:elchemist_app/features/nic_base_option/data/nic_base_option_dto.dart';
import 'package:elchemist_app/features/nic_base_option/data/nic_base_option_query_strings.dart';
import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option.dart';
import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option_list_page.dart';
import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NicBaseOptionRepositoryImpl implements NicBaseOptionRepository {
  final GraphQLClient _client;

  NicBaseOptionRepositoryImpl(this._client);

  @override
  Future<NicBaseOptionListPage> getListPage({
    required int first,
    String? after,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(nicBaseOptionListPageQuery),
        variables: {
          'first': first,
          'after': after,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) throw result.exception!;

    final conn = result.data!['nicBaseOptions'] as Map<String, dynamic>;
    final pageInfo = conn['pageInfo'] as Map<String, dynamic>;

    return NicBaseOptionListPage(
      items: (conn['edges'] as List<dynamic>)
          .map((e) => NicBaseOptionDto.fromJson(
              Map<String, dynamic>.from((e as Map)['node'] as Map)))
          .map((dto) => NicBaseOption.fromDto(dto))
          .toList(),
      endCursor: pageInfo['endCursor'] as String?,
      hasPreviousPage: pageInfo['hasPreviousPage'] as bool,
      hasNextPage: pageInfo['hasNextPage'] as bool,
      // totalCount: pageInfo['totalCount'] as int,
    );
  }
}
