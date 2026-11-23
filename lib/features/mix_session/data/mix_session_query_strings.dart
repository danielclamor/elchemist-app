const String mixSessionListPageQuery = r'''
  query MixSessions(
    $first: Int!
    $after: String
    $formulaIdentifier: FormulaIdentifierInput
  ) {
    mixSessions(
      first: $first
      after: $after
      formulaIdentifier: $formulaIdentifier
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
          isArchived
          mixedAt
          createdAt
          formula {
            id
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
      isArchived
      mixedAt
      createdAt
      batchVolumeMl
      totalOrdersVolumeMl
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
        isCanceled
        isArchived
        createdAt
        eliquid { 
          id
          bottleSize 
          description 
        }
      }
      recipe {
        ingredients {
          name
          ratio
          volumeMl
          weightG
        }
        totalRatio
        totalVolumeMl
        totalWeightG
        mixParameters {
          batchVolumeMl
          flavorings {
            isVg
            name
            ratio
          }
          nicBaseNicStr
          nicBasePg
          nicBaseVg
          nicBases {
            code
            isVg
            name
            ratio
          }
          targetNicStr
          targetPg
          targetVg
        }
      }
    }
  }
''';
