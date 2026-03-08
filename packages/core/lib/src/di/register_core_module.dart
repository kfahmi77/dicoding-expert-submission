import 'package:core/common/pinned_http_client.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

void registerCoreModule(GetIt locator) {
  if (!locator.isRegistered<DatabaseHelper>()) {
    locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  }
  if (!locator.isRegistered<http.Client>()) {
    locator.registerSingletonAsync<http.Client>(createPinnedHttpClient);
  }
}
