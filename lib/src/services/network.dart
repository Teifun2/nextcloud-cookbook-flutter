part of 'services.dart';

class Network {
  static final Network _network = Network._();

  factory Network() => _network;

  Network._();

  /// Try to load file from locale cache first, if not available get it from the server
  Future<String> get(String url) async {
    final AppAuthentication appAuthentication =
        UserRepository().currentAppAuthentication;

    final FileInfo file = await DefaultCacheManager().getFileFromCache(url) ??
        // Download, if not available
        await CustomCacheManager().getInstance().downloadFile(
          url,
          authHeaders: {
            "Authorization": appAuthentication.basicAuth,
          },
        );

    final String contents = await file.file.readAsString();
    return contents;
  }
}
