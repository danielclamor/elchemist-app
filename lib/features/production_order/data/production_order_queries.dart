const String productionOrderListPageQuery = r'''
  query ProductionOrders($first: Int!, $after: String) {
    productionOrders(first: $first, after: $after) {
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
