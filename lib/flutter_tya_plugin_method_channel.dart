import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'flutter_tya_plugin_platform_interface.dart';

class MethodChannelFlutterTyaPlugin extends FlutterTyaPluginPlatform {
  
  @visibleForTesting
  final MethodChannel _methodChannel = const MethodChannel('flutter_tya_plugin/methods');

  /// Platform version example
  @override
  Future<String?> getPlatformVersion() async {
    final version = await _methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  /// SDK init
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

  /// Login or register with UID
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
  Future<List<Map<String, dynamic>>> queryHomeList() async {
    final result = await _methodChannel.invokeMethod('queryHomeList');
    if (result is List) {
      return result.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  /// Create new home
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
  Future<bool> deleteAllHomes() async {
    final result = await _methodChannel.invokeMethod<bool>('deleteAllHomes');
    return result ?? false;
  }

  /// Get device list for a home
  Future<List<Map<String, dynamic>>> getDeviceList(int homeId) async {
    final result = await _methodChannel.invokeMethod('getDeviceList', {
      'homeId': homeId,
    });
    if (result is List) {
      return result.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  /// Set log level (DEBUG, INFO, WARNING, ERROR)
  Future<void> setLogLevel(int levelIndex) async {
    await _methodChannel.invokeMethod('setLogLevel', levelIndex);
  }
}
