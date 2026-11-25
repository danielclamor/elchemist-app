const String productionOrderListPageQuery = r'''
  query ProductionOrders(
    $first: Int!
    $after: String
    $status: ProductionOrderStatusEnum
    $createdFrom: DateTime
    $createdTo: DateTime
  ) {
    productionOrders(
      first: $first
      after: $after
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
          isPriority
          isCanceled
          isArchived
          createdAt
          eliquid { 
            id
            bottleSize 
            description
            formula {
              id
              name
              isPreMix
            }
          }
          mixSession {
            id
            sessionNumber
          }
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
      isPriority
      isCanceled
      isArchived
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
        flavor {
          id
        }
        formula {
          id
          name
          brand
          isPreMix
          nicLevel
          chillType
          nicType
          flavor {
            id
          }
        }
      }
      activityLogs {
        id
        newValue
        oldValue
        type
        triggeredAt
      }
      mixSession {
        id
        sessionNumber
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
            isPriority
            isCanceled
            isArchived
            createdAt
            eliquid { id description bottleSize }
            mixSession { id sessionNumber }
          }
        }
      }
    }
  }
''';

const String productionOrderAssignableToMixListPageQuery = r'''
  query ProductionOrdersAssignableToMix(
    $first: Int!
    $after: String
    $formulaId: ID!
  ) {
    productionOrdersAssignableToMix(
      first: $first
      after: $after
      formulaId: $formulaId
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
          isPriority
          isCanceled
          isArchived
          createdAt
          eliquid { 
            id
            bottleSize 
            description
            formula {
              id
              name
              isPreMix
            }
          }
          mixSession {
            id
            sessionNumber
          }
        }
      }
    }
  }
''';
