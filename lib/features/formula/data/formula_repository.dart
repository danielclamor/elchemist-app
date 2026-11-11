import 'package:elchemist_app/features/formula/data/formula_dto.dart';
import 'package:elchemist_app/features/formula/data/formula_query_strings.dart';
import 'package:elchemist_app/features/formula/domain/formula.dart';
import 'package:elchemist_app/features/formula/domain/formula_list_page.dart';
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

  @override
  Future<FormulaListPage> getListPage({
    required int first,
    String? after,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(formulaListPageQuery),
        variables: {
          'first': first,
          'after': after,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) throw result.exception!;

    final conn = result.data!['formulas'] as Map<String, dynamic>;
    final pageInfo = conn['pageInfo'] as Map<String, dynamic>;

    return FormulaListPage(
      items: (conn['edges'] as List<dynamic>)
          .map((e) => FormulaSummaryDto.fromJson(
              Map<String, dynamic>.from((e as Map)['node'] as Map)))
          .map((dto) => FormulaSummary.fromDto(dto))
          .toList(),
      endCursor: pageInfo['endCursor'] as String?,
      hasPreviousPage: pageInfo['hasPreviousPage'] as bool,
      hasNextPage: pageInfo['hasNextPage'] as bool,
      totalCount: conn['totalCount'] as int,
    );
  }
}
