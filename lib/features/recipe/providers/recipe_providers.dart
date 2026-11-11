import 'package:elchemist_app/core/graphql/graphql_client.dart';
import 'package:elchemist_app/features/diy_mix/providers/diy_mix_providers.dart';
import 'package:elchemist_app/features/mix_session/providers/mix_session_providers.dart';
import 'package:elchemist_app/features/recipe/data/recipe_repository.dart';
import 'package:elchemist_app/features/recipe/domain/recipe.dart';
import 'package:elchemist_app/features/recipe/domain/recipe_diy.dart';
import 'package:elchemist_app/features/recipe/domain/recipe_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>(
  (ref) => RecipeRepositoryImpl(ref.watch(graphQLClientProvider)),
);

final recipeDetailsProvider =
    FutureProvider.autoDispose.family<Recipe?, String>(
  (ref, formulaId) {
    final batchVolumeMl = ref.watch(mixSessionVolumeMlValueProvider);

    return ref.watch(recipeRepositoryProvider).getDetails(
          formulaId: formulaId,
          batchVolumeMl: batchVolumeMl,
        );
  },
  retry: (retryCount, error) => null,
);

final recipeDiyDetailsProvider = FutureProvider<RecipeDiy?>(
  (ref) {
    final batchVolumeMl = ref.watch(diyMixVolumeMlValueProvider);
    final nicBaseNicStr = ref.watch(diyMixNicBaseNicStrPercProvider) / 100;
    final nicBaseVg = ref.watch(diyMixNicBaseVgPercProvider) / 100;
    final nicBasePg = ref.watch(diyMixNicBasePgPercProvider) / 100;
    final targetNicStr = ref.watch(diyMixTargetNicStrPercProvider) / 100;
    final targetVg = ref.watch(diyMixTargetVgPercProvider) / 100;
    final targetPg = ref.watch(diyMixTargetPgPercProvider) / 100;
    final flavorings = ref
        .watch(diyMixFlavoringEntriesProvider)
        .where((f) =>
            f.percentage > 0) // empty or zero rows aren't part of the recipe
        .map((f) => {
              'name': f.name,
              "ratio": f.percentage / 100,
              "isVg": f.isVg,
            })
        .toList();

    return ref.watch(recipeRepositoryProvider).getDiyDetails(
          batchVolumeMl: batchVolumeMl,
          nicBaseNicStr: nicBaseNicStr,
          nicBaseVg: nicBaseVg,
          nicBasePg: nicBasePg,
          targetNicStr: targetNicStr,
          targetVg: targetVg,
          targetPg: targetPg,
          flavorings: flavorings,
        );
  },
  retry: (retryCount, error) => null,
);
