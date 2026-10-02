import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String _defaultEndpoint() {
  if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8000/graphql';
  return 'http://localhost:8000/graphql';
}

final graphQLEndpointProvider = Provider<String>((ref) => _defaultEndpoint());

final graphQLClientProvider = Provider<GraphQLClient>((ref) {
  final link = HttpLink(ref.watch(graphQLEndpointProvider));

  return GraphQLClient(
    link: link,
    cache: GraphQLCache(store: HiveStore()),
  );
});
