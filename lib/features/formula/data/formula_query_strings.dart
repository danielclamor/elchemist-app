const String formulaDetailsQuery = r'''
  query Formula(
    $id: ID!
  ) {
    formula(
      identifier: {id: $id}
    ) {
      id
      slug
      name
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
      isOldMix
      isPreMix
      targetNicStr
      targetVg
      targetPg
      nicBaseNicStr
      flavorings {
        flavoringOption {
          id
          slug
          name
          isVg
        }
        ratio
      }
      nicBases {
        nicBaseOption {
          id
          code
          name
          isVg
        }
        ratio
      }
      nicBaseVg
      nicBasePg
    }
  }
''';

const String formulaListPageQuery = r'''
  query Formulas(
    $first: Int!
    $after: String
  ) {
    formulas(
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
''';
