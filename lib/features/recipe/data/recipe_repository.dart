import 'package:elchemist_app/features/recipe/data/recipe_diy_dto.dart';
import 'package:elchemist_app/features/recipe/data/recipe_dto.dart';
import 'package:elchemist_app/features/recipe/data/recipe_query_strings.dart';
import 'package:elchemist_app/features/recipe/domain/recipe.dart';
import 'package:elchemist_app/features/recipe/domain/recipe_diy.dart';
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

  @override
  Future<RecipeDiy?> getDiyDetails({
    required double batchVolumeMl,
    required double targetNicStr,
    required double targetPg,
    required double targetVg,
    required double nicBaseNicStr,
    required double nicBasePg,
    required double nicBaseVg,
    required List<dynamic> flavorings,
  }) async {
    final input = {
      'batchVolumeMl': batchVolumeMl,
      'targetNicStr': targetNicStr,
      'targetPg': targetPg,
      'targetVg': targetVg,
      'nicBaseNicStr': nicBaseNicStr,
      'nicBasePg': nicBasePg,
      'nicBaseVg': nicBaseVg,
      'flavorings': flavorings,
    };

    final result = await _client.query(
      QueryOptions(
        document: gql(recipeDiyQuery),
        variables: {
          'input': input,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['recipeDiy'] as Map<String, dynamic>?;

    if (data == null) return null;

    return RecipeDiy.fromDto(RecipeDiyDto.fromJson(data));
  }
}
