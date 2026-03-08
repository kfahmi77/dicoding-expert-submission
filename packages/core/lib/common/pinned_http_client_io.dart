import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

const _tmdbCertificateAssetPath = 'assets/developer.themoviedb.org.pem';

Future<http.Client> createPinnedHttpClient() async {
  final certificatePem = await rootBundle.loadString(_tmdbCertificateAssetPath);

  final securityContext = SecurityContext(withTrustedRoots: false)
    ..setTrustedCertificatesBytes(utf8.encode(certificatePem));

  final httpClient = HttpClient(context: securityContext)
    ..connectionTimeout = const Duration(seconds: 20);

  return IOClient(httpClient);
}
