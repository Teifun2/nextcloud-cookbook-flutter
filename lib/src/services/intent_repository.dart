import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_import_screen.dart';

class IntentRepository {
  // Singleton Pattern
  static final IntentRepository _intentRepository = IntentRepository._();
  factory IntentRepository() => _intentRepository;

  IntentRepository._();

  static final _navigationKey = new GlobalKey<NavigatorState>();
  static const platform = MethodChannel('app.channel.shared.data');

  void handleIntent() async {
    var importUrl = await platform.invokeMethod('getImportUrl');
    if (importUrl != null) {
      _navigationKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute<void>(
              builder: (BuildContext context) => () {
                    return RecipeImportScreen(importUrl);
                  }()),
          ModalRoute.withName('/'));
    }
  }

  GlobalKey<NavigatorState> getNavigationKey() {
    return _navigationKey;
  }
}
