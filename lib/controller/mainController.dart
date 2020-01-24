import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';

import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_upload_ftp/controller/locationController.dart';
import 'package:flutter_upload_ftp/controller/servicesController.dart';
import 'package:flutter_upload_ftp/setup.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

class MainController with ChangeNotifier {
  final location = locator<LocationController>();
  final services = locator<ServicesController>();

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  double lat = 0.0;
  double lng = 0.0;

  String guid;

  CameraDescription firstCamera;

  List<CameraDescription> cameras;

  CameraController controller;

  Future<void> initializeControllerFuture;

  String delay;

  MainController() {
    getGuid();
  }

  void initCamera() async {
    cameras = await availableCameras();
    firstCamera = cameras.first;
    print(firstCamera);
  }

  void initController() {
    controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    initializeControllerFuture = controller.initialize();
  }

  void disposeController() {
    controller.dispose();
  }

  void getGuid() async {
    guid = await getDeviceInfo();
  }

  Future<void> takePic() async {
    try {
      print('taking a pic');

      await initializeControllerFuture;

      await getLocation();

      final name =
          '[$guid]-[${DateTime.now().millisecondsSinceEpoch}]-[$lat]-[$lng].png';

      final paths = Path.join(
        (await getTemporaryDirectory()).path,
        '$name',
      );

      await controller.takePicture(paths);
      print('done taking photo $paths');

      await uploadImage(File(paths));
    } catch (e) {
      print('ada error $e');
    }
  }

  Future<void> uploadImage(File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));

    var length = await imageFile.length();

    var uri = Uri.parse('http://192.168.1.25:3000/');

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile('filename', stream, length,
        filename: Path.basename(imageFile.path));

    request.files.add(multipartFile);

    var response = await request.send();

    print(response.statusCode);

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<void> getLocation() async {
    var locationData = await location.getLocation();
    var now = DateTime.now();

    lat = locationData.latitude;
    lng = locationData.longitude;

    print('lat => $lat');
    print('lng => $lng');
    print('now => $now');
  }

  Future<String> getDeviceInfo() async {
    String identifier;

    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } catch (e) {
      print('Failed to get platform version $e');
    }

    return identifier;
  }

  Future<void> getConfig() async {
    final config = await services.getConfig(guid);
    delay = config.data;
  }
}
