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
            fullName
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
        fullName
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
        flavor {
          id
          brand
          name
          chillType
          nicType
        }
      }
      productionOrders {
        id
        orderNumber
        orderedQuantity
        fulfilledQuantity
        status
        jobType
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
