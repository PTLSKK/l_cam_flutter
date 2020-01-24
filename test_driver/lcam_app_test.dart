import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  //
  SerializableFinder floatingActionButton =
      find.byValueKey('floatActionButton');
  SerializableFinder bodyCam = find.byValueKey('bodyCamera');

  //
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
  });

  // test
  test('Application Test', () async {
    await driver.waitFor(bodyCam, timeout: Duration(seconds: 5));
    await driver.waitFor(floatingActionButton, timeout: Duration(seconds: 5));
    await driver.tap(floatingActionButton, timeout: Duration(seconds: 5));
  });
}
