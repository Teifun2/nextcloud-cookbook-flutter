import 'dart:convert';
import 'dart:io';

import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
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
    try {
      var documentsDir = await getApplicationDocumentsDirectory();
      await documentsDir.create(recursive: true);
      var databasePath = join(documentsDir.path, databaseFile);

      database = await databaseFactoryIo.openDatabase(databasePath);
    } catch (_) {
      stderr.writeln(_.toString());
    }
  }

  var recipeStore = StoreRef<int, String>.main();

  Future storeRecipe(int id, Recipe recipe) async {
    try {
      await recipeStore
          .record(id)
          .put(database, jsonEncode(TimedStoreRef(recipe)));
    } catch (_) {
      stderr.writeln(_.toString());
    }
  }

  Future<TimedStoreRef<Recipe>> loadRecipe(int id) async {
    try {
      var json = await recipeStore.record(id).get(database);
      if (json != null) {
        return TimedStoreRef.fromJson(jsonDecode(json), Recipe.fromJson);
      }
      return TimedStoreRef(null);
    } catch (_) {
      stderr.writeln(_.toString());
      return TimedStoreRef(null);
    }
  }
}
