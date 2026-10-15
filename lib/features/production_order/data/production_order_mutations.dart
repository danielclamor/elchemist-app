const String productionOrderCreateMutation = r'''
  mutation CreateProductionOrder(
    $eliquidId: ID,
    $productionOrder: ProductionOrderCreateInput!
  ) {
    productionOrderCreate (
      eliquidIdentifier: {id: $eliquidId},
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
        job
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
