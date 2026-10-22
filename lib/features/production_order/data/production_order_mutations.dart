const String productionOrderCreateMutation = r'''
  mutation CreateProductionOrder(
    $eliquidId: ID
    $productionOrder: ProductionOrderCreateInput!
  ) {
    productionOrderCreate (
      eliquidIdentifier: {id: $eliquidId}
      productionOrder: $productionOrder
    ) {
      feedback {
        message
        status
      }
      productionOrder {
        id
        orderNumber
        orderedQuantity
        fulfilledQuantity
        status
        jobType
        isPriority
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
  }
''';

const String productionOrderAssignJobMutation = r'''
  mutation AssignProductionOrderToJob(
    $id: ID!
    $orderedQuantity: Int
    $jobType: ProductionOrderJobTypeEnum!
  ) {
  productionOrderAssignJob (
    identifier: {id: $id}
    orderedQuantity: $orderedQuantity
    jobType: $jobType
  ) {
    productionOrder {
      jobType
    }
    createdProductionOrderJob {
      ... on MixJobType {
        id
      }
      ... on RepatJobType {
        id
      }
    }
    feedback {
      message
      status
    }
  }
}
''';

const String productionOrderSetQuantityMutation = r'''
  mutation SetProductionOrderQuantity(
    $id: ID!
    $orderedQuantity: Int!
  ) {
    productionOrderSetOrderedQuantity(
      identifier: {id: $id}
      orderedQuantity: $orderedQuantity
    ) {
      productionOrder {
        id
        orderedQuantity
      }
      feedback {
        message
        status
      }
    }
  }
''';

const String productionOrderDeleteMutation = r'''
  mutation DeleteProductionOrder(
    $id: ID!
  ) {
    productionOrderDelete(
      identifier: {id: $id}
    ) {
      deletedOrderNumber
      feedback {
        message
        status
      }
    }
  }
''';

const String productionOrderMarkCancelledMutation = r'''
  mutation CancelProductionOrder($id: ID!) {
    productionOrderMarkCancelled(identifier: {id: $id}) {
      productionOrder {
        id
        status
      }
      feedback {
        status
        message
      }
    }
  }
''';
