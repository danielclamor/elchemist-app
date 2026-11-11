const String mixSessionListPageQuery = r'''
  query MixSessions(
    $first: Int!
    $after: String
  ) {
    mixSessions(
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
          sessionNumber
          status
          batchCode
          mixedAt
          createdAt
          formula {
            name
            isPreMix
          }
        }
      }
    }
  }
''';

const String mixSessionDetailsQuery = r'''
  query MixSession($id: ID!) {
    mixSession(
      identifier: {id: $id}
    ) {
      id
      sessionNumber
      status
      batchCode
      mixedAt
      createdAt
      totalVolumeMl
      formula {
        id
        slug
        name
        nicLevel
        brand
        chillType
        nicType
        isOldMix
        isPreMix
        targetNicStr
        targetVg
        targetPg
        nicBaseNicStr
        flavorings {
          flavoringOption {
            id
            slug
            name
            isVg
          }
          ratio
        }
        nicBases {
          nicBaseOption {
            id
            code
            name
            isVg
          }
          ratio
        }
        nicBaseVg
        nicBasePg
      }
      productionOrders {
        id
        orderNumber
        orderedQuantity
        fulfilledQuantity
        status
        isPriority
        createdAt
        eliquid { 
          id
          bottleSize 
          description 
        }
      }
    }
  }
''';
