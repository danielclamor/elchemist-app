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
      brand
      chillType
      nicType
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
