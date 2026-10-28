const String mixBatchListPageQuery = r'''
  query MixBatches(
    $first: Int!
    $after: String
  ) {
    mixBatches(
      first: $first
      after: $after
    ) {
      totalCount
      pageInfo {
        hasPreviousPage
        hasNextPage 
        endCursor
      }
      edges {
        node {
          id
          mixNumber
          status
          batchCode
          mixedAt
          createdAt
          nicProfile {
            fullName
            isPreMix
          }
        }
      }
    }
  }
''';
