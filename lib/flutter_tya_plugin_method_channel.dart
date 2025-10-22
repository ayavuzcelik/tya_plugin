import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_tya_plugin_platform_interface.dart';

/// An implementation of [FlutterTyaPluginPlatform] that uses method channels.
class MethodChannelFlutterTyaPlugin extends FlutterTyaPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_tya_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
