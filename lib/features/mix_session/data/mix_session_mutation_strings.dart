const String mixSessionCreateWithProductionOrdersMutation = r'''
  mutation CreateMixSession($productionOrderIdentifers: [ProductionOrderIdentifierInput!]!) {
    mixSessionCreateWithProductionOrders(
      productionOrderIdentifers: $productionOrderIdentifers
    ) {
      mixSession {
        id
      }
      feedback {
        status
        message
      }
    }
  }
''';

const String mixSessionMergeSessionsMutation = r'''
  mutation MergeMixSessions(
    $sourceIds: [MixSessionIdentifierInput!]!
    $targetId: ID!
  ) {
    mixSessionMerge(
      sourceIdentifiers: $sourceIds
      targetIdentifier: {id: $targetId}
    ) {
      feedback {
        message
        status
      }
      mixSession {
        id
        sessionNumber
      }
    }
  }
''';

const String mixSessionSetBatchVolumeMlMutation = r'''
  mutation SetMixSessionBatchVolumeMl(
    $id: ID!
    $volumeMl: Float!
  ) {
    mixSessionSetBatchVolumeMl(
      identifier: {id: $id}, 
      batchVolumeMl:$volumeMl
    ) {
      mixSession {
        id
        batchVolumeMl
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
              id
              slug
              isVg
              name
              ratio
            }
            nicBaseNicStr
            nicBasePg
            nicBaseVg
            nicBases {
              id
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
  }
''';
