import 'package:elchemist_app/core/graphql/graphql_client.dart';
import 'package:elchemist_app/features/recipe/data/recipe_repository.dart';
import 'package:elchemist_app/features/recipe/domain/recipe.dart';
import 'package:elchemist_app/features/recipe/domain/recipe_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef RecipeInput = ({
  String formulaId,
  double batchVolumeMl,
});

final recipeRepositoryProvider = Provider<RecipeRepository>(
  (ref) => RecipeRepositoryImpl(ref.watch(graphQLClientProvider)),
);

final recipeDetailsProvider =
    FutureProvider.autoDispose.family<Recipe?, String>(
  (ref, formulaId) {
    final batchVolumeMl = ref.watch(mixBatchVolumeMlValueProvider);

    return ref.watch(recipeRepositoryProvider).getDetails(
          formulaId: formulaId,
          batchVolumeMl: batchVolumeMl,
        );
  },
  retry: (retryCount, error) => null,
);
