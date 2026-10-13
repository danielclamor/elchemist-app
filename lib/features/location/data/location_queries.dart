const String locationSummaryListPageQuery = r'''
  query Locations(
    $first: Int!,
    $after: String,
  ) {
    locations(
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
          code
          name
          isHq
        }
      }
    }
  }
''';
