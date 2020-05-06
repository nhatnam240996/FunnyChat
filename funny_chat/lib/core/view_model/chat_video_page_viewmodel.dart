import 'package:camera/camera.dart';

class ChatVideoPageViewModel {
  List<CameraDescription> cameras;
  CameraController cameraController;
  factory ChatVideoPageViewModel() => instance;

  ChatVideoPageViewModel._internal() {
    cameraController = CameraController(
      cameras[1],
      ResolutionPreset.high,
    );
  }

  static final ChatVideoPageViewModel instance =
      ChatVideoPageViewModel._internal();

  changeCamera() {}
}
