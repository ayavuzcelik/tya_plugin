import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'flutter_tya_plugin_platform_interface.dart';

class MethodChannelFlutterTyaPlugin extends FlutterTyaPluginPlatform {
  @visibleForTesting
  final MethodChannel _methodChannel = const MethodChannel(
    'flutter_tya_plugin/methods',
  );
  final EventChannel _eventChannel = const EventChannel(
    'flutter_tya_plugin/events',
  );

  /// Platform version example
  @override
  Future<String?> getPlatformVersion() async {
    final version = await _methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  /// SDK init
  @override
  Future<bool> initSdk({
    required String appKey,
    required String appSecret,
    bool isDebug = false,
  }) async {
    final result = await _methodChannel.invokeMethod<bool>('initSdk', {
      'appKey': appKey,
      'appSecret': appSecret,
      'isDebug': isDebug,
    });
    return result ?? false;
  }

  @override
  Future<bool> sendBindVerifyCodeWithEmail(
    String countryCode,
    String email,
  ) async {
    final result = await _methodChannel.invokeMethod<bool>(
      "sendBindVerifyCodeWithEmail",
      {'countryCode': countryCode, 'email': email},
    );
    return result ?? false;
  }

  @override
  Future<bool> registerAccountWithEmail(
    String countryCode,
    String email,
    String password,
    String code,
  ) async {
    final result = await _methodChannel.invokeMethod<bool>(
      "registerAccountWithEmail",
      {
        'countryCode': countryCode,
        'email': email,
        'password': password,
        'code': code,
      },
    );
    return result == true;
  }

  @override
  Future<bool> loginWithEmail(
    String countryCode,
    String email,
    String password,
  ) async {
    final result = await _methodChannel.invokeMethod<bool>("loginWithEmail", {
      'countryCode': countryCode,
      'email': email,
      'password': password,
    });
    return result == true;
  }

  /// Login or register with UID
  @override
  Future<void> loginOrRegisterWithUid({
    required String countryCode,
    required String uid,
    required String password,
  }) async {
    await _methodChannel.invokeMethod('loginOrRegisterWithUid', {
      'countryCode': countryCode,
      'uid': uid,
      'password': password,
    });
  }

  /// Query home list
  @override
  Future<List<Map<String, dynamic>>> queryHomeList() async {
    final result = await _methodChannel.invokeMethod('queryHomeList');
    if (result is List) {
      return result.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  /// Create new home
  @override
  Future<int?> createHome({
    required String name,
    required double latitude,
    required double longitude,
    required String geoName,
    List<String>? rooms,
  }) async {
    final result = await _methodChannel.invokeMethod('createHome', {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'geoName': geoName,
      'rooms': rooms ?? [],
    });
    return result is int ? result : null;
  }

  /// Delete all homes
  @override
  Future<bool> deleteAllHomes() async {
    final result = await _methodChannel.invokeMethod<bool>('deleteAllHomes');
    return result ?? false;
  }

  /// Get device list for a home
  @override
  Future<List<Map<String, dynamic>>> getDeviceList(int homeId) async {
    final result = await _methodChannel.invokeMethod('getDeviceList', {
      'homeId': homeId,
    });
    if (result is List) {
      return result.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  @override
  Stream<dynamic> subscribeToEvents() {
    return _eventChannel.receiveBroadcastStream();
  }

  @override
  Future<String?> getActivatorToken() async {
    final token = await _methodChannel.invokeMethod<String>(
      'getActivatorToken',
    );
    return token;
  }

  @override
  Future<bool> qrActivator({
    required String ssid,
    required String password,
    required String token,
  }) async {
    final started = await _methodChannel.invokeMethod<bool>('qrActivator', {
      'ssid': ssid,
      'password': password,
      'token': token,
    });
    return started ?? false;
  }

  /// Set log level (DEBUG, INFO, WARNING, ERROR)
  @override
  Future<void> setLogLevel(int levelIndex) async {
    await _methodChannel.invokeMethod('setLogLevel', levelIndex);
  }
}
