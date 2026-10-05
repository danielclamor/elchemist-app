import 'package:elchemist_app/features/production_order/domain/production_order_date_range.dart';
import 'package:elchemist_app/features/production_order/domain/production_order_list_page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/domain/production_order_repository.dart';
import 'production_order_dto.dart';
import 'production_order_queries.dart';

class ProductionOrderRepositoryImpl implements ProductionOrderRepository {
  final GraphQLClient _client;

  ProductionOrderRepositoryImpl(this._client);

  @override
  Future<ProductionOrderListPage> getListPage({
    required int first,
    String? after,
    ProductionOrderStatus? status,
    DateRange? range,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(productionOrderListPageQuery),
        variables: {
          'first': first,
          'after': after,
          'status': status?.gql,
          'createdFrom': range?.from?.toUtc().toIso8601String(),
          'createdTo': range?.from?.toUtc().toIso8601String(),
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) throw result.exception!;

    final conn = result.data!['productionOrders'] as Map<String, dynamic>;
    final pageInfo = conn['pageInfo'] as Map<String, dynamic>;

    return ProductionOrderListPage(
      items: (conn['edges'] as List<dynamic>)
          .map((e) => ProductionOrderSummaryDto.fromJson(
              Map<String, dynamic>.from((e as Map)['node'] as Map)))
          .map((dto) => ProductionOrderSummary.fromDto(dto))
          .toList(),
      endCursor: pageInfo['endCursor'] as String?,
      hasPreviousPage: pageInfo['hasPreviousPage'] as bool,
      hasNextPage: pageInfo['hasNextPage'] as bool,
    );
  }

  @override
  Stream<ProductionOrderListPage> watchListPage({
    required int first,
    String? after,
    ProductionOrderStatus? status,
    DateRange? range,
  }) async* {
    final observable = _client.watchQuery(
      WatchQueryOptions(
        document: gql(productionOrderListPageQuery),
        variables: {
          'first': first,
          'after': after,
          'status': status?.gql,
          'createdFrom': range?.from?.toUtc().toIso8601String(),
          'createdTo': range?.to?.toUtc().toIso8601String(),
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
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

        final conn = result.data!['productionOrders'] as Map<String, dynamic>;
        final pageInfo = conn['pageInfo'] as Map<String, dynamic>;

        yield ProductionOrderListPage(
          items: (conn['edges'] as List<dynamic>)
              .map((e) => ProductionOrderSummaryDto.fromJson(
                  Map<String, dynamic>.from((e as Map)['node'] as Map)))
              .map((dto) => ProductionOrderSummary.fromDto(dto))
              .toList(),
          endCursor: pageInfo['endCursor'] as String?,
          hasPreviousPage: pageInfo['hasPreviousPage'] as bool,
          hasNextPage: pageInfo['hasNextPage'] as bool,
        );
      }
    } finally {
      observable.close();
    }
  }

  @override
  Stream<Map<ProductionOrderStatus, int>> watchStatusCounts({
    DateRange? range,
  }) async* {
    final observable = _client.watchQuery(
      WatchQueryOptions(
        document: gql(productionOrderStatusCountsQuery),
        variables: {
          'createdFrom': range?.from?.toUtc().toIso8601String(),
          'createdTo': range?.to?.toUtc().toIso8601String(),
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
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
        final rows =
            result.data!['productionOrderStatusCounts'] as List<dynamic>;
        yield {
          for (final r in rows)
            ProductionOrderStatus.values
                    .firstWhere((s) => s.gql == (r as Map)['status']):
                r['count'] as int,
        };
      }
    } finally {
      observable.close();
    }
  }

  @override
  Future<ProductionOrder?> getDetails({required String id}) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(productionOrderDetailsQuery),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['productionOrder'] as Map<String, dynamic>?;

    if (data == null) return null;

    return ProductionOrder.fromDto(ProductionOrderDto.fromJson(data));
  }
}
