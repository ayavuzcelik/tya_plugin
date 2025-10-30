import 'package:flutter/services.dart';
import 'package:flutter_tya_plugin/models/tuya_device_model.dart';
import 'package:flutter_tya_plugin/models/tuya_home_model.dart';
import 'package:flutter_tya_plugin/models/tuya_user_model.dart';
import 'flutter_tya_plugin_platform_interface.dart';

class MethodChannelFlutterTyaPlugin extends FlutterTyaPluginPlatform {
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

  /// Login or register with UID
  @override
  Future<TuyaUserModel> loginOrRegisterWithUid({
    required String countryCode,
    required String uid,
    required String password,
  }) async {
    final user = await _methodChannel.invokeMethod('loginOrRegisterWithUid', {
      'countryCode': countryCode,
      'uid': uid,
      'password': password,
    });

    return TuyaUserModel.fromJson(user);
  }

  /// Query home list
  @override
  Future<List<TuyaHomeModel>> queryHomeList() async {
    final result = await _methodChannel.invokeMethod('queryHomeList');
    if (result is List) {
      return result.map((e) => TuyaHomeModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Create new home
  @override
  Future<TuyaHomeModel> createHome({
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
    return result;
  }

  /// Get device list for a home
  @override
  Future<List<TuyaDeviceModel>> getDeviceList(int homeId) async {
    final result = await _methodChannel.invokeMethod('getDeviceList', {
      'homeId': homeId,
    });
    if (result is List) {
      return result.map((e) => TuyaDeviceModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Stream<dynamic> subscribeToEvents() {
    return _eventChannel.receiveBroadcastStream();
  }

  @override
  Future<String?> getActivatorToken(int homeId) async {
    final token = await _methodChannel.invokeMethod<String>(
      'getActivatorToken',
      {'homeId': homeId},
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
