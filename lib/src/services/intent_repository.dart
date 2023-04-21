part of 'services.dart';

class IntentRepository {
  factory IntentRepository() => _intentRepository;

  IntentRepository._();
  // Singleton Pattern
  static final IntentRepository _intentRepository = IntentRepository._();

  static final _navigationKey = GlobalKey<NavigatorState>();
  static const platform = MethodChannel('app.channel.shared.data');

  Future<void> handleIntent() async {
    final importUrl = await platform.invokeMethod('getImportUrl') as String?;
    if (importUrl != null) {
      await _navigationKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (context) => RecipeImportScreen(importUrl: importUrl),
        ),
        ModalRoute.withName('/'),
      );
    }
  }

  GlobalKey<NavigatorState> getNavigationKey() => _navigationKey;
}
