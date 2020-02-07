import 'package:get_it/get_it.dart';
import 'package:gloomhaven_enhancement_calc/core/services/characterList_service.dart';
import 'package:gloomhaven_enhancement_calc/core/services/database_helper.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/characterList_model.dart';
import 'package:gloomhaven_enhancement_calc/core/viewmodels/character_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // locator.registerLazySingleton(() => CharacterListService());
  locator.registerLazySingleton(() => DatabaseHelper());
  // locator.registerLazySingleton(() => CharacterListModel());
  // locator.registerLazySingleton(() => CharacterModel());

  // locator.registerFactory(() => DatabaseHelper());
  // locator.registerFactory(() => CharacterListService());
  locator.registerFactory(() => CharacterListModel());
  locator.registerFactory(() => CharacterModel());
}
