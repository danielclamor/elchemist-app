const nicBaseOptionListPageQuery = r'''
  query NicBaseOptions(
    $first: Int!
    $after: String
  ) {
    nicBaseOptions(
      first: $first
      after: $after
    ) {
      code
      name
      isVg
    }
  }
''';
