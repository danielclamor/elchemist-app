const String mixSessionCreateWithProductionOrdersMutation = r'''
  mutation CreateMixSession($productionOrderIdentifers: [ProductionOrderIdentifierInput!]!) {
    mixSessionCreateWithProductionOrders(
      productionOrderIdentifers: $productionOrderIdentifers
    ) {
      mixSession {
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
      feedback {
        status
        message
      }
    }
  }
''';
