import 'package:elchemist_app/features/location/data/location_dto.dart';
import 'package:elchemist_app/features/location/data/location_queries.dart';
import 'package:elchemist_app/features/location/domain/location.dart';
import 'package:elchemist_app/features/location/domain/location_list_page.dart';
import 'package:elchemist_app/features/location/domain/location_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LocationRepositoryImpl implements LocationRepository {
  final GraphQLClient _client;

  LocationRepositoryImpl(this._client);

  @override
  Future<LocationListPage> getListPage({
    required int first,
    String? after,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(locationSummaryListPageQuery),
        variables: {
          'first': first,
          'after': after,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) throw result.exception!;

    final conn = result.data!['locations'] as Map<String, dynamic>;
    final pageInfo = conn['pageInfo'] as Map<String, dynamic>;

    return LocationListPage(
      items: (conn['edges'] as List<dynamic>)
          .map((e) => LocationSummaryDto.fromJson(
              Map<String, dynamic>.from((e as Map)['node'] as Map)))
          .map((dto) => LocationSummary.fromDto(dto))
          .toList(),
      endCursor: pageInfo['endCursor'] as String?,
      hasPreviousPage: pageInfo['hasPreviousPage'] as bool,
      hasNextPage: pageInfo['hasNextPage'] as bool,
    );
  }
}
