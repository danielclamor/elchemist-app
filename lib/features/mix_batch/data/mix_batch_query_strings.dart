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

const String mixBatchDetailsQuery = r'''
  query MixBatch($id: ID!) {
    mixBatch(
      identifier: {id: $id}
    ) {
      id
      mixNumber
      status
      batchCode
      mixedAt
      createdAt
      totalVolumeMl
      nicProfile {
        id
        name
        fullName
        isPreMix
        formula {
          id
          brand
          name
          chillType
          nicType
        }
      }
    }
  }
''';
