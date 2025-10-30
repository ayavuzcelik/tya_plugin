import 'package:flutter_tya_plugin/models/tuya_device_model.dart';
import 'package:flutter_tya_plugin/models/tuya_home_model.dart';
import 'package:flutter_tya_plugin/models/tuya_user_model.dart';

import 'flutter_tya_plugin_platform_interface.dart';

class FlutterTyaPlugin {
  static final FlutterTyaPlugin instance = FlutterTyaPlugin._internal();

  FlutterTyaPlugin._internal();

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

  /// Login or register user with UID
  Future<TuyaUserModel?> loginOrRegisterWithUid({
    required String countryCode,
    required String uid,
    required String password,
  }) async {
    try {
      final result = await FlutterTyaPluginPlatform.instance
          .loginOrRegisterWithUid(
            countryCode: countryCode,
            uid: uid,
            password: password,
          );
      return result;
    } catch (e) {
      return null;
    }
  }

  /// Query all homes
  Future<List<TuyaHomeModel>?> queryHomeList() async {
    try {
      final result = await FlutterTyaPluginPlatform.instance.queryHomeList();
      return result;
    } catch (e) {
      return null;
    }
  }

  /// Create new home
  Future<TuyaHomeModel?> createHome({
    required String name,
    required double latitude,
    required double longitude,
    required String geoName,
    List<String>? rooms,
  }) async {
    try {
      final result = await FlutterTyaPluginPlatform.instance.createHome(
        name: name,
        latitude: latitude,
        longitude: longitude,
        geoName: geoName,
        rooms: rooms,
      );
      return result;
    } catch (e) {
      return null;
    }
  }

  /// Get device list for a home
  Future<List<TuyaDeviceModel>?> getDeviceList(int homeId) async {
    try {
      final result = await FlutterTyaPluginPlatform.instance.getDeviceList(
        homeId,
      );
      return result;
    } catch (e) {
      return null;
    }
  }

  /// Subscribe all events
  Stream<dynamic> subscribeToEvents() {
    return FlutterTyaPluginPlatform.instance.subscribeToEvents();
  }

  /// Get Activator Token
  Future<String?> getActivatorToken(int homeId) async {
    final result = await FlutterTyaPluginPlatform.instance.getActivatorToken(
      homeId,
    );
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
