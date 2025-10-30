import 'package:flutter_tya_plugin/models/tuya_device_model.dart';
import 'package:flutter_tya_plugin/models/tuya_home_model.dart';
import 'package:flutter_tya_plugin/models/tuya_user_model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_tya_plugin_method_channel.dart';

abstract class FlutterTyaPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterTyaPluginPlatform.
  FlutterTyaPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTyaPluginPlatform _instance = MethodChannelFlutterTyaPlugin();

  /// The default instance of [FlutterTyaPluginPlatform] to use.
  /// Defaults to [MethodChannelFlutterTyaPlugin].
  static FlutterTyaPluginPlatform get instance => _instance;

  static set instance(FlutterTyaPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Platform version (example)
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  /// Initialize Thing SDK
  Future<bool> initSdk({
    required String appKey,
    required String appSecret,
    bool isDebug = false,
  }) {
    throw UnimplementedError('initSdk() has not been implemented.');
  }

  /// Login or register with UID
  Future<TuyaUserModel?> loginOrRegisterWithUid({
    required String countryCode,
    required String uid,
    required String password,
  }) {
    throw UnimplementedError(
      'loginOrRegisterWithUid() has not been implemented.',
    );
  }

  /// Query home list
  Future<List<TuyaHomeModel>?> queryHomeList() {
    throw UnimplementedError('queryHomeList() has not been implemented.');
  }

  /// Create a new home
  Future<TuyaHomeModel?> createHome({
    required String name,
    required double latitude,
    required double longitude,
    required String geoName,
    List<String>? rooms,
  }) {
    throw UnimplementedError('createHome() has not been implemented.');
  }

  /// Get device list for a home
  Future<List<TuyaDeviceModel>?> getDeviceList(int homeId) {
    throw UnimplementedError('getDeviceList() has not been implemented.');
  }

  Stream<dynamic> subscribeToEvents() {
    throw UnimplementedError('subscribeToEvents() has not been implemented.');
  }

  Future<String?> getActivatorToken(int homeId) {
    throw UnimplementedError('getActivatorToken() has not been implemented.');
  }

  Future<bool> qrActivator({
    required String ssid,
    required String password,
    required String token,
  }) {
    throw UnimplementedError('qrActivator() has not been implemented.');
  }

  /// Set log level (DEBUG, INFO, etc.)
  Future<void> setLogLevel(int levelIndex) {
    throw UnimplementedError('setLogLevel() has not been implemented.');
  }
}
