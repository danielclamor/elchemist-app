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
          upc
          description
          flavor {
            brand
          }
          formula {
            id
            name
            isPreMix
            nicLevel
            flavor {
              id
              slug
              name
              brand
              chillType
              nicType
              createdAt
              updatedAt
            }
          }
        }
      }
    }
  }
''';
