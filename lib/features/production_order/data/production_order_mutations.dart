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

const String productionOrderSetQuantity = r'''
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
