import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_upload_ftp/controller/mainController.dart';
import 'package:flutter_upload_ftp/setup.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  setupLocator();

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider(
        create: (context) => MainController(),
        child: TakePictureScreen(
          camera: firstCamera,
        ),
      ),
    ),
  );
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;

  Future<void> _initializeControllerFuture;

  Timer timer;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();

    timer?.cancel();

    super.dispose();
  }

  Future<void> takePic() async {
    try {
      final state = Provider.of<MainController>(context, listen: false);

      await _initializeControllerFuture;

      await state.getLocation();

      final lat = state.lat;

      final lng = state.lng;

      print('taking a pic');

      final name =
          '[${state.guid}]-[${DateTime.now().millisecondsSinceEpoch}]-[$lat]-[$lng].png';

      final paths = join(
        (await getTemporaryDirectory()).path,
        '$name',
      );

      await _controller.takePicture(paths);

      print('done taking photo $paths');

      await state.uploadImage(File(paths));
    } catch (e) {
      print('ada error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainController>(context);
    return Scaffold(
      appBar: AppBar(title: Text('L-Cam')),
      body: FutureBuilder<void>(
        key: Key('bodyCamera'),
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: Key('floatActionButton'),
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          print('pressed');

          await provider.getConfig();

          var data = provider.delay;

          if (data != '-') {
            var dataInt = int.parse(data);
            timer = Timer.periodic(
              Duration(seconds: dataInt),
              (Timer t) => takePic(),
            );
          }
        },
      ),
    );
  }
}
