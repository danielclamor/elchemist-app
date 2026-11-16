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
