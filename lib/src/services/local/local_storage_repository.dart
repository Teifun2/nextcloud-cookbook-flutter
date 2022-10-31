import 'dart:convert';

import 'package:nextcloud_cookbook_flutter/src/services/local/timed_store_ref.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LocalStorageRepository {
  // Singleton
  LocalStorageRepository._();
  static final instance = LocalStorageRepository._();

  static final databaseFile = 'database.db';
  Database database;

  Future init() async {
    var documentsDir = await getApplicationDocumentsDirectory();
    await documentsDir.create(recursive: true);
    var databasePath = join(documentsDir.path, databaseFile);

    database = await databaseFactoryIo.openDatabase(databasePath);
  }

  var recipeStore = StoreRef<int, String>.main();

  Future storeRecipe(int id, TimedStoreRef<String> recipe) async {
    await recipeStore
        .record(id)
        .put(database, jsonEncode(recipe));
  }

  Future<TimedStoreRef<String>> loadRecipe(int id) async {
    var json = await recipeStore.record(id).get(database);
    if (json != null) {
      TimedStoreRef<String> recipe = TimedStoreRef.fromJson(jsonDecode(json));
      return recipe;
    } else {
      return null;
    }
  }
}
