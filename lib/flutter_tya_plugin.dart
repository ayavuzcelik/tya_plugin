
import 'flutter_tya_plugin_platform_interface.dart';

class FlutterTyaPlugin {
  Future<String?> getPlatformVersion() {
    return FlutterTyaPluginPlatform.instance.getPlatformVersion();
  }
}
