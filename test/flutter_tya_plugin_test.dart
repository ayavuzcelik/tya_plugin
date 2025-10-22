import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tya_plugin/flutter_tya_plugin.dart';
import 'package:flutter_tya_plugin/flutter_tya_plugin_platform_interface.dart';
import 'package:flutter_tya_plugin/flutter_tya_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTyaPluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterTyaPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterTyaPluginPlatform initialPlatform = FlutterTyaPluginPlatform.instance;

  test('$MethodChannelFlutterTyaPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterTyaPlugin>());
  });

  test('getPlatformVersion', () async {
    FlutterTyaPlugin flutterTyaPlugin = FlutterTyaPlugin();
    MockFlutterTyaPluginPlatform fakePlatform = MockFlutterTyaPluginPlatform();
    FlutterTyaPluginPlatform.instance = fakePlatform;

    expect(await flutterTyaPlugin.getPlatformVersion(), '42');
  });
}
