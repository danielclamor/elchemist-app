const String productionOrderListPageQuery = r'''
  query ProductionOrders(
    $first: Int!
    $after: String
    $jobType: ProductionOrderJobTypeEnum
    $status: ProductionOrderStatusEnum
    $createdFrom: DateTime
    $createdTo: DateTime
  ) {
    productionOrders(
      first: $first
      after: $after
      jobType: $jobType
      status: $status
      createdFrom: $createdFrom
      createdTo: $createdTo
    ) {
      totalCount
      pageInfo {
        hasPreviousPage
        hasNextPage 
        endCursor
      }
      edges {  
        node {
          id
          orderNumber
          orderedQuantity
          fulfilledQuantity
          status
          jobType
          isPriority
          createdAt
          eliquid { description }
        }
      }
    }
  }
''';

const String productionOrderStatusCountsQuery = r'''
  query ProductionOrderStatusCounts(
    $createdFrom: DateTime
    $createdTo: DateTime
  ) {
    productionOrderStatusCounts(
      createdFrom: $createdFrom
      createdTo: $createdTo
    ) { status count }
  }
''';

const String productionOrderDetailsQuery = r'''
  query ProductionOrder($id: ID!) {
    productionOrder(identifier: {id: $id}) {
      id
      orderNumber
      orderedQuantity
      fulfilledQuantity
      status
      jobType
      isPriority
      isOpen
      createdAt
      updatedAt
      allocations { 
        id 
        quantity 
        location { id code name isHq }
      }
      eliquid {
        id
        upc
        description
        brand
      }
      activityLogs {
        id
        newValue
        oldValue
        type
        triggeredAt
      }
    }
  }
''';

const String eliquidPastOrdersQuery = r'''
  query EliquidPastOrders(
    $id: ID!
    $first: Int! 
    $after: String
  ) {
    eliquid(identifier: {id: $id}) {
      productionOrders(
        first: $first
        after: $after
      ) {
        totalCount
        pageInfo {
          hasPreviousPage
          hasNextPage
          endCursor
        }
        edges {  
          node {
            id
            orderNumber
            orderedQuantity
            fulfilledQuantity
            status
            jobType
            isPriority
            createdAt
            eliquid { description }
          }
        }
      }
    }
  }
''';
