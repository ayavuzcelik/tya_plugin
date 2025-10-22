import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_tya_plugin_method_channel.dart';

abstract class FlutterTyaPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterTyaPluginPlatform.
  FlutterTyaPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTyaPluginPlatform _instance = MethodChannelFlutterTyaPlugin();

  /// The default instance of [FlutterTyaPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTyaPlugin].
  static FlutterTyaPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTyaPluginPlatform] when
  /// they register themselves.
  static set instance(FlutterTyaPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
