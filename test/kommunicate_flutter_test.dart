import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('kommunicate_flutter');

  setUp(() {
    // ignore: deprecated_member_use
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await KommunicateFlutterPlugin.platformVersion, '42');
  });
}
