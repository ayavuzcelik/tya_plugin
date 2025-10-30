import 'flutter_tya_plugin_platform_interface.dart';

class FlutterTyaPlugin {
  // 1. STATİK VE SABİT BİR 'INSTANCE' (ÖRNEK) OLUŞTUR
  // Bu, tüm uygulama boyunca kullanılacak tek örnektir.
  static final FlutterTyaPlugin instance = FlutterTyaPlugin._internal();

  // 2. ÖZEL (PRIVATE) BİR CONSTRUCTOR OLUŞTUR
  // '_' ile başlayan constructor, bu sınıfın dışarıdan
  // 'FlutterTyaPlugin()' şeklinde çağrılarak yeni bir örneğinin
  // oluşturulmasını engeller.
  FlutterTyaPlugin._internal();

  /// Get platform version (for testing)
  Future<String?> getPlatformVersion() {
    return FlutterTyaPluginPlatform.instance.getPlatformVersion();
  }

  /// Initialize Tuya/Thing SDK
  Future<bool> initSdk({
    required String appKey,
    required String appSecret,
    bool isDebug = false,
  }) {
    return FlutterTyaPluginPlatform.instance.initSdk(
      appKey: appKey,
      appSecret: appSecret,
      isDebug: isDebug,
    );
  }

  Future<bool> sendBindVerifyCodeWithEmail(
    String countryCode,
    String email,
  ) async {
    final result = await FlutterTyaPluginPlatform.instance
        .sendBindVerifyCodeWithEmail(countryCode, email);
    return result;
  }

  Future<bool> registerAccountWithEmail(
    String countryCode,
    String email,
    String password,
    String code,
  ) async {
    final result = await FlutterTyaPluginPlatform.instance
        .registerAccountWithEmail(countryCode, email, password, code);
    return result == true;
  }

  Future<bool> loginWithEmail(
    String countryCode,
    String email,
    String password,
  ) async {
    final result = await FlutterTyaPluginPlatform.instance.loginWithEmail(
      countryCode,
      email,
      password,
    );
    return result == true;
  }

  /// Login or register user with UID
  Future<void> loginOrRegisterWithUid({
    required String countryCode,
    required String uid,
    required String password,
  }) async {
    final result = await FlutterTyaPluginPlatform.instance
        .loginOrRegisterWithUid(
          countryCode: countryCode,
          uid: uid,
          password: password,
        );
    return result;
  }

  /// Query all homes
  Future<List<Map<String, dynamic>>> queryHomeList() async {
    final result = await FlutterTyaPluginPlatform.instance.queryHomeList();
    return result;
  }

  /// Create new home
  Future<int?> createHome({
    required String name,
    required double latitude,
    required double longitude,
    required String geoName,
    List<String>? rooms,
  }) async {
    final result = await FlutterTyaPluginPlatform.instance.createHome(
      name: name,
      latitude: latitude,
      longitude: longitude,
      geoName: geoName,
      rooms: rooms,
    );
    return result;
  }

  /// Delete all homes
  Future<bool> deleteAllHomes() async {
    final result = await FlutterTyaPluginPlatform.instance.deleteAllHomes();
    return result;
  }

  /// Get device list for a home
  Future<List<Map<String, dynamic>>> getDeviceList(int homeId) async {
    final result = await FlutterTyaPluginPlatform.instance.getDeviceList(
      homeId,
    );
    return result;
  }

  /// Subscribe all events
  Stream<dynamic> subscribeToEvents() {
    return FlutterTyaPluginPlatform.instance.subscribeToEvents();
  }

  /// Get Activator Token
  Future<String?> getActivatorToken() async {
    final result = await FlutterTyaPluginPlatform.instance.getActivatorToken();
    return result;
  }

  Future<bool> qrActivator({
    required String ssid,
    required String password,
    required String token,
  }) async {
    final started = await FlutterTyaPluginPlatform.instance.qrActivator(
      ssid: ssid,
      password: password,
      token: token,
    );
    return started;
  }

  /// Set log level for debugging
  Future<void> setLogLevel(int levelIndex) {
    return FlutterTyaPluginPlatform.instance.setLogLevel(levelIndex);
  }
}
