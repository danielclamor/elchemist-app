import 'package:elchemist_app/services/api_models.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink _httpLink = HttpLink('http://localhost:8000/graphql');

GraphQLClient get graphQLClient => GraphQLClient(
      link: _httpLink,
      cache: GraphQLCache(store: HiveStore()),
    );

class ApiService {
  Future<List<FormulaDto>> getFormulas() async {
    final QueryResult result = await graphQLClient.query(QueryOptions(
      document: gql(
        r'''
        query ReadFormulas {
          formulas {
            slug
            name
            brand
            chillType
            nicType
            nicProfiles {
              slug
              name
              targetVg
              targetPg
              nicBases {
                nicBaseOption {
                  code
                  name
                  isVg
                }
                ratio
              }
              fullName
              isNewMix
              nicBaseNicStr
              targetNicStr
              flavorings {
                isVg
                name
                ratio
              }
            }
          }
        }
        ''',
      ),
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    if (result.hasException) {
      throw result.exception!;
    }

    return (result.data?['formulas'] as List<dynamic>?)
            ?.map((formula) =>
                FormulaDto.fromJson(Map<String, dynamic>.from(formula as Map)))
            .toList() ??
        [];
  }

  Future<List<NicBaseOptionDto>> getNicBaseOptions() async {
    final QueryResult result = await graphQLClient.query(QueryOptions(
      document: gql(
        r'''
        query ReadNicBaseOptions {
          nicBaseOptions {
            code
            isVg
            name
          }
        }
        ''',
      ),
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    if (result.hasException) {
      throw result.exception!;
    }

    return (result.data?['nicBaseOptions'] as List<dynamic>?)
            ?.map((formula) => NicBaseOptionDto.fromJson(
                Map<String, dynamic>.from(formula as Map)))
            .toList() ??
        [];
  }
}
