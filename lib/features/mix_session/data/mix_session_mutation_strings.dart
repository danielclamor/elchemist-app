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
