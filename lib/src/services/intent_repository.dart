part of 'services.dart';

class IntentRepository {
  // Singleton Pattern
  static final IntentRepository _intentRepository = IntentRepository._();
  factory IntentRepository() => _intentRepository;

  IntentRepository._();

  static final _navigationKey = GlobalKey<NavigatorState>();
  static const platform = MethodChannel('app.channel.shared.data');

  Future<void> handleIntent() async {
    final importUrl = await platform.invokeMethod('getImportUrl') as String?;
    if (importUrl != null) {
      _navigationKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (context) => RecipeImportScreen(importUrl),
        ),
        ModalRoute.withName('/'),
      );
    }
  }

  GlobalKey<NavigatorState> getNavigationKey() {
    return _navigationKey;
  }
}
