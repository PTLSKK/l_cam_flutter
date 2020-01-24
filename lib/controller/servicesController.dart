import 'package:flutter_upload_ftp/model/Config.dart';
import 'package:http/http.dart' as http;

class ServicesController {
  Future<Config> getConfig(String guid) async {
    try {
      var client = http.Client();
      print('oke $guid');

      var response = await client.post(
        'http://192.168.1.25:3000/getconfig',
        body: {'guid': guid},
      );

      print(response.body);

      var config = configFromJson(response.body);

      return config;
    } catch (e) {
      print('[getConfig] an error ${e.message}');

      return null;
    }
  }
}
