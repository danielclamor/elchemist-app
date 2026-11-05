import 'package:elchemist_app/core/graphql/graphql_client.dart';
import 'package:elchemist_app/features/formula/data/formula_repository.dart';
import 'package:elchemist_app/features/formula/domain/formula.dart';
import 'package:elchemist_app/features/formula/domain/formula_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formulaRepositoryProvider = Provider<FormulaRepository>(
  (ref) => FormulaRepositoryImpl(ref.watch(graphQLClientProvider)),
);

final formulaDetailsProvider =
    FutureProvider.autoDispose.family<Formula?, String>(
  (ref, id) => ref.watch(formulaRepositoryProvider).getDetails(id: id),
  retry: (retryCount, error) => null,
);
