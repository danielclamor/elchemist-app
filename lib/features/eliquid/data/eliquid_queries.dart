const String eliquidListPageQuery = r'''
  query Eliquids(
    $first: Int!,
    $after: String,
  ) {
    eliquids(
      first: $first,
      after: $after,
    ) {
      pageInfo {
        hasPreviousPage
        hasNextPage
        endCursor
      }
      edges {
        node {
          id
          sku
          description
          brand
          flavor {
            id
          }
          formula {
            id
            name
            isPreMix
            nicLevel
            brand
            chillType
            nicType
            flavor {
              id
            }
          }
        }
      }
    }
  }
''';
