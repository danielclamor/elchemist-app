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
          brand
          formula {
            id
            name
            fullName
            isPreMix
            flavor {
              id
              brand
              name
              chillType
              nicType
            }
          }
        }
      }
    }
  }
''';
