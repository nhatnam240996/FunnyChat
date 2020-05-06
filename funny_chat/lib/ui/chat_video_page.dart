import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/ui/widgets/call_video.dart';

class ChatVideoPage extends StatefulWidget {
  @override
  _ChatVideoPageState createState() => _ChatVideoPageState();
}

class _ChatVideoPageState extends State<ChatVideoPage> {
  int _cameraNumber = 0; // default main camera =1
  CameraController controller;
  List<CameraDescription> cameras;
  bool mute = false;

  /// Returns a suitable camera icon for [direction].
  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
    throw ArgumentError('Unknown lens direction');
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  @override
  void initState() {
    initialCamera();
    super.initState();
  }

  initialCamera() async {
    cameras = await availableCameras();
    controller = CameraController(
      cameras[1],
      ResolutionPreset.high,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 150,
              height: 225,
              child: controller?.value?.isInitialized == false
                  ? Container()
                  : _cameraPreviewWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RawMaterialButton(
                      padding: const EdgeInsets.all(12.0),
                      onPressed: () {
                        setState(() {
                          mute = !mute;
                        });
                      },
                      child: Icon(
                        mute ? Icons.mic_off : Icons.mic,
                        color: Colors.blueAccent,
                        size: 24.0,
                      ),
                      shape: CircleBorder(),
                      fillColor: Colors.white,
                    ),
                    RawMaterialButton(
                      padding: const EdgeInsets.all(12.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      shape: CircleBorder(),
                      fillColor: Colors.redAccent,
                    ),
                    RawMaterialButton(
                      padding: const EdgeInsets.all(12.0),
                      onPressed: _switchCamera,
                      child: Icon(
                        Icons.switch_camera,
                        color: Colors.blueAccent,
                        size: 24.0,
                      ),
                      shape: CircleBorder(),
                      fillColor: Colors.white,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  Future _switchCamera() async {
    if (controller != null) {
      await controller.dispose();
    }
    _cameraNumber == 0 ? _cameraNumber = 1 : _cameraNumber = 0;
    controller =
        CameraController(cameras[_cameraNumber], ResolutionPreset.medium);
    controller.addListener(() {
      if (mounted) setState(() {});
      // if (controller.value.hasError) {
      //   showInSnackBar('Camera error ${controller.value.errorDescription}');
      // }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  _streamVideo() async {
    await controller.startImageStream(
      (onValue) {
        print("${onValue.width}");
      },
    );
  }

  // _recordVideo() async {
  //   await controller.startImageStream(onAvailable)
  // }

  /// TODO end call video
  // _endCallVideo() {
  //   log("End call video");
  //   controller.dispose();
  //   Navigator.pop(context);
  // }
}
