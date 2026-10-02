const String productionOrderListPageQuery = r'''
  query ProductionOrders($first: Int!, $after: String, $status: ProductionOrderStatusEnum) {
    productionOrders(first: $first, after: $after, status: $status) {
      pageInfo { hasNextPage endCursor }
      edges {  
        node {
          id
          orderNumber
          orderedQuantity
          fulfilledQuantity
          status
          job
          isPriority
          createdAt
          eliquid { description }
        }
      }
    }
  }
''';

const productionOrderStatusCountsQuery = r'''
  query ProductionOrderStatusCounts {
    productionOrderStatusCounts { status count }
  }
''';

const String productionOrderDetailsQuery = r'''
  query ProductionOrder($id: ID!) {
    productionOrder(identifier: $id) {
      id
      orderNumber
      orderedQuantity
      fulfilledQuantity
      status
      job
      isPriority
      createdAt
      updatedAt
    }
  }
''';
