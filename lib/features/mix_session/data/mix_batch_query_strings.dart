const String mixBatchListPageQuery = r'''
  query MixBatches(
    $first: Int!
    $after: String
  ) {
    mixBatches(
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
          mixNumber
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

const String mixBatchDetailsQuery = r'''
  query MixBatch($id: ID!) {
    mixBatch(
      identifier: {id: $id}
    ) {
      id
      mixNumber
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
