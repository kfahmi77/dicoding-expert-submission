import 'package:http/http.dart' as http;

import 'pinned_http_client_stub.dart'
    if (dart.library.io) 'pinned_http_client_io.dart'
    as impl;

Future<http.Client> createPinnedHttpClient() => impl.createPinnedHttpClient();
