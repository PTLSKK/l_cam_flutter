import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_upload_ftp/controller/servicesController.dart';
import 'package:flutter_upload_ftp/model/Config.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('Fetch data from API', () {
    final client = MockClient();
    final controller = ServicesController();

    final urlConfig = 'http://192.168.1.25:3000/getconfig';

    String returnJson = '{'
        '"status": "success",'
        '"message": "success upload file to ftp",'
        '"data": "15"'
        '}';

    test('Fetch config data', () async {
      when(client.get(urlConfig))
          .thenAnswer((_) async => http.Response(returnJson, 200));

      final configData = await controller.getConfig('ae5d896b60203885');

      expect(configData, isInstanceOf<Config>());
    });
  });
}
