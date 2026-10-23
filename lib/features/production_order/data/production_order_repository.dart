import 'package:elchemist_app/features/production_order/data/production_order_mutations.dart';
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
    ProductionOrderJobType? jobType,
    ProductionOrderStatus? status,
    DateRange? range,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(productionOrderListPageQuery),
        variables: {
          'first': first,
          'after': after,
          'jobType': jobType?.gql,
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
      totalCount: conn['totalCount'] as int,
    );
  }

  @override
  Stream<ProductionOrderListPage> watchListPage({
    required int first,
    String? after,
    ProductionOrderJobType? jobType,
    ProductionOrderStatus? status,
    DateRange? range,
  }) async* {
    final observable = _client.watchQuery(
      WatchQueryOptions(
        document: gql(productionOrderListPageQuery),
        variables: {
          'first': first,
          'after': after,
          'jobType': jobType?.gql,
          'status': status?.gql,
          'createdFrom': range?.from?.toUtc().toIso8601String(),
          'createdTo': range?.to?.toUtc().toIso8601String(),
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
          totalCount: conn['totalCount'] as int,
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

  @override
  Future<ProductionOrderListPage> getEliquidPastOrdersPage({
    required String eliquidId,
    required int first,
    String? after,
  }) async {
    final result = await _client.query(QueryOptions(
      document: gql(eliquidPastOrdersQuery),
      variables: {
        'id': eliquidId,
        'first': first,
        'after': after,
      },
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    if (result.hasException) throw result.exception!;

    final eliquid = result.data?['eliquid'] as Map<String, dynamic>?;
    if (eliquid == null) throw Exception('Eliquid not found');

    final conn = eliquid['productionOrders'] as Map<String, dynamic>;
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
      totalCount: conn['totalCount'] as int,
    );
  }

  @override
  Future<ProductionOrder> createOrder({
    required String eliquidId,
    int? quantity,
    required bool isPriority,
    required List<AllocationInput> allocations,
    ProductionOrderJobType? jobType,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(productionOrderCreateMutation),
        variables: {
          'eliquidId': eliquidId,
          'productionOrder': {
            'quantity': quantity,
            'isPriority': isPriority,
            'allocations': allocations
                .map((a) => {
                      'locationIdentifier': {'id': a.locationId},
                      'quantity': a.quantity
                    })
                .toList(),
            'jobType': jobType?.gql,
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;

    final payload =
        result.data?['productionOrderCreate'] as Map<String, dynamic>?;
    final feedback = payload?['feedback'] as Map<String, dynamic>?;
    final data = payload?['productionOrder'] as Map<String, dynamic>?;

    if (data == null || feedback?['status'] != 'SUCCESS') {
      throw Exception(
        feedback?['message'] as String? ?? 'Could not create the order',
      );
    }

    return ProductionOrder.fromDto(ProductionOrderDto.fromJson(data));
  }

  @override
  Future<JobId> assignJob({
    required String id,
    int? orderedQuantity,
    required ProductionOrderJobType jobType,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(productionOrderAssignJobMutation),
        variables: {
          'id': id,
          'orderedQuantity': orderedQuantity,
          'jobType': jobType.gql,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;

    final payload =
        result.data?['productionOrderAssignJob'] as Map<String, dynamic>?;
    final feedback = payload?['feedback'] as Map<String, dynamic>?;
    final data = payload?['createdProductionOrderJob'] as Map<String, dynamic>?;

    if (data == null || feedback?['status'] != 'SUCCESS') {
      throw Exception(
        feedback?['message'] as String? ??
            'Could not assign the order to $jobType',
      );
    }

    return data['id'];
  }

  @override
  Future<void> setOrderedQuantity({
    required String id,
    required int? orderedQuantity,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(productionOrderSetQuantityMutation),
        variables: {
          'id': id,
          'orderedQuantity': orderedQuantity,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;

    final payload = result.data?['productionOrderSetOrderedQuantity']
        as Map<String, dynamic>?;
    final feedback = payload?['feedback'] as Map<String, dynamic>?;
    final data = payload?['productionOrder'] as Map<String, dynamic>?;

    if (data == null || feedback?['status'] != 'SUCCESS') {
      throw Exception(
        feedback?['message'] as String? ??
            'Could not set the order $id ordered quantity to $orderedQuantity',
      );
    }

    return;
  }

  @override
  Future<void> deleteOrder({required String id}) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(productionOrderDeleteMutation),
        variables: {
          'id': id,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;

    final payload =
        result.data?['productionOrderDelete'] as Map<String, dynamic>?;
    final feedback = payload?['feedback'] as Map<String, dynamic>?;
    final data = payload?['deletedOrderNumber'] as String?;

    if (data == null || feedback?['status'] != 'SUCCESS') {
      throw Exception(
        feedback?['message'] as String? ?? 'Could not delete order $id',
      );
    }

    return;
  }

  @override
  Future<void> markCancelled({required String id}) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(productionOrderMarkCancelledMutation),
        variables: {
          'id': id,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;

    final payload =
        result.data?['productionOrderMarkCancelled'] as Map<String, dynamic>?;
    final feedback = payload?['feedback'] as Map<String, dynamic>?;
    final data = payload?['productionOrder'] as String?;

    if (data == null || feedback?['status'] != 'SUCCESS') {
      throw Exception(
        feedback?['message'] as String? ?? 'Could not cancel order $id',
      );
    }

    return;
  }
}
