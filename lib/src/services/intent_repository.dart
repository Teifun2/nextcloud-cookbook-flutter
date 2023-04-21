part of 'services.dart';

class IntentRepository {
  factory IntentRepository() =>
      _intentRepository ??= const IntentRepository._();

  // coverage:ignore-start
  @visibleForTesting
  factory IntentRepository.mocked(IntentRepository mock) =>
      _intentRepository ??= mock;
  // coverage:ignore-end

  const IntentRepository._();
  // Singleton Pattern
  static IntentRepository? _intentRepository;

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
