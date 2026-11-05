import 'package:elchemist_app/features/formula/data/formula_dto.dart';
import 'package:elchemist_app/features/formula/data/formula_query_strings.dart';
import 'package:elchemist_app/features/formula/domain/formula.dart';
import 'package:elchemist_app/features/formula/domain/formula_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FormulaRepositoryImpl implements FormulaRepository {
  final GraphQLClient _client;

  FormulaRepositoryImpl(this._client);

  @override
  Future<Formula?> getDetails({required String id}) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(formulaDetailsQuery),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['formula'] as Map<String, dynamic>?;

    if (data == null) return null;

    return Formula.fromDto(FormulaDto.fromJson(data));
  }
}
