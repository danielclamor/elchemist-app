const recipeQuery = r'''
query Recipe (
  $formulaId: ID!
  $batchVolumeMl: Float!
) {
  recipe(
    formulaIdentifier: {id: $formulaId}
    input: {batchVolumeMl: $batchVolumeMl}
  ) {
    formula {
      slug
      fullName
    }
    ingredients {
      name
      ratio
      volumeMl
      weightG
    }
    totalRatio
    totalVolumeMl
    totalWeightG
    mixParameters {
      batchVolumeMl
      flavorings {
        isVg
        name
        ratio
      }
      nicBaseNicStr
      nicBases {
        code
        isVg
        name
        ratio
      }
      targetNicStr
      targetPg
      targetVg
    }
  }
}
''';
