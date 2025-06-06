import 'package:get_it/get_it.dart';
import 'domain/liked_cats_provider.dart';
import 'data/liked_cats_storage.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<LikedCatsStorage>(() => LikedCatsStorage());
  getIt.registerSingleton<LikedCatsNotifier>(
    LikedCatsNotifier(getIt<LikedCatsStorage>()),
  );
}