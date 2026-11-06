import 'package:elchemist_app/features/recipe/data/recipe_dto.dart';
import 'package:elchemist_app/features/recipe/data/recipe_query_strings.dart';
import 'package:elchemist_app/features/recipe/domain/recipe.dart';
import 'package:elchemist_app/features/recipe/domain/recipe_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final GraphQLClient _client;

  RecipeRepositoryImpl(this._client);

  @override
  Future<Recipe?> getDetails({
    required String formulaId,
    required double batchVolumeMl,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(recipeQuery),
        variables: {
          'formulaId': formulaId,
          'batchVolumeMl': batchVolumeMl,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['recipe'] as Map<String, dynamic>?;

    if (data == null) return null;

    return Recipe.fromDto(RecipeDto.fromJson(data));
  }
}
